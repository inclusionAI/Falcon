with gold_investment as (
    select
        purpose,
        avg(cast(gold as double)) as `平均持有克数`,
        sum(case when factor = 'Risk' then 1 else 0 end) as `风险等级`
    from
        ant_icube_dev.di_finance_data
    group by
        purpose
)
select
    purpose as `储蓄目的`,
    `平均持有克数`,
    `风险等级`
from
    gold_investment
order by
    `风险等级` desc,
    `平均持有克数` desc;