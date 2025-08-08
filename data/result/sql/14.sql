with region_stats as (
    select
        property_area,
        avg(coalesce(cast(applicantincome as double), 0) + coalesce(cast(coapplicantincome as double), 0)) as avg_total_income,
        avg(coalesce(cast(loanamount as double), 0)) as avg_loanamount
    from
        ant_icube_dev.di_finance_loan_approval_prediction_data
    group by
        property_area
),
applicant_data as (
    select
        a.property_area,
        cast(a.applicantincome as double) as applicantincome,
        cast(a.coapplicantincome as double) as coapplicantincome,
        cast(a.loanamount as double) as loanamount,
        r.avg_total_income,
        r.avg_loanamount
    from
        ant_icube_dev.di_finance_loan_approval_prediction_data a
    inner join
        region_stats r
    on
        a.property_area = r.property_area
),
filtered_applicants as (
    select
        property_area,
        loanamount,
        (applicantincome + coapplicantincome) as total_income
    from
        applicant_data
    where
        (applicantincome + coapplicantincome) > avg_total_income
),
loan_summary as (
    select
        property_area,
        sum(loanamount) as total_loan
    from
        filtered_applicants
    group by
        property_area
)
select
    l.property_area as `property_area`
from
    loan_summary l
inner join
    region_stats r
on
    l.property_area = r.property_area
where
    l.total_loan > r.avg_loanamount;