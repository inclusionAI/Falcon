with store_total_stock as (
    select
        store_id,
        sum(cast(stock_on_hand as int)) as total_stock
    from
        ant_icube_dev.mexico_toy_inventory
    group by
        store_id
)
select
    s.store_id as `store_id`,
    s.store_city as `store_city`
from
    ant_icube_dev.mexico_toy_stores s
inner join
    store_total_stock sts
on
    s.store_id = sts.store_id
where
    sts.total_stock > (
        select
            avg(total_stock)
        from
            store_total_stock
    );