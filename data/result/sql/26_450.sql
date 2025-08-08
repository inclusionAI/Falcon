with player_shots_goals as (
    select
        a.playerid,
        sum(cast(a.goals as double)) as total_goals,
        sum(cast(a.shots as double)) as total_shots
    from
        ant_icube_dev.football_appereances a
    join
        ant_icube_dev.football_games g
    on
        a.gameid = g.gameid
    where
        g.season = '2015'
        and a.position = 'AMC'
    group by
        a.playerid
    having
        total_shots > 0
        and (total_goals / total_shots) > 0.15
)
select
    p.name as `name`
from
    player_shots_goals psg
join
    ant_icube_dev.football_players p
on
    psg.playerid = p.playerid;