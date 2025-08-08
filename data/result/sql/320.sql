WITH filtered_orders AS (

SELECT

customerid

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

WHERE

CAST(quantity AS BIGINT) = 4

AND CAST(totalamount AS DOUBLE) > 200

)

SELECT DISTINCT

c.customerid AS `customerid`,

c.firstname AS `firstname`,

c.lastname AS `lastname`,

c.phone AS `phone`,

c.signupdate AS `signupdate`

FROM

filtered_orders o

JOIN

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

ON

o.customerid = c.customerid;