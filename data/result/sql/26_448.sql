WITH premier_league AS (
SELECT leagueid
FROM ant_icube_dev.football_leagues
WHERE name = 'Premier League'
),
filtered_appearances AS (
SELECT
a.playerid,
a.assists
FROM
ant_icube_dev.football_appereances a  -- 确保表名正确
INNER JOIN premier_league l ON a.leagueid = l.leagueid
INNER JOIN ant_icube_dev.football_games g ON a.gameid = g.gameid  
WHERE
g.season = '2015'  -- 使用从 football_games 表中提取的 season 字段
),
aggregated_assists AS (
SELECT
playerid,
SUM(CAST(assists AS BIGINT)) AS total_assists
FROM
filtered_appearances
GROUP BY
playerid
)
SELECT
p.name AS `球员姓名`,
aa.total_assists AS `累计助攻数`
FROM
aggregated_assists aa
INNER JOIN
ant_icube_dev.football_players p ON aa.playerid = p.playerid;