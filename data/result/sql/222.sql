WITH platinum_cards AS (
    SELECT
        card_number
    FROM
        ant_icube_dev.credit_card_card_base
    WHERE
        card_family = 'Platinum'
),
platinum_transactions AS (
    SELECT
        t.transaction_id,
        t.transaction_value
    FROM
        ant_icube_dev.credit_card_transaction_base t
    JOIN
        platinum_cards p
    ON
        t.credit_card_id = p.card_number
),
avg_transaction_value AS (
    SELECT
        AVG(CAST(transaction_value AS DOUBLE)) AS avg_value
    FROM
        platinum_transactions
)
SELECT
    COUNT(*) AS `交易笔数`
FROM
    platinum_transactions t
WHERE
    CAST(t.transaction_value AS DOUBLE) > (SELECT avg_value FROM avg_transaction_value);