with vg1_customer as (
    select cust_id
    from ant_icube_dev.credit_card_customer_base
    where customer_vintage_group = 'VG1'
),
card_limit as (
    select 
        card_number,
        cast(credit_limit as decimal) as credit_limit
    from ant_icube_dev.credit_card_card_base
    where cust_id in (select cust_id from vg1_customer)
),
qualified_trans as (
    select 
        t.transaction_id,
        cast(t.transaction_value as decimal) as trans_value,
        c.credit_limit
    from ant_icube_dev.credit_card_transaction_base t
    inner join card_limit c
    on t.credit_card_id = c.card_number
)
select 
    transaction_id as `transaction_id`,
    trans_value as `transaction_value`,
    credit_limit as `credit_limit`
from qualified_trans
where trans_value > (credit_limit * 0.5);