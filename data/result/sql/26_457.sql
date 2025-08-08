with filtered_teamstats as (
select
gameid,
teamid,
shotsontarget
from
ant_icube_dev.football_teamstats
where
season = '2015'
and location = 'h'
and cast(corners as int) > 5
and cast(yellowcards as double) < 3
)

select
t.name as `name`,
count(distinct g.gameid) as `场次`,
avg(cast(fts.shotsontarget as int)) as `平均射正次数`
from
ant_icube_dev.football_games g
join filtered_teamstats fts
on g.gameid = fts.gameid
and g.hometeamid = fts.teamid
join ant_icube_dev.football_teams t
on fts.teamid = t.teamid
group by
t.name;