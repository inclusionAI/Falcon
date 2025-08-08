with player_season_avg as (
select
a.playerid,
sum(cast(trim(a.goals) as double)) / nullif(sum(cast(trim(a.shots) as double)), 0) as avg_success_rate
from
ant_icube_dev.football_appereances a
join
ant_icube_dev.football_games g
on
a.gameid = g.gameid
where
g.season = '2015'
and cast(trim(a.shots) as int) > 0
group by
a.playerid
),
game_level_stats as (
select
a.gameid,
a.playerid,
cast(trim(a.keypasses) as int) as keypasses,
cast(trim(a.goals) as double) / cast(trim(a.shots) as double) as game_success_rate
from
ant_icube_dev.football_appereances a
join
ant_icube_dev.football_games g
on
a.gameid = g.gameid
where
g.season = '2015'
and cast(trim(a.shots) as int) > 0
)
select
g.gameid as `gameid`,
g.playerid as `playerid`,
g.keypasses as `关键传球次数`
from
game_level_stats g
join
player_season_avg psa
on
g.playerid = psa.playerid
where
g.game_success_rate > psa.avg_success_rate;