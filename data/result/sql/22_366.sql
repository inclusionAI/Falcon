WITH

brazil_young_fighters AS (

SELECT

first_name,

last_name,

age,

arm_reach_inch,

leg_reach_inch,

CAST(arm_reach_inch AS DOUBLE) / NULLIF(CAST(leg_reach_inch AS DOUBLE), 0) AS reach_ratio, -- 添加NULLIF防除零错误

city,

debut,

draws,

fighting_style,

height_ft,

nickname,

weight_division,

weight_lbs,

wins,

losses,

win_percent,

lose_percent,

num_of_fights

FROM

ant_icube_dev.ufc_fighters_stats

WHERE

country = 'Brazil'

AND CAST(age AS INT) < 30

AND arm_reach_inch IS NOT NULL

AND leg_reach_inch IS NOT NULL

AND leg_reach_inch != '0' -- 冗余条件，NULLIF已覆盖

),

ranked_fighters AS (

SELECT

*,

RANK() OVER (ORDER BY reach_ratio DESC) AS rank 
FROM

brazil_young_fighters

)

SELECT

first_name,

last_name,

age,

arm_reach_inch,

leg_reach_inch,

city,

fighting_style,

height_ft,

weight_division,

weight_lbs,

num_of_fights

FROM

ranked_fighters

WHERE

rank = 1; -- 现在会返回所有并列第一的选手