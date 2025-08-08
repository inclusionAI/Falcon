WITH sales_rank_cte AS (
    SELECT
        s.store_id,
        s.product_id,
        s.date,
        ROW_NUMBER() OVER (
            PARTITION BY s.store_id, s.product_id 
            ORDER BY TO_DATE(s.date) DESC
        ) AS sale_rank
    FROM
        ant_icube_dev.mexico_toy_sales s
    INNER JOIN
        ant_icube_dev.mexico_toy_stores st 
        ON s.store_id = st.store_id
    INNER JOIN
        ant_icube_dev.mexico_toy_products pr 
        ON s.product_id = pr.product_id
)
SELECT
    store_id AS `store_id`,
    product_id AS `product_id`,
    date AS `date`,
    sale_rank AS `sale_rank`
FROM
    sales_rank_cte;