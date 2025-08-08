with black_friday_sales as (
select
s.productkey,
cast(trim(s.orderquantity) as decimal) as orderquantity,
c.education
from
ant_icube_dev.tech_sales_sales_data s
join ant_icube_dev.tech_sales_customer_lookup c
on s.customerkey = c.customer_id
where
month(to_date(s.orderdate, 'MM/dd/yyyy')) = 11
),
product_returns as (
select
productkey,
cast(trim(returnquantity) as decimal) as returnquantity
from
ant_icube_dev.tech_sales_product_returns
where
month(to_date(returndate, 'yyyy-MM-dd')) = 11
),
education_stats as (
select
bfs.education,
sum(bfs.orderquantity) as total_purchased,
sum(coalesce(pr.returnquantity, 0)) as total_returned
from
black_friday_sales bfs
left join product_returns pr
on bfs.productkey = pr.productkey
group by
bfs.education
)
select
education as `教育背景`
from
education_stats
where
total_purchased > 0
and (total_returned * 100.0) / total_purchased > 10;