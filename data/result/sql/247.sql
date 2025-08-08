WITH electronic_products AS (
    SELECT product_id
    FROM ant_icube_dev.ecommerce_order_products
    WHERE product_category_name = 'electronics'
),
seller_financials AS (
    SELECT 
        oi.seller_id,
        SUM(CAST(oi.price AS DOUBLE)) AS total_sales,
        SUM(CAST(oi.shipping_charges AS DOUBLE)) AS total_shipping
    FROM ant_icube_dev.ecommerce_order_order_items oi
    INNER JOIN electronic_products ep 
        ON oi.product_id = ep.product_id
    GROUP BY oi.seller_id
    HAVING total_shipping > 0
)
SELECT 
    seller_id as `卖家ID`,
    total_sales / total_shipping as `销售运费比`
FROM seller_financials
ORDER BY `销售运费比` DESC
LIMIT 1;