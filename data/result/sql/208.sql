with avg_credit as (
    select
        ccb.customer_segment,
        avg(cast(ccc.credit_limit as decimal)) as avg_credit_limit
    from
        ant_icube_dev.credit_card_customer_base ccb
    join
        ant_icube_dev.credit_card_card_base ccc
        on ccb.cust_id = ccc.cust_id
    group by
        ccb.customer_segment
    having
        avg(cast(ccc.credit_limit as decimal)) > 50000
),
avg_transaction as (
    select
        ccb.customer_segment,
        avg(cast(cct.transaction_value as decimal)) as avg_transaction_value
    from
        ant_icube_dev.credit_card_customer_base ccb
    join
        ant_icube_dev.credit_card_card_base ccc
        on ccb.cust_id = ccc.cust_id
    join
        ant_icube_dev.credit_card_transaction_base cct
        on ccc.card_number = cct.credit_card_id
    group by
        ccb.customer_segment
    having
        avg(cast(cct.transaction_value as decimal)) > 15000
)
select
    a.customer_segment as `客户分组`,
    a.avg_credit_limit as `平均信用限额`,
    b.avg_transaction_value as `平均交易金额`
from
    avg_credit a
join
    avg_transaction b
    on a.customer_segment = b.customer_segment;