with epl_league as (
select leagueid
from ant_icube_dev.football_leagues
where understatnotation = 'EPL'
),
games_2015_epl as (
select gameid
from ant_icube_dev.football_games
where season = '2015'
and leagueid in (select leagueid from epl_league)
),
player_stats as (
select
a.gameid,
a.playerid,
sum(cast(a.assists as int)) as total_assists,
sum(cast(a.shots as int)) as total_shots
from
ant_icube_dev.football_appereances a
where
a.gameid in (select gameid from games_2015_epl)
group by
a.gameid, a.playerid
having
sum(cast(a.assists as int)) > 1
),
ranked_players as (
select
gameid,
playerid,
total_shots,
row_number() over (partition by gameid order by total_shots desc) as rank
from
player_stats
),
final_players as (
select
r.gameid,
r.playerid,
p.name as `player_name`
from
ranked_players r
join ant_icube_dev.football_players p on r.playerid = p.playerid
where
r.rank = 1
),
team_mapping as (
select
g.gameid,
t.teamid,
t.name as `team_name`
from
ant_icube_dev.football_games g
join ant_icube_dev.football_teams t on g.hometeamid = t.teamid
union all
select
g.gameid,
t.teamid,
t.name as `team_name`
from
ant_icube_dev.football_games g
join ant_icube_dev.football_teams t on g.awayteamid = t.teamid
),
player_teams as (
select distinct
a.gameid,
a.playerid,
tm.team_name
from
ant_icube_dev.football_appereances a
join team_mapping tm on a.gameid = tm.gameid
)
select distinct
fp.gameid,
fp.player_name
from
final_players fp
join player_teams pt on fp.gameid = pt.gameid and fp.playerid = pt.playerid;