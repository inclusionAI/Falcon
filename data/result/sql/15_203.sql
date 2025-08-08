WITH fraud_transactions AS (
    SELECT 
        t.credit_card_id,
        t.transaction_value
    FROM 
        ant_icube_dev.credit_card_fraud_base f
    JOIN 
        ant_icube_dev.credit_card_transaction_base t 
        ON f.transaction_id = t.transaction_id
    WHERE 
        f.fraud_flag = '1'
),
card_info AS (
    SELECT 
        c.cust_id,
        ft.transaction_value
    FROM 
        fraud_transactions ft
    JOIN 
        ant_icube_dev.credit_card_card_base c 
        ON ft.credit_card_id = c.card_number
),
customer_info AS (
    SELECT 
        CAST(ci.transaction_value AS DECIMAL) AS trans_value,
        cu.customer_segment
    FROM 
        card_info ci
    JOIN 
        ant_icube_dev.credit_card_customer_base cu 
        ON ci.cust_id = cu.cust_id
)
SELECT 
    customer_segment AS `客户分组`,
    AVG(trans_value) AS `平均欺诈交易金额`
FROM 
    customer_info
GROUP BY 
    customer_segment;