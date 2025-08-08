WITH league AS (

SELECT leagueid

FROM ant_icube_dev.football_leagues

WHERE name = 'Premier League'

),

premier_2015_games AS (

SELECT

gameid,

hometeamid,

CAST(homegoals AS DOUBLE) AS homegoals,

CAST(awaygoals AS DOUBLE) AS awaygoals

FROM ant_icube_dev.football_games

WHERE leagueid = (SELECT leagueid FROM league)

AND season = '2015'

),

home_wins AS (

SELECT

hometeamid,

gameid,

homegoals

FROM premier_2015_games

WHERE homegoals > awaygoals

),

league_avg_goals AS (

SELECT

SUM(homegoals + awaygoals) / COUNT(DISTINCT gameid) AS avg_goals

FROM premier_2015_games

),

team_goals_stats AS (

SELECT

hw.hometeamid,

SUM(hw.homegoals) / COUNT(DISTINCT hw.gameid) AS team_avg_goals

FROM home_wins hw

GROUP BY hw.hometeamid

HAVING SUM(hw.homegoals) / COUNT(DISTINCT hw.gameid) > (SELECT avg_goals FROM league_avg_goals)

),

qualified_teams AS (

SELECT distinct

tgs.hometeamid,

ft.name AS `球队名称`,

tgs.team_avg_goals AS `场均进球`

FROM team_goals_stats tgs

JOIN ant_icube_dev.football_teams ft

ON tgs.hometeamid = ft.teamid

),

player_assist_stats AS (

SELECT

q.hometeamid,

ap.playerid,

SUM(CAST(ap.assists AS DOUBLE)) / NULLIF(SUM(CAST(ap.time AS DOUBLE)), 0) AS `助攻效率`

FROM ant_icube_dev.football_appereances ap

JOIN home_wins hw

ON ap.gameid = hw.gameid

JOIN qualified_teams q

ON hw.hometeamid = q.hometeamid

GROUP BY q.hometeamid, ap.playerid

)

SELECT distinct

qt.`球队名称`,

qt.`场均进球`,

fp.name AS `球员名称`,

pas.`助攻效率`

FROM player_assist_stats pas

JOIN ant_icube_dev.football_players fp

ON pas.playerid = fp.playerid

JOIN qualified_teams qt

ON pas.hometeamid = qt.hometeamid

WHERE pas.`助攻效率` IS NOT NULL and pas.`助攻效率`>0

ORDER BY qt.`场均进球` DESC, pas.`助攻效率` DESC;