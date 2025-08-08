with substitute_players as (

select distinct

p.playerid,

p.name

from

ant_icube_dev.football_appereances a

join ant_icube_dev.football_players p

on a.playerid = p.playerid

where

(a.substitutein is not null and a.substitutein <> '')

and (

cast(a.goals as int) >= 5

or cast(a.assists as int) >= 5

)

)

select

name as `name`,

playerid as `playerid`

from

substitute_players;