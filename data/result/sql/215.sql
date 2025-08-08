WITH diamond_customers AS (
    SELECT cust_id
    FROM ant_icube_dev.credit_card_customer_base
    WHERE customer_segment = 'Diamond'
),
customer_cards AS (
    SELECT card_number, cust_id
    FROM ant_icube_dev.credit_card_card_base
    WHERE cust_id IN (SELECT cust_id FROM diamond_customers)
),
related_transactions AS (
    SELECT 
        t.credit_card_id,
        t.transaction_date,
        t.transaction_id,
        t.transaction_segment,
        t.transaction_value,
        c.cust_id
    FROM ant_icube_dev.credit_card_transaction_base t
    INNER JOIN customer_cards c
    ON t.credit_card_id = c.card_number
),
customer_avg AS (
    SELECT 
        cust_id,
        AVG(CAST(transaction_value AS BIGINT)) AS avg_value
    FROM related_transactions
    GROUP BY cust_id
)
SELECT 
    credit_card_id AS `credit_card_id`,
    transaction_date AS `transaction_date`,
    transaction_id AS `transaction_id`,
    transaction_segment AS `transaction_segment`,
    transaction_value AS `transaction_value`
FROM related_transactions rt
INNER JOIN customer_avg ca
ON rt.cust_id = ca.cust_id
WHERE CAST(rt.transaction_value AS BIGINT) > ca.avg_value
ORDER BY transaction_date DESC;