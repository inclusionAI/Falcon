with fraud_transactions as (
    select 
        f.transaction_id,
        t.credit_card_id,
        cast(t.transaction_value as double) as trans_value
    from 
        ant_icube_dev.credit_card_fraud_base f
    join 
        ant_icube_dev.credit_card_transaction_base t 
    on 
        f.transaction_id = t.transaction_id
    where 
        f.fraud_flag = '1'
),

card_cust_mapping as (
    select 
        c.card_number,
        c.cust_id
    from 
        ant_icube_dev.credit_card_card_base c
),

customer_groups as (
    select 
        cust_id,
        customer_segment
    from 
        ant_icube_dev.credit_card_customer_base
)

select 
    cg.customer_segment as `客户分组`,
    avg(ft.trans_value) as `欺诈交易金额平均值`
from 
    fraud_transactions ft
join 
    card_cust_mapping ccm 
on 
    ft.credit_card_id = ccm.card_number
join 
    customer_groups cg 
on 
    ccm.cust_id = cg.cust_id
group by 
    cg.customer_segment;