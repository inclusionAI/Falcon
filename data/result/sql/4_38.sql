with late_invoices as (
    select
        countrycode,
        customerid,
        cast(trim(invoiceamount) as decimal(18,2)) as invoice_amount
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where
        cast(dayslate as int) > 0
)
select
    countrycode as `countrycode`,
    customerid as `customerid`,
    sum(invoice_amount) as `累计逾期发票金额`
from
    late_invoices
group by
    countrycode,
    customerid
order by
    countrycode