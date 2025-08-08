with fighters_filtered as (

select

first_name,

last_name,

arm_reach_inch,

leg_reach_inch,

debut

from

ant_icube_dev.ufc_fighters_stats

where

country = 'United States'

and weight_division = 'Lightweight Division'

),



ranked_fighters as (

select

first_name,

last_name,

(cast(arm_reach_inch as double) - cast(leg_reach_inch as double)) as reach_diff,

substr(debut, 1, 4) as debut_year,

rank() over (order by (cast(arm_reach_inch as double) - cast(leg_reach_inch as double)) desc) as rank_num

from

fighters_filtered

)



select

first_name as `first_name`,

last_name as `last_name`,

debut_year as `首秀年份`

from

ranked_fighters

where

rank_num <= 3

order by

reach_diff desc;