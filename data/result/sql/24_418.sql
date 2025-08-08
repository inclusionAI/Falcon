WITH partner_stats AS (

-- 计算配送员的总订单数和准时订单数

SELECT

delivery_partner_id,

COUNT(order_id) AS total_orders,

SUM(CASE WHEN delivery_status = 'On Time' THEN 1 ELSE 0 END) AS on_time_orders

FROM ant_icube_dev.blinkit_delivery_performance

GROUP BY delivery_partner_id

),

low_performance_filter AS (

-- 筛选准时率低于90%的配送员及其异常订单数

SELECT

delivery_partner_id,

(total_orders - on_time_orders) AS abnormal_orders

FROM partner_stats

WHERE (on_time_orders * 100.0) / total_orders < 90

)

-- 最终输出配送员ID和异常订单数

SELECT

delivery_partner_id AS `delivery_partner_id`,

abnormal_orders AS `abnormal_order_count`

FROM low_performance_filter;