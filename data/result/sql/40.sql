with ranked_invoices as (
    select
        *,
        row_number() over (order by dayslate desc) as `逾期排名`,
        dense_rank() over (order by invoiceamount desc) as `金额排名`
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories        
)
select
    customerid as `customerid`,
    invoicenumber as `invoicenumber`,
    dayslate as `dayslate`,
    invoiceamount as `invoiceamount`,
    `金额排名`,
    duedate as `duedate`,
    invoicedate as `invoicedate`,
    settleddate as `settleddate`,
    disputed as `disputed`,
    paperlessbill as `paperlessbill`,
    paperlessdate as `paperlessdate`
from
    ranked_invoices
where `逾期排名` <= 5
order by
    dayslate desc;