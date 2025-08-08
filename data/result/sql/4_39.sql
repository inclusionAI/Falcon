with customer_avg_dayslate as (
    -- 计算每个客户在每个国家的平均逾期天数
    select
        countrycode,
        customerid,
        avg(cast(dayslate as int)) as `平均逾期天数`
    from
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    group by
        countrycode,
        customerid
),
ranked_customers as (
    -- 为每个国家的客户按平均逾期天数降序排名
    select
        countrycode,
        customerid,
        `平均逾期天数`,
        row_number() over (
            partition by countrycode
            order by `平均逾期天数` desc
        ) as `排名`
    from
        customer_avg_dayslate
)
-- 获取每个国家排名前十的客户
select
    countrycode as `countrycode`,
    customerid as `customerid`,
    `平均逾期天数`,
    `排名`
from
    ranked_customers
where
    `排名` <= 10;