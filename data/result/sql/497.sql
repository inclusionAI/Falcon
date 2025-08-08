with products as (
    select 
        product_id,
        supplier_id
    from 
        ant_icube_dev.online_shop_products
    where 
        category = 'Electronics'
),
valid_shipments as (
    select 
        s.order_id,
        to_date(shipment_date, 'yyyy-MM-dd') as ship_date,
        to_date(delivery_date, 'yyyy-MM-dd') as deliver_date
    from 
        ant_icube_dev.online_shop_shipments s
    where 
        shipment_date >= '2024-01-01' and shipment_date < '2024-04-01'
),
order_relations as (
    select 
        oi.order_id,
        p.supplier_id
    from 
        ant_icube_dev.online_shop_order_items oi
    join 
        products p
    on 
        oi.product_id = p.product_id
    group by 
        oi.order_id, p.supplier_id
)
select
    sp.supplier_id as `supplier_id`,
    count(distinct vs.order_id) as `订单数量`,
    avg(datediff(vs.deliver_date, vs.ship_date)) as `平均运输时长`
from 
    valid_shipments vs
join 
    order_relations ors
on 
    vs.order_id = ors.order_id
join 
    ant_icube_dev.online_shop_suppliers sp
on 
    ors.supplier_id = sp.supplier_id
group by 
    sp.supplier_id;