with la_liga as (

select

leagueid

from

ant_icube_dev.football_leagues



),

season_games as (

select

gameid,

awayteamid,

hometeamid

from

ant_icube_dev.football_games

where

season = '2015'

and leagueid in (

select

leagueid

from

la_liga

)

),

away_stats as (

select

gameid,

teamid,

cast(ppda as double) as ppda

from

ant_icube_dev.football_teamstats

where

location = 'a'

and season = '2015'

and gameid in (

select

gameid

from

season_games

)

),

team_avg_ppda as (

select

teamid,

avg(ppda) as avg_ppda

from

away_stats

group by

teamid

),

qualified_games as (

select

a.gameid,

a.teamid as awayteamid,

a.ppda

from

away_stats a

join team_avg_ppda t on a.teamid = t.teamid

where

a.ppda > t.avg_ppda

)

select

t.name as `球队名称`,

 q.gameid as `场次`,

ht.name as `对手名称`

from

qualified_games q

join season_games s on q.gameid = s.gameid

join ant_icube_dev.football_teams t on q.awayteamid = t.teamid

join ant_icube_dev.football_teams ht on s.hometeamid = ht.teamid

group by

t.name,

 q.gameid,

ht.name;