with fraud_transactions as (
    select 
        t.transaction_id,
        t.credit_card_id,
        cast(t.transaction_value as bigint) as transaction_value
    from 
        ant_icube_dev.credit_card_transaction_base t
    join 
        ant_icube_dev.credit_card_fraud_base f
    on 
        t.transaction_id = f.transaction_id
    where 
        f.fraud_flag = '1'
),
transaction_card as (
    select 
        ft.transaction_value,
        c.cust_id
    from 
        fraud_transactions ft
    join 
        ant_icube_dev.credit_card_card_base c
    on 
        ft.credit_card_id = c.card_number
),
customer_groups as (
    select 
        tc.transaction_value,
        cu.customer_segment
    from 
        transaction_card tc
    join 
        ant_icube_dev.credit_card_customer_base cu
    on 
        tc.cust_id = cu.cust_id
),
group_amounts as (
    select 
        customer_segment,
        sum(transaction_value) as total_amount
    from 
        customer_groups
    group by 
        customer_segment
),
total_fraud as (
    select 
        sum(total_amount) as overall_total
    from 
        group_amounts
)
select 
    ga.customer_segment as `客户分组`,
    ga.total_amount as `欺诈总金额`,
    (ga.total_amount / (select overall_total from total_fraud)) * 100 as `金额占比`,
    dense_rank() over (order by (ga.total_amount / (select overall_total from total_fraud)) desc) as `百分比排名`
from 
    group_amounts ga
order by 
    `百分比排名`;