with season_2015_apps as (
    select 
        a.playerid,
        a.leagueid,
        a.goals,
        a.shots,
        a.keypasses
    from
        ant_icube_dev.football_appereances a
        join ant_icube_dev.football_games g on a.gameid = g.gameid
    where
        g.season = '2015'
),
player_stats as (
    select 
        playerid,
        leagueid,
        sum(cast(goals as double)) as total_goals,
        sum(cast(shots as double)) as total_shots,
        sum(cast(keypasses as double)) as total_keypasses
    from
        season_2015_apps
    group by
        playerid,
        leagueid
),
filtered_players as (
    select
        playerid,
        leagueid,
        total_keypasses,
        total_goals / total_shots as conversion_rate
    from
        player_stats
    where
        total_shots > 0
        and (total_goals / total_shots) > 0.15
),
ranked_players as (
    select
        playerid,
        leagueid,
        total_keypasses,
        conversion_rate,
        rank() over (partition by leagueid order by total_keypasses desc) as league_rank
    from
        filtered_players
),
top_ranked as (
    select
        playerid,
        leagueid
    from
        ranked_players
    where
        league_rank <= 10
)
select
    p.name as `name`,
    p.playerid as `playerid`
from
    ant_icube_dev.football_players p
    join top_ranked t on p.playerid = t.playerid;