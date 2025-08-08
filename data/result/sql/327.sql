WITH max_order_date AS (

SELECT MAX(to_date(orderdate, 'yyyy-MM-dd')) AS max_date

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

),

recent_customers AS (

SELECT DISTINCT o.customerid

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

WHERE to_date(o.orderdate, 'yyyy-MM-dd') >= (SELECT dateadd(max_date, CAST(-1 AS BIGINT), 'year') FROM max_order_date)

)



SELECT DISTINCT

c.customerid AS `customerid`,

c.address AS `address`,

c.city AS `city`,

c.email AS `email`,

c.phone AS `phone`,

c.firstname AS `firstname`,

c.lastname AS `lastname`,

c.zipcode AS `zipcode`

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

LEFT JOIN

recent_customers r ON c.customerid = r.customerid

WHERE

r.customerid IS NULL;