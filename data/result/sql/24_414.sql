with
delivery_performance as (
select
delivery_partner_id,
sum(case when delivery_status = 'On Time' then 1 else 0 end) as on_time_count,
count(*) as total_count
from
ant_icube_dev.blinkit_delivery_performance
group by
delivery_partner_id
)
select
delivery_partner_id as `配送人员ID`
from
delivery_performance
where
(on_time_count * 100.0 / total_count) < 95;