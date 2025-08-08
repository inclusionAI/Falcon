with shipment_data as (
    select
        s.carrier,
        s.shipment_status,
        datediff(
            to_date(s.delivery_date, 'yyyy-mm-dd'),
            to_date(s.shipment_date, 'yyyy-mm-dd')
        ) as shipping_duration
    from
        ant_icube_dev.online_shop_shipments s
    inner join
        ant_icube_dev.online_shop_orders o
        on s.order_id = o.order_id
)

select
    carrier as `承运商`,
    rank() over (order by avg(shipping_duration) asc) as `时效排名`,
    count(case when shipment_status = 'Delivered' then 1 end) as `已交付订单数`,
    count(case when shipment_status = 'Shipped' then 1 end) as `运输中订单数`,
    count(case when shipment_status = 'Pending' then 1 end) as `待处理订单数`
from
    shipment_data
group by
    carrier;