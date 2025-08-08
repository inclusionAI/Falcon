WITH premier_league AS (
    SELECT leagueid
    FROM ant_icube_dev.football_leagues
    WHERE name = 'Premier League'
),
-- 筛选2015赛季英超的比赛
games_2015 AS (
    SELECT 
        gameid,
        hometeamid,
        awayteamid
    FROM ant_icube_dev.football_games
    WHERE season = '2015'
      AND leagueid = (SELECT leagueid FROM premier_league)
),
-- 获取所有头球射门记录并关联球队
head_shots_with_team AS (
    SELECT AVG(CAST(xgoal AS DOUBLE)) AS xgoal,teamid FROM
    (SELECT 
        AVG(CAST(xgoal AS DOUBLE)) AS xgoal,
        g.hometeamid AS teamid
    FROM ant_icube_dev.football_shots s
    JOIN games_2015 g ON s.gameid = g.gameid
    WHERE s.shottype = 'Head'
    GROUP BY hometeamid
    UNION ALL
    SELECT 
        AVG(CAST(xgoal AS DOUBLE)) AS xgoal,
        g.awayteamid AS teamid
    FROM ant_icube_dev.football_shots s
    JOIN games_2015 g ON s.gameid = g.gameid
    WHERE s.shottype = 'Head'
    GROUP BY awayteamid)
    GROUP BY teamid
),
-- 计算头球射门统计
head_shot_stats AS (
    SELECT 
        teamid,
        AVG(CAST(xgoal AS DOUBLE)) AS avg_xg,
        COUNT(*) AS head_shot_count
    FROM head_shots_with_team
    WHERE teamid IS NOT NULL
    GROUP BY teamid
),
-- 计算总射门统计
total_shot_stats AS (
    SELECT sum(total_shot_count) AS total_shot_count,teamid FROM
    (SELECT 
        COUNT(*) AS total_shot_count,
        g.hometeamid AS teamid
    FROM ant_icube_dev.football_shots s
    JOIN games_2015 g ON s.gameid = g.gameid
    GROUP BY hometeamid
    UNION ALL
    SELECT 
        COUNT(*) AS total_shot_count,
        g.awayteamid AS teamid
    FROM ant_icube_dev.football_shots s
    JOIN games_2015 g ON s.gameid = g.gameid
    GROUP BY awayteamid)
    GROUP BY teamid
)
-- 合并统计结果并关联球队名称
SELECT 
    t.name AS `球队名称`,
    h.avg_xg AS `平均xG值`,
    h.head_shot_count / tst.total_shot_count AS `头球射门占比`
FROM head_shot_stats h
JOIN total_shot_stats tst ON h.teamid = tst.teamid
JOIN ant_icube_dev.football_teams t ON h.teamid = t.teamid;