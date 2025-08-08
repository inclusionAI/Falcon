with customer_card as (
    select
        cb.cust_id,
        cb.card_number,
        cu.customer_segment
    from
        ant_icube_dev.credit_card_card_base cb
    join
        ant_icube_dev.credit_card_customer_base cu
    on
        cb.cust_id = cu.cust_id
),
fraud_transaction as (
    select
        t.credit_card_id,
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
)
select
    avg(cast(ft.transaction_value as double)) as `欺诈交易平均金额`
from
    fraud_transaction ft
join
    customer_card cc
on
    ft.credit_card_id = cc.card_number
where
    cc.customer_segment = 'Diamond';