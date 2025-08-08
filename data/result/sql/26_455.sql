WITH la_liga AS (

SELECT leagueid

FROM ant_icube_dev.football_leagues
    where understatnotation = 'La_liga'

),

player_shots_stats AS (

SELECT

a.playerid,  -- 从 appearances 表提取球员ID

SUM(CASE WHEN s.shotresult = 'Goal' THEN 1 ELSE 0 END) AS goals,

SUM(CASE WHEN s.shotresult IN ('SavedShot', 'Goal') THEN 1 ELSE 0 END) AS shots_on_target

FROM ant_icube_dev.football_appereances a

JOIN la_liga l ON a.leagueid = l.leagueid

JOIN ant_icube_dev.football_shots s ON a.gameid = s.gameid AND a.playerid = s.shooterid

GROUP BY a.playerid  -- 确保按 appearances 表中的 playerid 分组

)

SELECT

p.name AS `球员姓名`,

(stats.goals * 1.0 / stats.shots_on_target) AS `射门转化率`

FROM player_shots_stats stats

JOIN ant_icube_dev.football_players p ON stats.playerid = p.playerid

WHERE stats.shots_on_target > 0

AND (stats.goals * 1.0 / stats.shots_on_target) > 0.5;