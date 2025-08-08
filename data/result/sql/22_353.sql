with filtered_countries as (

select

country

from

ant_icube_dev.ufc_country_data

where

cast(avg_temperature_celsius as double) > 20

),

country_events as (

select

trim(fighter_1) as fighter_1

from

ant_icube_dev.ufc_events_stats

inner join

filtered_countries

on

ant_icube_dev.ufc_events_stats.country = filtered_countries.country

)

select

avg(cast(f.arm_reach_inch as double)) as `avg_arm_reach_inch` 

from

ant_icube_dev.ufc_fighters_stats f

inner join

country_events ce

on

ce.fighter_1 = f.last_name

where

f.arm_reach_inch is not null;