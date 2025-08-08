WITH city_year_counts AS (

SELECT

city,

SUBSTR(signupdate, 1, 4) AS reg_year,

COUNT(*) AS reg_count

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

GROUP BY

city,

SUBSTR(signupdate, 1, 4)

),

ranked_city_year AS (

SELECT

city,

reg_year,

reg_count,

RANK() OVER (

PARTITION BY city 

ORDER BY reg_count DESC

) AS rnk 
FROM

city_year_counts

)

SELECT

city AS `城市`,

reg_year AS `注册年份`

FROM

ranked_city_year

WHERE

rnk = 1;  -- 获取所有并列第一的记录