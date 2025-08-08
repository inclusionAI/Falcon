with national_unemployment_avg as (
    select avg(cast(unemployment as double)) as avg_unemployment
    from ant_icube_dev.walmart_features
),
eligible_store_features as (
    select distinct store
    from ant_icube_dev.walmart_features
    where cast(unemployment as double) < (select avg_unemployment from national_unemployment_avg)
),
store_type_mapping as (
    select s.store, s.type
    from ant_icube_dev.walmart_stores s
    inner join eligible_store_features e on s.store = e.store
),
store_temperature_data as (
    select 
        cast(f.temperature as double) as temperature,
        stm.type
    from ant_icube_dev.walmart_features f
    inner join store_type_mapping stm on f.store = stm.store
)
select
    type as `类型商店`,
    max(temperature) as `最高温度记录`
from store_temperature_data
group by type;