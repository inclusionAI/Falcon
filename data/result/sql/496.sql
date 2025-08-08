select

c.customer_id as `客户id`,

sum(cast(oi.quantity as bigint)) as `购买数量`

from

ant_icube_dev.online_shop_suppliers s

join ant_icube_dev.online_shop_products p

on s.supplier_id = p.supplier_id

join ant_icube_dev.online_shop_order_items oi

on p.product_id = oi.product_id

join ant_icube_dev.online_shop_orders o

on oi.order_id = o.order_id

join ant_icube_dev.online_shop_customers c

on o.customer_id = c.customer_id

where

s.supplier_name = 'Alpha Industries Ltd.'

group by

c.customer_id;