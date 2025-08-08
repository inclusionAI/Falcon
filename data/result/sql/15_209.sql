with card_avg_limit as (
    select 
        card_family,
        avg(cast(credit_limit as bigint)) as avg_limit
    from 
        ant_icube_dev.credit_card_card_base
    group by 
        card_family
    having 
        avg(cast(credit_limit as bigint)) > 60000
),
transaction_stats as (
    select 
        c.card_family,
        avg(cast(t.transaction_value as bigint)) as avg_value
    from 
        ant_icube_dev.credit_card_transaction_base t
        join ant_icube_dev.credit_card_card_base c 
            on t.credit_card_id = c.card_number
    group by 
        c.card_family
    having 
        avg(cast(t.transaction_value as bigint)) > 10000
)
select 
    l.card_family as `卡族`,
    l.avg_limit as `平均信用限额`,
    s.avg_value as `平均交易金额`
from 
    card_avg_limit l
    join transaction_stats s 
        on l.card_family = s.card_family;