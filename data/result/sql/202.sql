WITH transaction_card AS (
    SELECT 
        c.card_family,
        CAST(t.transaction_value AS DECIMAL) AS transaction_value
    FROM 
        ant_icube_dev.credit_card_transaction_base t
    JOIN 
        ant_icube_dev.credit_card_card_base c 
        ON t.credit_card_id = c.card_number
),
aggregated_data AS (
    SELECT 
        card_family,
        SUM(transaction_value) AS total_transaction,
        COUNT(*) AS transaction_count
    FROM 
        transaction_card
    GROUP BY 
        card_family
)
SELECT 
    card_family AS `卡家族`,
    total_transaction AS `总交易额`,
    total_transaction / transaction_count AS `平均每笔交易金额`
FROM 
    aggregated_data
WHERE 
    total_transaction > 100000;