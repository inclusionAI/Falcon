with customer_total as (

select

u.city,

substr(u.signupdate, 1, 4) as signup_year,

u.customerid,

sum(cast(o.totalamount as double)) as total_amount

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

join ant_icube_dev.di_data_cleaning_for_customer_database_e_customers u

on o.customerid = u.customerid

group by

u.customerid, u.city, substr(u.signupdate, 1, 4)

),

city_avg as (

select

city,

avg(total_amount) as avg_total_amount

from

customer_total

group by

city

)

select

ct.city as `城市`,

ct.signup_year as `注册年份`,

count(ct.customerid) as `客户数量`

from

customer_total ct

join city_avg ca on ct.city = ca.city

where

ct.total_amount > ca.avg_total_amount

group by

ct.city, ct.signup_year;