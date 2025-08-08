with filtered_customers as (

select customerid

from ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

where city = 'Casablanca'

group by customerid

),

order_data as (

select

o.customerid,

cast(o.totalamount as double) as totalamount

from ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

inner join filtered_customers fc

on o.customerid = fc.customerid

)

select

c.firstname as `firstname`,

c.lastname as `lastname`

from (

select

customerid,

avg(totalamount) as avg_amount

from order_data

group by customerid

having avg(totalamount) > 150

) t

inner join ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c

on t.customerid = c.customerid

where c.city = 'Casablanca'

group by c.customerid, c.firstname, c.lastname;