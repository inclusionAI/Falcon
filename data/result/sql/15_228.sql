WITH customer_usage AS (
    SELECT 
        c.cust_id,
        SUM(CAST(c.credit_limit AS DOUBLE)) AS total_credit_limit,
        SUM(CAST(t.transaction_value AS DOUBLE)) AS total_spent,
        cs.customer_vintage_group
    FROM 
        ant_icube_dev.credit_card_card_base c
    JOIN ant_icube_dev.credit_card_customer_base cs 
        ON c.cust_id = cs.cust_id
    JOIN ant_icube_dev.credit_card_transaction_base t 
        ON c.card_number = t.credit_card_id
    GROUP BY 
        c.cust_id, cs.customer_vintage_group
),
group_avg_usage AS (
    SELECT 
        customer_vintage_group,
        AVG(total_spent / total_credit_limit) AS avg_usage_rate
    FROM 
        customer_usage
    GROUP BY 
        customer_vintage_group
)
SELECT 
    cu.cust_id,
    cu.customer_vintage_group,
    (cu.total_spent / cu.total_credit_limit) AS `usage_rate`,
    gau.avg_usage_rate
FROM 
    customer_usage cu
JOIN group_avg_usage gau 
    ON cu.customer_vintage_group = gau.customer_vintage_group
WHERE 
    (cu.total_spent / cu.total_credit_limit) > gau.avg_usage_rate;