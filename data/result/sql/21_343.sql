WITH filtered_orders AS (

SELECT

o.customerid,

o.orderid,

o.orderdate,

o.orderstatus,

o.productid,

o.quantity,

o.totalamount

FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

WHERE o.orderstatus = 'Shipped'  -- 仅筛选已发货的订单

)

SELECT

customerid AS `customerid`,

orderid AS `orderid`,

orderdate AS `orderdate`,

productid AS `productid`,

quantity AS `quantity`,

totalamount AS `totalamount`,

CASE

WHEN CAST(totalamount AS DECIMAL(18,2)) > 400 THEN '是大额订单'  -- 标注是否为大额订单

ELSE '否'

END AS `是否为大额订单`

FROM filtered_orders;