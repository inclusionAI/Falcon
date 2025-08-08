with ups_shipments as (
    select
        order_id,
        shipment_date
    from
        ant_icube_dev.online_shop_shipments
    where
        carrier = 'UPS'
),
order_details as (
    select
        o.order_id,
        o.order_date,
        cast(o.total_price as decimal) as total_price,
        s.shipment_date
    from
        ant_icube_dev.online_shop_orders o
        inner join ups_shipments s
        on o.order_id = s.order_id
)
select
    order_id as `order_id`,
    order_date as `order_date`,
    shipment_date as `shipment_date`,
    total_price as `total_price`
from
    order_details
where
    datediff(to_date(shipment_date, 'yyyy-mm-dd'), to_date(order_date, 'yyyy-mm-dd')) > 4
    and total_price > 2000;