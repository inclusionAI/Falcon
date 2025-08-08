WITH filtered_data AS (
    SELECT 
        sub_category,
        year_month,
        amount
    FROM 
        ant_icube_dev.di_sales_dataset
    WHERE 
        category = 'Electronics'
        ),
sales_by_year AS (
    SELECT 
        sub_category,
        CAST(SUBSTR(year_month, 1, 4) AS INT) AS year,
        SUM(CAST(amount AS DOUBLE)) AS total_sales
    FROM 
        filtered_data
    GROUP BY 
        sub_category,
        CAST(SUBSTR(year_month, 1, 4) AS INT)
        ),
sales_growth AS (
    SELECT 
        sub_category,
        year,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY sub_category ORDER BY year) AS prev_year_sales
    FROM 
        sales_by_year
        )
SELECT 
    sub_category AS `sub_category`,
    ((total_sales - prev_year_sales) / prev_year_sales * 100) AS `growth_rate`
    FROM 
    sales_growth
    WHERE 
    prev_year_sales IS NOT NULL
    AND ((total_sales - prev_year_sales) / prev_year_sales) > 0.1;