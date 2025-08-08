WITH league_info AS (
SELECT leagueid
FROM ant_icube_dev.football_leagues
WHERE name = 'Premier League'
),
filtered_games AS (
SELECT
g.gameid,
g.date,
g.hometeamid
FROM
ant_icube_dev.football_games g
INNER JOIN league_info l ON g.leagueid = l.leagueid
WHERE
g.season = '2015'
),
team_xgoals AS (
SELECT
t.gameid,
CAST(t.xgoals AS DOUBLE) AS xgoals
FROM
ant_icube_dev.football_teamstats t
INNER JOIN filtered_games f ON t.gameid = f.gameid AND t.teamid = f.hometeamid
)
SELECT
f.date AS `date`,
COALESCE(SUM(t.xgoals), 0) AS `主队预期进球总和`
FROM
filtered_games f
LEFT JOIN team_xgoals t ON f.gameid = t.gameid
GROUP BY
f.date,
f.gameid
ORDER BY
f.date;