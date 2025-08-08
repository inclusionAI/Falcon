with platinum_cards as (
    select
        card.card_number,
        cast(card.credit_limit as bigint) as credit_limit,
        cust.customer_vintage_group
    from
        ant_icube_dev.credit_card_card_base card
    inner join
        ant_icube_dev.credit_card_customer_base cust
    on
        card.cust_id = cust.cust_id
    where
        card.card_family = 'Platinum'
),
card_transactions as (
    select
        trans.credit_card_id,
        sum(cast(trans.transaction_value as bigint)) as total_spent
    from
        ant_icube_dev.credit_card_transaction_base trans
    group by
        trans.credit_card_id
)
select
    pc.customer_vintage_group as `客户资历`,
    sum(coalesce(ct.total_spent, 0)) * 1.0 / sum(pc.credit_limit) as `信用额度使用率`
from
    platinum_cards pc
left join
    card_transactions ct
on
    pc.card_number = ct.credit_card_id
group by
    pc.customer_vintage_group;