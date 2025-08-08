with filtered_invoices as (
    select
        countrycode,
        cast(dayslate as int) as dayslate_int,
        cast(invoiceamount as decimal) as invoice_amount
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    where
        cast(dayslate as int) > 30
        and invoiceamount is not null
),
late_level_calculation as (
    select
        countrycode,
        case
            when dayslate_int between 31 and 60 then '31-60'
            when dayslate_int between 61 and 90 then '61-90'
            when dayslate_int > 90 then '90+'
        end as `逾期等级`,
        sum(invoice_amount) as `总金额`
    from
        filtered_invoices
    group by
        countrycode,
        case
            when dayslate_int between 31 and 60 then '31-60'
            when dayslate_int between 61 and 90 then '61-90'
            when dayslate_int > 90 then '90+'
        end
)
select
    countrycode as `countrycode`,
    `逾期等级`,
    `总金额`
from
    late_level_calculation
where
    `总金额` > 10
order by
    countrycode;