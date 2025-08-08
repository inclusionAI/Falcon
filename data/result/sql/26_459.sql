with
-- 获取2015赛季的比赛ID和对应主客队ID
season_games as (
select
gameid,
hometeamid,
awayteamid
from
ant_icube_dev.football_games
where
season = '2015'
),
-- 统计各球员在2015赛季的射门次数
player_shot_count as (
select
s.shooterid,
count(*) as shot_cnt
from
ant_icube_dev.football_shots s
join
season_games g
on
s.gameid = g.gameid
group by
s.shooterid
),
-- 获取球员所属球队的映射关系（通过关联出場表）
player_team_mapping as (
select distinct
a.playerid,
t.teamid
from
ant_icube_dev.football_appereances a
join
ant_icube_dev.football_teamstats ts
on
a.gameid = ts.gameid
join
ant_icube_dev.football_teams t
on
ts.teamid = t.teamid
),
-- 统计各球队2015赛季总射门次数（通过球队统计表）
team_shot_total as (
select
teamid,
sum(cast(shots as bigint)) as total_shots
from
ant_icube_dev.football_teamstats
where
season = '2015'
group by
teamid
)
-- 计算球员射门次数及占比
select
p.name as `球员姓名`,
psc.shot_cnt as `射门次数`,
(psc.shot_cnt * 100.0 / tst.total_shots) as `射门占比`
from
player_shot_count psc
join
player_team_mapping ptm
on
psc.shooterid = ptm.playerid
join
team_shot_total tst
on
ptm.teamid = tst.teamid
join
ant_icube_dev.football_players p
on
psc.shooterid = p.playerid;