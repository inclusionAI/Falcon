WITH
-- 获取已成功配送的订单及其配送日期和发货日期
successful_shipments AS (
SELECT
s.carrier,
TO_DATE(s.delivery_date) AS delivery_date,
TO_DATE(s.shipment_date) AS shipment_date
FROM
ant_icube_dev.online_shop_shipments s
INNER JOIN
ant_icube_dev.online_shop_orders o
ON
s.order_id = o.order_id
WHERE
s.shipment_status = 'Delivered'
),
-- 计算各承运商平均配送时长
carrier_delivery AS (
SELECT
carrier,
AVG(DATEDIFF(delivery_date, shipment_date)) AS avg_days
FROM
successful_shipments
GROUP BY
carrier
)
-- 最终结果包含排名计算
SELECT
carrier AS `承运商`,
avg_days AS `平均配送时长`
FROM
carrier_delivery;