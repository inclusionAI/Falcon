with credit_payment as (

select

p.order_id,

o.customer_id,

o.order_date

from

ant_icube_dev.online_shop_payment p

inner join

ant_icube_dev.online_shop_orders o

on p.order_id = o.order_id

where

p.payment_method = 'Credit Card'

and p.transaction_status = 'Completed'

),

delivered_orders as (

select

s.order_id,

s.shipment_status

from

ant_icube_dev.online_shop_shipments s

where

s.shipment_status = 'Delivered'

),

ranked_payments as (

select

cp.customer_id,

cp.order_id,

cp.order_date,

row_number() over (

partition by cp.customer_id

order by to_date(cp.order_date, 'yyyy-mm-dd') desc

) as rn

from

credit_payment cp

inner join

delivered_orders do

on cp.order_id = do.order_id

)

select

customer_id as `customer_id`,

order_id as `order_id`

from

ranked_payments

where

rn = 1;