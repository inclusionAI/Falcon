with sales_data as (
    select 
        s.store_id,
        p.product_category,
        cast(regexp_replace(p.product_price, '[^0-9.]', '') as decimal(10,2)) as price,
        cast(s.units as int) as units
    from 
        ant_icube_dev.mexico_toy_sales s
        join ant_icube_dev.mexico_toy_products p on s.product_id = p.product_id
),
sales_summary as (
    select 
        store_id,
        product_category,
        sum(units * price) as total_sales
    from 
        sales_data
    group by 
        store_id, 
        product_category
),
inventory_data as (
    select 
        i.store_id,
        p.product_category,
        cast(i.stock_on_hand as int) as stock_on_hand
    from 
        ant_icube_dev.mexico_toy_inventory i
        join ant_icube_dev.mexico_toy_products p on i.product_id = p.product_id
),
inventory_summary as (
    select 
        store_id,
        product_category,
        sum(stock_on_hand) as total_stock
    from 
        inventory_data
    group by 
        store_id, 
        product_category
),
combined_sales_store as (
    select 
        ss.store_id,
        ss.product_category,
        ss.total_sales,
        st.store_name
    from 
        sales_summary ss
        join ant_icube_dev.mexico_toy_stores st on ss.store_id = st.store_id
),
combined_data as (
    select 
        css.product_category,
        css.store_name,
        css.total_sales,
        coalesce(its.total_stock, 0) as total_stock
    from 
        combined_sales_store css
        left join inventory_summary its 
            on css.store_id = its.store_id 
            and css.product_category = its.product_category
),
ranked_data as (
    select 
        product_category,
        store_name,
        total_sales,
        total_stock,
        row_number() over (partition by product_category order by total_sales desc) as rank
    from 
        combined_data
)
select 
    product_category as `产品类别`,
    store_name as `店铺名称`,
    total_sales as `总销售额`,
    total_stock as `总库存量`
from 
    ranked_data
where 
    rank <= 3;