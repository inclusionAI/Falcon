WITH base_data AS (

SELECT

country,

CAST(gdp_2023_billion_usd AS DOUBLE) AS gdp_2023

FROM

ant_icube_dev.ufc_country_data

WHERE

gdp_2023_billion_usd NOT IN ('', 'NA')

),

median_data AS (

SELECT

MEDIAN(gdp_2023) AS median_value  -- 使用 MEDIAN 函数

FROM

base_data

)

SELECT

country AS `country`,

RANK() OVER (ORDER BY gdp_2023 DESC) AS `gdp_rank`,

CASE

WHEN gdp_2023 >= (SELECT median_value FROM median_data) THEN 'Yes'

ELSE 'No'

END AS `above_median`

FROM

base_data

ORDER BY

`gdp_rank` ASC;