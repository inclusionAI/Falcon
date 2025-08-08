with status_products as (
select distinct
orderstatus,
productid
from ant_icube_dev.di_data_cleaning_for_customer_database_e_orders
)

select
s.orderstatus as `orderstatus`,
sum(cast(p.stockquantity as bigint)) as `total_stock`
from status_products s
join ant_icube_dev.di_data_cleaning_for_customer_database_e_products p
on s.productid = p.productid
group by s.orderstatus;