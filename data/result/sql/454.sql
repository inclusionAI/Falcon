with spurs_team as (
select teamid
from ant_icube_dev.football_teams
where name = 'Tottenham'
)
select
count(distinct t.gameid) as `胜利场次`
from
ant_icube_dev.football_teamstats t
join ant_icube_dev.football_games g on t.gameid = g.gameid
join spurs_team s on g.hometeamid = s.teamid
where
t.teamid = s.teamid
and t.location = 'h'
and cast(t.corners as int) > 5
and t.result = 'W';