with 
-- 获取VG1客户对应的卡号和年龄
vg1_customer_cards as (
    select 
        card.card_number,
        cast(cust.age as double) as age
    from 
        ant_icube_dev.credit_card_customer_base cust
    join 
        ant_icube_dev.credit_card_card_base card
        on cust.cust_id = card.cust_id
    where 
        cust.customer_vintage_group = 'VG1'
),

-- 获取欺诈交易记录及关联卡号
fraud_transactions as (
    select 
        trans.credit_card_id,
        cast(trans.transaction_value as double) as transaction_value
    from 
        ant_icube_dev.credit_card_transaction_base trans
    join 
        ant_icube_dev.credit_card_fraud_base fraud
        on trans.transaction_id = fraud.transaction_id
    where 
        fraud.fraud_flag = '1'
)

-- 计算交易金额/年龄比值并排序
select 
    ft.transaction_value / vcc.age as `交易金额/年龄比值`
from 
    fraud_transactions ft
join 
    vg1_customer_cards vcc
    on ft.credit_card_id = vcc.card_number
order by 
    `交易金额/年龄比值` desc;