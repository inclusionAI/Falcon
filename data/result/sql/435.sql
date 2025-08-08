with category as (
select productcategorykey
from ant_icube_dev.tech_sales_product_categories
where categoryname = 'Computers & Laptops'
),
subcategory as (
select productsubcategorykey
from ant_icube_dev.tech_sales_product_subcategories
where subcategoryname = 'Laptops'
and productcategorykey = (select productcategorykey from category)
),
product as (
select productkey
from ant_icube_dev.tech_sales_product_lookup
where productsubcategorykey in (select productsubcategorykey from subcategory)
),
sales as (
select
s.customerkey,
cast(trim(s.orderquantity) as int) * cast(p.productprice as double) as amount
from ant_icube_dev.tech_sales_sales_data s
inner join ant_icube_dev.tech_sales_product_lookup p
on s.productkey = p.productkey
where s.productkey in (select productkey from product)
),
city_sales as (
select
c.city,
sum(s.amount) as total_sales
from sales s
inner join ant_icube_dev.tech_sales_customer_lookup c
on s.customerkey = c.customer_id
group by c.city
)
select
city as `city`,
total_sales as `total_sales`
from city_sales
where total_sales > 1000;