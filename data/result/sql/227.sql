WITH fraud_transactions AS (
    SELECT 
        t.transaction_id,
        t.credit_card_id,
        t.transaction_value
    FROM 
        ant_icube_dev.credit_card_fraud_base f
        JOIN ant_icube_dev.credit_card_transaction_base t 
            ON f.transaction_id = t.transaction_id
    WHERE 
        TRIM(f.fraud_flag) = '1'
),
card_transactions AS (
    SELECT 
        f.transaction_id,
        c.card_family,
        CAST(f.transaction_value AS DOUBLE) as trans_value,
        f.credit_card_id
    FROM 
        fraud_transactions f
        JOIN ant_icube_dev.credit_card_card_base c 
            ON f.credit_card_id = c.card_number
),
card_avg AS (
    SELECT 
        card_family,
        AVG(trans_value) as avg_value
    FROM 
        card_transactions
    GROUP BY 
        card_family
)
SELECT 
    ct.credit_card_id as `credit_card_id`,
    ct.transaction_id as `transaction_id`,
    ct.trans_value as `transaction_value`,
    ct.card_family as `card_family`,
    ca.avg_value as `avg_transaction_value`
FROM 
    card_transactions ct
    JOIN card_avg ca 
        ON ct.card_family = ca.card_family
WHERE 
    ct.trans_value > ca.avg_value;