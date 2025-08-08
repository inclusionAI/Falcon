with disputed_bills as (
    select
        customerid,
        daystosettle,
        invoiceamount
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where
        disputed = 'Yes'
)
select
    customerid as `客户id`
from
    disputed_bills
group by
    customerid
having
    avg(cast(daystosettle as bigint)) > 45
    and sum(cast(invoiceamount as double)) > 1000