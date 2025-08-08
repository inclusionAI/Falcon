with
black_products as (
select productkey
from ant_icube_dev.tech_sales_product_lookup
where productcolor = 'black'
),
product_returns as (
select
r.productkey,
sum(cast(r.returnquantity as bigint)) as total_returns
from ant_icube_dev.tech_sales_product_returns r
inner join black_products p
on r.productkey = p.productkey
group by r.productkey
),
sales_education as (
select
s.productkey,
c.education
from ant_icube_dev.tech_sales_sales_data s
inner join ant_icube_dev.tech_sales_customer_lookup c
on s.customerkey = c.customer_id
inner join black_products p
on s.productkey = p.productkey
)
select
s.education as `教育水平`,
sum(p.total_returns) as `总退货数量`
from sales_education s
inner join product_returns p
on s.productkey = p.productkey
group by s.education;