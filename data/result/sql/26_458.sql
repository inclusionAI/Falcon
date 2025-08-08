with league as (
select leagueid
from ant_icube_dev.football_leagues
where understatnotation = 'EPL' or name = 'Premier League'
),
games as (
select
gameid,
hometeamid,
awayteamid
from ant_icube_dev.football_games
where season = '2015'
and leagueid in (select leagueid from league)
),
team_stats as (
select
ts.teamid,
ts.gameid,
cast(ts.xgoals as double) as xgoals
from ant_icube_dev.football_teamstats ts
join games g
on ts.gameid = g.gameid
and ts.teamid = g.awayteamid
where ts.location = 'a'
and ts.season = '2015'
),
ranked_stats as (
select
teamid,
gameid,
xgoals,
row_number() over (
partition by teamid
order by xgoals desc
) as rn
from team_stats
),
max_stats as (
select
teamid,
gameid,
xgoals
from ranked_stats
where rn = 1
),
team_names as (
select
teamid,
name
from ant_icube_dev.football_teams
)
select
tn.name as `球队名称`,
g.gameid,
ms.xgoals as `最高预期进球值`,
ht.name as `对手球队名称`
from max_stats ms
join games g
on ms.gameid = g.gameid
join team_names tn
on ms.teamid = tn.teamid
join team_names ht
on g.hometeamid = ht.teamid;