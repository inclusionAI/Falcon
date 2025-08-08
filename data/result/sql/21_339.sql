with overall_avg as (

select avg(cast(totalamount as double)) as avg_total

from ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

),

status_stats as (

select

orderstatus,

avg(cast(totalamount as double)) as status_avg,

max(to_date(orderdate, 'yyyy-MM-dd')) as latest_date

from ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

group by orderstatus

)

select

orderstatus as `orderstatus`,

latest_date as `latest_orderdate`

from status_stats

where status_avg > (select avg_total from overall_avg);