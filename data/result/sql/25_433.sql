with subcategory_avg_cost as (
select
l.productsubcategorykey,
avg(cast(l.productcost as double)) as avg_cost
from
ant_icube_dev.tech_sales_product_lookup l
join
ant_icube_dev.tech_sales_product_subcategories s
on
l.productsubcategorykey = s.productsubcategorykey
group by
l.productsubcategorykey
),
category_max_price as (
select
s.productcategorykey,
max(cast(l.productprice as double)) as max_price
from
ant_icube_dev.tech_sales_product_lookup l
join
ant_icube_dev.tech_sales_product_subcategories s
on
l.productsubcategorykey = s.productsubcategorykey
group by
s.productcategorykey
)
select
s.subcategoryname as `产品子类别`,
sc.avg_cost - cm.max_price as `价格差异`
from
subcategory_avg_cost sc
join
ant_icube_dev.tech_sales_product_subcategories s
on
sc.productsubcategorykey = s.productsubcategorykey
join
category_max_price cm
on
s.productcategorykey = cm.productcategorykey;