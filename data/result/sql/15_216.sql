with fraud_transactions as (
    -- 获取所有欺诈交易记录
    select
        f.transaction_id,
        t.credit_card_id,
        t.transaction_value
    from
        ant_icube_dev.credit_card_fraud_base f
    join ant_icube_dev.credit_card_transaction_base t
        on f.transaction_id = t.transaction_id
    where
        trim(f.fraud_flag) = '1'
),

card_relationships as (
    -- 关联信用卡和客户信息
    select
        c.card_number,
        c.cust_id,
        c.credit_limit
    from
        ant_icube_dev.credit_card_card_base c
),

transaction_details as (
    -- 关联欺诈交易与信用卡额度信息
    select
        fr.credit_card_id,
        fr.transaction_value,
        cr.cust_id,
        cr.credit_limit
    from
        fraud_transactions fr
    join card_relationships cr
        on fr.credit_card_id = cr.card_number
),

ratio_calculation as (
    -- 计算每笔交易占信用额度的比例
    select
        cust_id,
        cast(transaction_value as double) / cast(credit_limit as double) as usage_ratio
    from
        transaction_details
),

avg_ratio as (
    -- 按客户统计平均使用比例
    select
        cust_id,
        avg(usage_ratio) as avg_ratio
    from
        ratio_calculation
    group by
        cust_id
)

-- 计算最终排名
select
    cust_id as `客户ID`,
    avg_ratio as `平均使用比例`,
    rank() over (order by avg_ratio desc) as `排名`
from
    avg_ratio
order by
    `排名`;