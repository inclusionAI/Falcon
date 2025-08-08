with gold_customers as (
    select cust_id
    from ant_icube_dev.credit_card_customer_base
    where customer_segment = 'Gold'
),
gold_cards as (
    select 
        cb.cust_id,
        cb.card_number,
        cast(cb.credit_limit as bigint) as credit_limit
    from ant_icube_dev.credit_card_card_base cb
    inner join gold_customers gc on cb.cust_id = gc.cust_id
),
max_credit as (
    select max(credit_limit) as max_limit
    from gold_cards
),
top_cards as (
    select gc.card_number
    from gold_cards gc
    inner join max_credit mc on gc.credit_limit = mc.max_limit
),
transaction_ranks as (
    select 
        t.credit_card_id,
        t.transaction_value,
        row_number() over (partition by t.credit_card_id order by to_date(
            concat(
                '20', 
                split_part(t.transaction_date, '-', 3), 
                '-',
                case split_part(t.transaction_date, '-', 2)
                    when 'Jan' then '01'
                    when 'Feb' then '02'
                    when 'Mar' then '03'
                    when 'Apr' then '04'
                    when 'May' then '05'
                    when 'Jun' then '06'
                    when 'Jul' then '07'
                    when 'Aug' then '08'
                    when 'Sep' then '09'
                    when 'Oct' then '10'
                    when 'Nov' then '11'
                    when 'Dec' then '12'
                end,
                '-',
                lpad(split_part(t.transaction_date, '-', 1), 2, '0')
            ),
            'yyyy-mm-dd'
        ) desc) as rn
    from ant_icube_dev.credit_card_transaction_base t
    inner join top_cards tc on t.credit_card_id = tc.card_number
)
select 
    transaction_value as `最近交易金额`
from transaction_ranks
where rn = 1;