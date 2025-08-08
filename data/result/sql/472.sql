WITH filtered_sales AS (

SELECT

salespersonid

FROM

ant_icube_dev.grocery_sales_sales

WHERE

CAST(discount AS DOUBLE) > 0.1

),

employee_birth_check AS (

SELECT

employeeid,

birthdate,

hiredate,

firstname,

lastname

FROM

ant_icube_dev.grocery_sales_employees

WHERE

TO_CHAR(

TO_DATE(SUBSTR(birthdate, 1, 10), 'yyyy-mm-dd'),

'MMdd'

) < TO_CHAR(

TO_DATE(SUBSTR(hiredate, 1, 10), 'yyyy-mm-dd'),

'MMdd'

)

)

SELECT DISTINCT

e.employeeid AS `employeeid`,

e.firstname AS `firstname`,

e.lastname AS `lastname`

FROM

filtered_sales fs

INNER JOIN

employee_birth_check e

ON

fs.salespersonid = e.employeeid;