with sales_data as (

select

salesdate,

customerid,

productid,

salespersonid,

transactionnumber,

discount,

quantity,

totalprice

from

ant_icube_dev.grocery_sales_sales

where

to_date(salesdate) = '2018-05-03'

)



select

s.transactionnumber as `transactionnumber`

from

sales_data s

join ant_icube_dev.grocery_sales_products p

on s.productid = p.productid

join ant_icube_dev.grocery_sales_categories cat

on p.categoryid = cat.categoryid

join ant_icube_dev.grocery_sales_employees e

on s.salespersonid = e.employeeid

join ant_icube_dev.grocery_sales_customers cus

on s.customerid = cus.customerid

join ant_icube_dev.grocery_sales_cities ci

on cus.cityid = ci.cityid

join ant_icube_dev.grocery_sales_countries co

on ci.countryid = co.countryid;