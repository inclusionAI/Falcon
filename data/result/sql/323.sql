with filtered_customers as (

select

customerid,

city

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

where

to_date(signupdate) >= '2019-01-01'

),

city_total_amount as (

select

fc.city,

sum(cast(o.totalamount as double)) as total

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

inner join

filtered_customers fc

on

o.customerid = fc.customerid

group by

fc.city

)

select

city as `城市`

from

city_total_amount

where

total > 500;