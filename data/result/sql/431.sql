with latest_return as (
select
productkey,
returndate,
row_number() over (partition by productkey order by returndate desc) as rn
from
ant_icube_dev.tech_sales_product_returns
)
select
pr.productkey as `productkey`,
pr.returndate as `returndate`,
pl.productcolor as `productcolor`
from
latest_return pr
inner join
ant_icube_dev.tech_sales_product_lookup pl
on
pr.productkey = pl.productkey
where
pr.rn = 1;