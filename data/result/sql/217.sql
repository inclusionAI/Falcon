with diamond_customers as (
    select cust_id
    from ant_icube_dev.credit_card_customer_base
    where customer_segment = 'Diamond'
),
fraud_transactions as (
    select transaction_id
    from ant_icube_dev.credit_card_fraud_base
    where fraud_flag = '1'
),
card_transactions as (
    select 
        t.credit_card_id,
        t.transaction_id,
        t.transaction_date,
        t.transaction_value
    from ant_icube_dev.credit_card_transaction_base t
    inner join fraud_transactions f
    on t.transaction_id = f.transaction_id
),
joined_data as (
    select
        c.cust_id,
        ct.transaction_id,
        ct.transaction_date,
        ct.transaction_value
    from card_transactions ct
    inner join ant_icube_dev.credit_card_card_base cb
    on ct.credit_card_id = cb.card_number
    inner join diamond_customers c
    on cb.cust_id = c.cust_id
),
ranked_transactions as (
    select
        cust_id,
        transaction_id,
        transaction_value,
        row_number() over (
            partition by cust_id
            order by to_date(transaction_date, 'D-MON-YYYY') desc
        ) as transaction_rank
    from joined_data
),
recent_three as (
    select
        cust_id,
        transaction_id,
        transaction_value
    from ranked_transactions
    where transaction_rank <= 3
)
select
    cust_id as `cust_id`,
    transaction_id as `transaction_id`,
    transaction_value as `transaction_value`,
    rank() over (
        partition by cust_id
        order by cast(transaction_value as bigint) desc
    ) as `amount_rank`
from recent_three;