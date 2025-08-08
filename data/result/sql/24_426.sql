WITH cash_orders AS (


SELECT


o.order_id


FROM


ant_icube_dev.blinkit_orders o


WHERE


o.payment_method = 'Cash'


),





order_products AS (


SELECT


oi.product_id,


oi.quantity


FROM


ant_icube_dev.blinkit_order_items oi


INNER JOIN


cash_orders co


ON oi.order_id = co.order_id


),





product_brands AS (


SELECT


p.product_id,


p.brand


FROM


ant_icube_dev.blinkit_products p


INNER JOIN


order_products op


ON p.product_id = op.product_id


),





brand_sales AS (


SELECT


pb.brand,


SUM(op.quantity) AS total_quantity


FROM


product_brands pb


INNER JOIN


order_products op


ON pb.product_id = op.product_id


GROUP BY


pb.brand


)





SELECT


bs.brand AS `brand`,


(bs.total_quantity / (SELECT SUM(total_quantity) FROM brand_sales)) AS `sales_ratio`


FROM


brand_sales bs;