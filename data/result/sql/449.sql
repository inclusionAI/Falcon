WITH team_away_corners AS (

-- 步骤1: 从球队统计表中筛选2015赛季客场数据并计算各队总角球数

SELECT

teamid,

SUM(CAST(corners AS BIGINT)) AS total_corners

FROM

ant_icube_dev.football_teamstats

WHERE

season = '2015'

AND location = 'a'

GROUP BY

teamid

)

-- 步骤2: 关联球队表获取球队名称并添加排名

SELECT

t.name AS `球队名称`,

tac.total_corners AS `客场角球数`

FROM

team_away_corners tac

JOIN

ant_icube_dev.football_teams t

ON

tac.teamid = t.teamid

ORDER BY

`排名` ASC;  -- 按排名升序排列