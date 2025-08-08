with team_stats as (
select
ts.teamid,
g.leagueid,
ts.season,
sum(cast(ts.shotsontarget as double)) as total_shotsontarget,
sum(cast(ts.shots as double)) as total_shots
from
ant_icube_dev.football_teamstats ts
join
ant_icube_dev.football_games g
on
ts.gameid = g.gameid
group by
ts.teamid, g.leagueid, ts.season
)
select
t.name as `球队名称`,
l.name as `联赛名称`,
ts.season as `赛季`
from
team_stats ts
join
ant_icube_dev.football_teams t
on
ts.teamid = t.teamid
join
ant_icube_dev.football_leagues l
on
ts.leagueid = l.leagueid
where
(ts.total_shotsontarget / nullif(ts.total_shots, 0)) * 100 > 40;