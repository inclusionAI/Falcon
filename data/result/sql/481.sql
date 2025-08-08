with cte_country_cities as (

select

c.cityid

from

ant_icube_dev.grocery_sales_cities c

join ant_icube_dev.grocery_sales_countries co

on c.countryid = co.countryid

where

co.countryname = 'United States'

),



cte_us_customers as (

select

cu.customerid

from

ant_icube_dev.grocery_sales_customers cu

join cte_country_cities cc

on cu.cityid = cc.cityid

),



cte_sales_detail as (

select

s.discount,

p.categoryid

from

ant_icube_dev.grocery_sales_sales s

join cte_us_customers uc

on s.customerid = uc.customerid

join ant_icube_dev.grocery_sales_products p

on s.productid = p.productid

),



cte_category_stats as (

select

c.categoryname as `产品类别`,

count(*) as `购买次数`,

avg(cast(s.discount as double)) as `平均折扣率`

from

cte_sales_detail s

join ant_icube_dev.grocery_sales_categories c

on s.categoryid = c.categoryid

group by

c.categoryname

)



select

`产品类别`,

`购买次数`,

`平均折扣率`

from

cte_category_stats

order by

`购买次数` desc

limit 1;