with customer_first_sales as (
select
customerid,
min(to_date(substr(salesdate, 1, 10))) as first_sales_date
from
ant_icube_dev.grocery_sales_sales
group by
customerid
),
city_earliest_registration as (
select
c.cityid,
min(cfs.first_sales_date) as earliest_reg_date
from
ant_icube_dev.grocery_sales_customers c
join customer_first_sales cfs
on c.customerid = cfs.customerid
group by
c.cityid
),
employee_associated_city as (
select distinct
s.salespersonid as employeeid,
c.cityid
from
ant_icube_dev.grocery_sales_sales s
join ant_icube_dev.grocery_sales_customers c
on s.customerid = c.customerid
)
select
e.birthdate as `birthdate`,
e.cityid as `cityid`,
e.employeeid as `employeeid`,
e.firstname as `firstname`,
e.gender as `gender`,
e.hiredate as `hiredate`,
e.lastname as `lastname`,
e.middleinitial as `middleinitial`
from
ant_icube_dev.grocery_sales_employees e
join employee_associated_city ec
on e.employeeid = ec.employeeid
join city_earliest_registration cer
on ec.cityid = cer.cityid
where
to_date(substr(e.hiredate, 1, 10)) < cer.earliest_reg_date;