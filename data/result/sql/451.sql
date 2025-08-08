with season_avg_corners as (
select
season,
avg(cast(corners as double)) as avg_corners
from
ant_icube_dev.football_teamstats
where
location = 'h'
group by
season
)

select
distinct t.name as `球队名称`
from
ant_icube_dev.football_teamstats ts
join
ant_icube_dev.football_teams t on ts.teamid = t.teamid
join
season_avg_corners sac on ts.season = sac.season
where
ts.location = 'h'
and cast(ts.yellowcards as double) < 3
and cast(ts.corners as double) > sac.avg_corners;