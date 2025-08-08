with 英超联赛 as (
    select leagueid
    from ant_icube_dev.football_leagues
    where understatnotation = 'EPL'
),
主队胜负统计 as (
    select 
        hometeamid,
        count(*) as total_games,
        sum(case when cast(homegoals as bigint) > cast(awaygoals as bigint) then 1 else 0 end) as wins
    from ant_icube_dev.football_games
    where leagueid = (select leagueid from 英超联赛)
    group by hometeamid
    having (wins / total_games) > 0.5
),
主队比赛列表 as (
    select gameid
    from ant_icube_dev.football_games
    where hometeamid in (select hometeamid from 主队胜负统计)
),
助攻分布 as (
    select 
        position,
        sum(cast(assists as bigint)) as total_assists
    from ant_icube_dev.football_appereances
    where gameid in (select gameid from 主队比赛列表)
      and leagueid = (select leagueid from 英超联赛)
    group by position
)
select
    position as `位置`,
    total_assists as `助攻次数`
from 助攻分布;