with filtered_data as (
    select
        countrycode,
        customerid
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where
        disputed = 'Yes'
        and cast(invoiceamount as decimal) > 50
)
select
    countrycode as `国家代码`,
    count(distinct customerid) as `客户数量`
from
    filtered_data
group by
    countrycode
order by
    countrycode;