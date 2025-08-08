-- 第一步：筛选钻石客户
with diamond_customers as (
    select cust_id
    from ant_icube_dev.credit_card_customer_base
    where customer_segment = 'Diamond'
),

-- 第二步：获取钻石客户关联的信用卡
related_cards as (
    select card_number
    from ant_icube_dev.credit_card_card_base
    where cust_id in (select cust_id from diamond_customers)
),

-- 第三步：筛选2016年12月的交易记录
valid_transactions as (
    select 
        t.credit_card_id as `credit_card_id`,
        t.transaction_date as `transaction_date`,
        t.transaction_id as `transaction_id`,
        t.transaction_segment as `transaction_segment`,
        t.transaction_value as `transaction_value`
    from ant_icube_dev.credit_card_transaction_base t
    where
        t.credit_card_id in (select card_number from related_cards)
        and to_date(t.transaction_date, 'yyyy-MM-dd') between to_date('2016-12-01', 'yyyy-MM-dd') and to_date('2016-12-31', 'yyyy-MM-dd')
)

-- 最终查询：返回交易记录和平均交易金额
select 
    `credit_card_id` as `信用卡号`,
    `transaction_date` as `交易日期`,
    `transaction_id` as `交易ID`,
    `transaction_segment` as `交易类型`,
    `transaction_value` as `交易金额`,
    (select avg(cast(`transaction_value` as double)) from valid_transactions) as `平均交易金额`
from 
    valid_transactions;