WITH customer_orders AS (

SELECT

c.customerid,

YEAR(to_date(c.signupdate)) AS signup_year,

o.totalamount

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o ON c.customerid = o.customerid

),

total_spending AS (

SELECT

customerid,

signup_year,

SUM(CAST(totalamount AS DOUBLE)) AS total_amount

FROM

customer_orders

GROUP BY

customerid,

signup_year

),

ranked_spending AS (

SELECT

customerid,

signup_year,

total_amount,

RANK() OVER (PARTITION BY signup_year ORDER BY total_amount DESC) AS rank  -- 使用 RANK() 处理并列情况

FROM

total_spending

)

SELECT

c.firstname AS `firstname`,

c.lastname AS `lastname`,

rs.signup_year AS `signup_year`

FROM

ranked_spending rs

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c ON rs.customerid = c.customerid

WHERE

rs.rank <= 3  -- 选择每个注册年份的前 3 名

ORDER BY

rs.signup_year,

rs.rank;