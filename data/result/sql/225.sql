WITH diamond_customers AS (
    SELECT cust_id
    FROM ant_icube_dev.credit_card_customer_base
    WHERE customer_segment = 'Diamond'
),
card_info AS (
    SELECT card_number, credit_limit
    FROM ant_icube_dev.credit_card_card_base
    WHERE cust_id IN (SELECT cust_id FROM diamond_customers)
),
valid_transactions AS (
    SELECT 
        t.credit_card_id,
        t.transaction_id,
        t.transaction_value,
        t.transaction_date,
        t.transaction_segment,
        c.credit_limit
    FROM ant_icube_dev.credit_card_transaction_base t
    INNER JOIN ant_icube_dev.credit_card_fraud_base f
        ON t.transaction_id = f.transaction_id
    INNER JOIN card_info c
        ON t.credit_card_id = c.card_number
    WHERE f.fraud_flag = '1'
)
SELECT
    transaction_id AS `transaction_id`,
    credit_card_id AS `credit_card_id`,
    transaction_date AS `transaction_date`,
    transaction_value AS `transaction_value`,
    credit_limit AS `credit_limit`,
    transaction_segment AS `transaction_segment`
FROM valid_transactions
WHERE CAST(transaction_value AS BIGINT) > CAST(credit_limit AS BIGINT) * 0.8;