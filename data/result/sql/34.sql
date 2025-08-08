with filtered_data as (
    select
        *,
        cast(invoiceamount as double) as invoice_amount
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where
        disputed = 'Yes'
)
select
    countrycode as `countrycode`,
    customerid as `customerid`,
    dayslate as `dayslate`,
    daystosettle as `daystosettle`,
    disputed as `disputed`,
    duedate as `duedate`,
    invoiceamount as `invoiceamount`,
    invoicedate as `invoicedate`,
    invoicenumber as `invoicenumber`,
    paperlessbill as `paperlessbill`,
    paperlessdate as `paperlessdate`,
    settleddate as `settleddate`
from
    filtered_data
order by
    invoice_amount desc
limit 10;