WITH
-- 获取英超2015赛季比赛基础信息
premier_league_games AS (
  SELECT
    g.date,
    g.gameid,
    g.hometeamid,
    g.awayteamid,
    CAST(g.homegoals AS BIGINT) AS homegoals,
    CAST(g.awaygoals AS BIGINT) AS awaygoals
  FROM
    ant_icube_dev.football_games g
  WHERE
    g.leagueid = '1'
    AND g.season = '2015'
),

-- 关联主队信息
home_teams AS (
  SELECT
    t.teamid,
    t.name
  FROM
    ant_icube_dev.football_teams t
),

-- 关联客队信息
away_teams AS (
  SELECT
    t.teamid,
    t.name
  FROM
    ant_icube_dev.football_teams t
),

-- 构建完整比赛视图
complete_games AS (
  SELECT
    p.date,
    ht.teamid AS hometeamid,
    at.teamid AS awayteamid,
    ht.name AS home_team,
    at.name AS away_team,
    p.homegoals,
    p.awaygoals,
    (p.homegoals + p.awaygoals) AS total_goals
  FROM
    premier_league_games p
  JOIN
    home_teams ht ON p.hometeamid = ht.teamid
  JOIN
    away_teams at ON p.awayteamid = at.teamid
),

-- 计算球队平均进球
team_avg_goals AS (
  SELECT
    teamid,
    AVG(goals) AS avg_goals
  FROM (
    SELECT
      hometeamid AS teamid,
      homegoals AS goals
    FROM
      ant_icube_dev.football_games
    WHERE
      leagueid = '1'
      AND season = '2015'
    UNION ALL
    SELECT
      awayteamid AS teamid,
      awaygoals AS goals
    FROM
      ant_icube_dev.football_games
    WHERE
      leagueid = '1'
      AND season = '2015'
  ) combined
  GROUP BY
    teamid
),

ranked_games AS (
  SELECT
    c.date,
    c.home_team,
    c.away_team,
    c.total_goals,
    t1.avg_goals AS home_avg_goals,
    t2.avg_goals AS away_avg_goals,
    -- 关键修改：使用RANK()实现跳过名次
    RANK() OVER (ORDER BY c.total_goals DESC) AS goals_rank
  FROM
    complete_games c
  JOIN
    team_avg_goals t1 ON c.hometeamid = t1.teamid
  JOIN
    team_avg_goals t2 ON c.awayteamid = t2.teamid
)

SELECT
  date AS `date`,
  home_team AS `home_team`,
  away_team AS `away_team`,
  total_goals AS `total_goals`,
  home_avg_goals AS `home_avg_goals`,
  away_avg_goals AS `away_avg_goals`
FROM
  ranked_games
WHERE
  goals_rank <= 5  -- 前五名（含并列）
ORDER BY
  goals_rank,
  date;