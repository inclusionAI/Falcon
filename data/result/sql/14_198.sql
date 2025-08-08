with product_clean as (
    select 
        product_id,
        product_category,
        cast(regexp_replace(product_price, '[^0-9.]', '') as double) as product_price_num
    from 
        ant_icube_dev.mexico_toy_products
),
category_stats as (
    select 
        product_category,
        avg(product_price_num) as avg_price
    from 
        product_clean
    group by 
        product_category
),
competitiveness_ranking as (
    select
        pc.product_id,
        pc.product_category,
        pc.product_price_num,
        row_number() over (
            partition by pc.product_category 
            order by pc.product_price_num asc
        ) as rank_result
    from 
        product_clean pc
    join 
        category_stats cs 
    on 
        pc.product_category = cs.product_category
)
select
    product_id as `product_id`,
    product_category as `product_category`,
    product_price_num as `product_price`,
    rank_result as `competitiveness_rank`
from 
    competitiveness_ranking
where 
    rank_result <= 5
order by 
    product_category, rank_result;