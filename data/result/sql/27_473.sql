with mesa_customers as (
select
c.customerid
from
ant_icube_dev.grocery_sales_customers c
join
ant_icube_dev.grocery_sales_cities ct
on
c.cityid = ct.cityid
where
ct.cityname = 'Mesa'
),

allergic_transactions as (
select
s.transactionnumber,
sum(cast(s.quantity as int)) as total_quantity
from
ant_icube_dev.grocery_sales_sales s
join
mesa_customers mc
on
s.customerid = mc.customerid
join
ant_icube_dev.grocery_sales_products p
on
s.productid = p.productid
where
p.isallergic = 'True'
group by
s.transactionnumber
having
sum(cast(s.quantity as int)) > 5
)

select
transactionnumber as `transactionnumber`,
total_quantity as `total_quantity`
from
allergic_transactions;