with brand_avg_margin as (
select
brand,
avg(cast(margin_percentage as double)) as avg_margin
from
ant_icube_dev.blinkit_products
group by
brand
)
select
p.product_id as `product_id`
from
ant_icube_dev.blinkit_products p
inner join
brand_avg_margin bam
on
p.brand = bam.brand
where
cast(p.margin_percentage as double) > bam.avg_margin;