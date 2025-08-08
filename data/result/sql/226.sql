with fraud_transactions as (
    select 
        cu.cust_id,
        cu.customer_segment
    from 
        ant_icube_dev.credit_card_fraud_base f
        join ant_icube_dev.credit_card_transaction_base t on f.transaction_id = t.transaction_id
        join ant_icube_dev.credit_card_card_base c on t.credit_card_id = c.card_number
        join ant_icube_dev.credit_card_customer_base cu on c.cust_id = cu.cust_id
    where 
        trim(f.fraud_flag) = '1'
),
customer_counts as (
    select 
        cust_id,
        customer_segment,
        count(*) as fraud_count
    from 
        fraud_transactions
    group by 
        cust_id, customer_segment
),
segment_averages as (
    select 
        customer_segment,
        avg(fraud_count) as avg_fraud_count
    from 
        customer_counts
    group by 
        customer_segment
)
select 
    cc.cust_id as `客户id`,
    cc.customer_segment as `客户分组`,
    cc.fraud_count as `欺诈次数`,
    sa.avg_fraud_count as `平均欺诈次数`
from 
    customer_counts cc
    join segment_averages sa on cc.customer_segment = sa.customer_segment
where 
    cc.fraud_count > sa.avg_fraud_count;