with customer_family_avg as (
    select
        cust_id,
        card_family,
        avg(cast(credit_limit as bigint)) as avg_credit
    from
        ant_icube_dev.credit_card_card_base
    group by
        cust_id,
        card_family
)
select
    card_family as `信用卡家族`,
    avg(avg_credit) as `客户平均信用额度`
from
    customer_family_avg
group by
    card_family;