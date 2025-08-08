WITH filtered_products AS (

SELECT

productid

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

WHERE

CAST(stockquantity AS BIGINT) = 0

)



SELECT DISTINCT

o.orderid AS `orderid`

FROM

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

INNER JOIN

filtered_products p ON o.productid = p.productid

WHERE

o.orderstatus = 'Delivered'

AND CAST(o.quantity AS INT) > 1;