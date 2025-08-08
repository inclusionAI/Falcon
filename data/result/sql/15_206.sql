with card_avg_transaction as (
    select
        cb.card_family,
        avg(cast(tb.transaction_value as double)) as avg_trans_value
    from
        ant_icube_dev.credit_card_transaction_base tb
    join
        ant_icube_dev.credit_card_card_base cb
        on tb.credit_card_id = cb.card_number
    group by
        cb.card_family
    having
        avg(cast(tb.transaction_value as double)) > 10000
),
card_customer_credit as (
    select
        cb.card_family,
        cu.customer_segment,
        cast(cb.credit_limit as double) as credit_limit
    from
        ant_icube_dev.credit_card_card_base cb
    join
        ant_icube_dev.credit_card_customer_base cu
        on cb.cust_id = cu.cust_id
    where
        cb.card_family in (select card_family from card_avg_transaction)
),
customer_segment_avg_credit as (
    select
        customer_segment,
        avg(credit_limit) as avg_credit_limit
    from
        card_customer_credit
    group by
        customer_segment
    having
        avg(credit_limit) > 50000
)
select distinct
    ccc.card_family,
    csac.customer_segment
from
    card_customer_credit ccc
join
    customer_segment_avg_credit csac
    on ccc.customer_segment = csac.customer_segment;