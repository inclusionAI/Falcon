WITH premier_2015_games AS (

SELECT

g.gameid,

g.hometeamid,

g.awayteamid

FROM

ant_icube_dev.football_games g

INNER JOIN

ant_icube_dev.football_leagues l ON g.leagueid = l.leagueid

WHERE

l.understatnotation = 'EPL'

AND g.season = '2015'

),



-- 步骤2: 计算每场比赛主客队的xG值

game_xg AS (

SELECT

pg.gameid,

CAST(ht.xgoals AS DOUBLE) AS home_xg,

CAST(at.xgoals AS DOUBLE) AS away_xg

FROM

premier_2015_games pg

INNER JOIN

ant_icube_dev.football_teamstats ht ON pg.gameid = ht.gameid AND pg.hometeamid = ht.teamid AND ht.location = 'h'

INNER JOIN

ant_icube_dev.football_teamstats at ON pg.gameid = at.gameid AND pg.awayteamid = at.teamid AND at.location = 'a'

),



-- 步骤3: 计算每场比赛的xG差值

game_xg_diff AS (

SELECT

gameid,

home_xg - away_xg AS xg_diff

FROM

game_xg

),



-- 步骤4: 计算赛季平均xG差值

avg_xg_diff AS (

SELECT

AVG(xg_diff) AS avg_diff

FROM

game_xg_diff

)



-- 步骤5: 筛选差值高于平均值的比赛

SELECT

g.gameid AS `gameid`,

g.xg_diff AS `预期进球差值`

FROM

game_xg_diff g

WHERE

g.xg_diff > (SELECT avg_diff FROM avg_xg_diff);