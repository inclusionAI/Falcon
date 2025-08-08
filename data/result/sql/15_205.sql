with joined_data as (
    select
        cccb2.customer_segment,
        ccfb.fraud_flag,
        ccctb.transaction_id
    from
        ant_icube_dev.credit_card_transaction_base ccctb
        join ant_icube_dev.credit_card_fraud_base ccfb 
            on ccctb.transaction_id = ccfb.transaction_id
        join ant_icube_dev.credit_card_card_base cccb 
            on ccctb.credit_card_id = cccb.card_number
        join ant_icube_dev.credit_card_customer_base cccb2 
            on cccb.cust_id = cccb2.cust_id
)

select
    customer_segment as `客户分组`,
    count(case when fraud_flag = '1' then transaction_id end) / count(*) as `欺诈交易占比`
from
    joined_data
group by
    customer_segment;