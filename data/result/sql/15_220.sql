with transaction_fraud_data as (
    select 
        t.transaction_id,
        f.fraud_flag,
        t.credit_card_id
    from 
        ant_icube_dev.credit_card_transaction_base t
    inner join 
        ant_icube_dev.credit_card_fraud_base f 
    on 
        t.transaction_id = f.transaction_id
),

card_customer_data as (
    select
        c.card_number,
        c.cust_id
    from
        ant_icube_dev.credit_card_card_base c
),

full_transaction_info as (
    select
        tfd.*,
        ccd.cust_id
    from
        transaction_fraud_data tfd
    inner join
        card_customer_data ccd
    on
        tfd.credit_card_id = ccd.card_number
)

select
    c.customer_segment as `客户分组`,
    sum(case when f.fraud_flag = '1' then 1 else 0 end) as `欺诈交易笔数`,
    count(*) as `总交易笔数`,
    (sum(case when f.fraud_flag = '1' then 1 else 0 end) * 1.0 / count(*)) as `欺诈交易占比`
from
    full_transaction_info fti
inner join
    ant_icube_dev.credit_card_customer_base c
on
    fti.cust_id = c.cust_id
left join
    ant_icube_dev.credit_card_fraud_base f
on
    fti.transaction_id = f.transaction_id
group by
    c.customer_segment;