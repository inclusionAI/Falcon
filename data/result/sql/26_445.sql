with player_contribution as (

select

a.playerid,

a.gameid,

cast(a.keypasses as int) as keypasses,

cast(a.shots as int) as shots

from

ant_icube_dev.football_appereances a

where

a.keypasses is not null

and a.shots is not null

and cast(a.keypasses as int) > 0

and cast(a.shots as int) > 0

)



-- 关联球员信息并统计场均数据

select

p.name as `球员名称`,

sum(pc.keypasses) as `总关键传球`,

sum(pc.shots) as `总射门`,

round(sum(pc.keypasses)/count(distinct pc.gameid),2) as `场均关键传球`,

round(sum(pc.shots)/count(distinct pc.gameid),2) as `场均射门`

from

player_contribution pc

join

ant_icube_dev.football_players p

on

pc.playerid = p.playerid

group by

p.name

having

count(distinct pc.gameid) > 0;