WITH city_category_sales AS (
    SELECT 
        st.store_city,
        p.product_category,
        SUM(CAST(s.units AS INT) * CAST(TRIM(REPLACE(p.product_price, '$', '')) AS DECIMAL)) AS category_total
    FROM 
        ant_icube_dev.mexico_toy_sales s
        JOIN ant_icube_dev.mexico_toy_stores st ON s.store_id = st.store_id
        JOIN ant_icube_dev.mexico_toy_products p ON s.product_id = p.product_id
    GROUP BY 
        st.store_city,
        p.product_category
),
city_summary AS (
    SELECT 
        store_city,
        SUM(category_total) AS total_sales,
        AVG(category_total) AS avg_category_sales
    FROM 
        city_category_sales
    GROUP BY 
        store_city
)
SELECT 
    store_city AS `store_city`,
    total_sales AS `total_sales`
FROM 
    city_summary
WHERE 
    total_sales > 10
    AND avg_category_sales < 2000;