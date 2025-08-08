with fraud_transactions as (
    select
        transaction_id
    from
        ant_icube_dev.credit_card_fraud_base
    where
        fraud_flag = '1'
),

-- 步骤2: 关联欺诈交易与交易表获取交易金额和卡号
fraud_transaction_details as (
    select
        t.credit_card_id,
        t.transaction_value,
        t.transaction_id
    from
        ant_icube_dev.credit_card_transaction_base t
    inner join
        fraud_transactions f
    on
        t.transaction_id = f.transaction_id
),

-- 步骤3: 关联交易与卡表获取卡种和客户ID
card_info as (
    select
        c.card_family,
        c.cust_id,
        d.transaction_value
    from
        fraud_transaction_details d
    inner join
        ant_icube_dev.credit_card_card_base c
    on
        d.credit_card_id = c.card_number
),

-- 步骤4: 关联卡表与客户表获取客户年龄
customer_info as (
    select
        i.card_family,
        cu.age,
        i.transaction_value
    from
        card_info i
    inner join
        ant_icube_dev.credit_card_customer_base cu
    on
        i.cust_id = cu.cust_id
)

-- 步骤5: 按卡种分组计算平均年龄和最大交易金额
select
    card_family as `card_family`,
    cast(avg(cast(age as bigint)) as string) as `avg_age`,
    cast(max(cast(transaction_value as bigint)) as string) as `max_transaction_value`
from
    customer_info
group by
    card_family;