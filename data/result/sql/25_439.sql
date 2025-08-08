with split_product_subcategory as (
select
p.productkey,
p.productname,
trim(split_subcat) as productsubcategorykey,
cast(p.productprice as double) as productprice,
s.subcategoryname
from
ant_icube_dev.tech_sales_product_lookup p
lateral view explode(split(p.productsubcategorykey, ',')) subcat as split_subcat
join ant_icube_dev.tech_sales_product_subcategories s
on trim(split_subcat) = s.productsubcategorykey
),
max_price_per_subcategory as (
select
productsubcategorykey,
subcategoryname,
max(productprice) as max_price
from
split_product_subcategory
group by
productsubcategorykey, subcategoryname
),
products_with_max_price as (
select
s.productsubcategorykey,
s.subcategoryname,
s.productkey,
s.productname,
s.productprice
from
split_product_subcategory s
join max_price_per_subcategory m
on s.productsubcategorykey = m.productsubcategorykey
and s.productprice = m.max_price
),
sales_with_city as (
select
sd.productkey,
c.city,
count(distinct sd.ordernumber) as purchase_count
from
ant_icube_dev.tech_sales_sales_data sd
join ant_icube_dev.tech_sales_customer_lookup c
on sd.customerkey = c.customer_id
group by
sd.productkey, c.city
)
select
p.subcategoryname as `子类别名称`,
p.productname as `产品名称`,
s.city as `客户所在城市`,
s.purchase_count as `购买次数`
from
products_with_max_price p
join sales_with_city s
on p.productkey = s.productkey
order by
p.subcategoryname, p.productprice desc;