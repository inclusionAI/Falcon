with fraud_transaction as (
    select 
        t.credit_card_id,
        t.transaction_segment,
        t.transaction_value,
        t.transaction_id
    from 
        ant_icube_dev.credit_card_transaction_base t
    inner join ant_icube_dev.credit_card_fraud_base f 
        on t.transaction_id = f.transaction_id
    where 
        trim(f.fraud_flag) = '1'
),
transaction_with_card as (
    select 
        ft.transaction_segment,
        ft.transaction_value,
        c.card_family
    from 
        fraud_transaction ft
    inner join ant_icube_dev.credit_card_card_base c 
        on ft.credit_card_id = c.card_number
)
select 
    transaction_segment as `交易分段`,
    card_family as `卡族`,
    count(*) as `欺诈交易次数`,
    avg(cast(transaction_value as bigint)) as `平均交易金额`
from 
    transaction_with_card
group by 
    transaction_segment,
    card_family
having 
    count(*) > 1 
    and avg(cast(transaction_value as bigint)) > 20000;