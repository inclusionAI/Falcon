WITH      residential_stores AS (
          SELECT    store_id
          FROM      ant_icube_dev.mexico_toy_stores
          ),
          sales_data AS (
          SELECT    s.product_id,
                    SUBSTR(s.date, 1, 7) AS sale_month,
                    SUM(
                    CAST(s.units AS INT) * CAST(
                    REPLACE   (TRIM(p.product_price), '$', '') AS DOUBLE
                    )
                    ) AS monthly_sales
          FROM      ant_icube_dev.mexico_toy_sales s
          JOIN      residential_stores rs ON s.store_id = rs.store_id
          JOIN      ant_icube_dev.mexico_toy_products p ON s.product_id = p.product_id
          GROUP BY  s.product_id,
                    SUBSTR(s.date, 1, 7)
          ),
          sales_growth AS (
          SELECT    product_id,
                    sale_month,
                    monthly_sales,
                    LAG(monthly_sales) OVER (
                    PARTITION BY product_id
                    ORDER BY  sale_month
                    ) AS prev_sales
          FROM      sales_data
          )
SELECT    DISTINCT product_id AS `product_id`,
          sale_month AS `sale_month`
FROM      (
          SELECT    product_id,
                    sale_month,
                    CASE
                              WHEN monthly_sales > prev_sales THEN 1
                              ELSE 0
                    END AS is_growing
          FROM      sales_growth
          ) t
WHERE     is_growing = 1