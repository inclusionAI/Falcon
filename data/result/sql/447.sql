WITH home_games AS (
SELECT
gameid,
hometeamid
FROM
ant_icube_dev.football_games
WHERE
season = '2015'
),

-- 步骤2: 关联球队统计表获取主队预期进球数据
home_team_xg AS (
SELECT
ts.gameid,
ts.teamid,
ts.xgoals
FROM
ant_icube_dev.football_teamstats ts
WHERE
ts.season = '2015'
AND ts.location = 'h'
),

-- 步骤3: 关联物理表并计算排名
combined_data AS (
SELECT
hg.gameid,
hg.hometeamid,
CAST(htx.xgoals AS DOUBLE) AS xgoals
FROM
home_games hg
JOIN
home_team_xg htx
ON hg.gameid = htx.gameid
AND hg.hometeamid = htx.teamid
),

-- 步骤4: 计算每场比赛的预期进球排名
ranked_results AS (
SELECT
gameid,
hometeamid,
xgoals,
RANK() OVER (ORDER BY xgoals DESC) AS rank
FROM
combined_data
)

-- 最终输出: 关联球队名称
SELECT
rr.gameid,
t.name AS `球队名称`,
rr.rank AS `排名`
FROM
ranked_results rr
JOIN
ant_icube_dev.football_teams t
ON rr.hometeamid = t.teamid
ORDER BY
rr.gameid;