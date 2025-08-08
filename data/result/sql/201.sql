with transaction_fraud as (
    select
        t.transaction_segment,
        case when trim(f.fraud_flag) = '1' then 1 else 0 end as is_fraud
    from
        ant_icube_dev.credit_card_transaction_base t
    left join
        ant_icube_dev.credit_card_fraud_base f
    on
        t.transaction_id = f.transaction_id
)
select
    transaction_segment,
    sum(is_fraud) as fraud_count,
    count(*) as total_count,
    sum(is_fraud)/count(*) as fraud_ratio
from
    transaction_fraud
group by
    transaction_segment
having
    sum(is_fraud) > 2;