with gender_investment as (
    select
        gender,
        sum(cast(government_bonds as bigint)) as total_investment,
        count(*) as total_people
    from
        ant_icube_dev.di_finance_data
    where
        government_bonds rlike '^\\\\d+$'
    group by
        gender
),
ranked_gender as (
    select
        gender,
        total_investment,
        total_investment/total_people as avg_investment,
        row_number() over (order by total_investment desc) as rn
    from
        gender_investment
)
select
    gender as `性别`,
    total_investment as `政府债券投资总额`,
    avg_investment as `人均投资额`
from
    ranked_gender
where
    rn = 1;