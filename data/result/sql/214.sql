with fraud_transactions as (
    select 
        t.credit_card_id,
        t.transaction_date,
        t.transaction_id,
        t.transaction_value
    from 
        ant_icube_dev.credit_card_transaction_base t
    join 
        ant_icube_dev.credit_card_fraud_base f 
    on 
        t.transaction_id = f.transaction_id
    where 
        f.fraud_flag = '1'
),
card_cust as (
    select 
        ft.*,
        cb.cust_id
    from 
        fraud_transactions ft
    join 
        ant_icube_dev.credit_card_card_base cb 
    on 
        ft.credit_card_id = cb.card_number
),
cust_info as (
    select 
        cc.*,
        cu.customer_segment,
        to_date(
            concat(
                '20', 
                split_part(cc.transaction_date, '-', 3), 
                '-',
                case split_part(cc.transaction_date, '-', 2)
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
                lpad(split_part(cc.transaction_date, '-', 1), 2, '0')
            ),
            'yyyy-mm-dd'
        ) as transaction_date_real
    from 
        card_cust cc
    join 
        ant_icube_dev.credit_card_customer_base cu 
    on 
        cc.cust_id = cu.cust_id
),
ranked_transactions as (
    select 
        *,
        row_number() over (
            partition by cust_id 
            order by transaction_date_real
        ) as rn
    from 
        cust_info
)
select 
    cust_id as `客户ID`,
    customer_segment as `客户等级`,
    transaction_value as `交易金额`,
    transaction_date as `交易日期`
from 
    ranked_transactions
where 
    rn = 1
order by 
    cust_id;