WITH EPL_Games AS (
    SELECT 
        gameid,
        hometeamid,
        awayteamid,
        CAST(homegoals AS INT) - CAST(awaygoals AS INT) AS goal_diff
    FROM 
        ant_icube_dev.football_games
    WHERE 
        leagueid = '1'
),
HighMarginGames AS (
    SELECT 
        gameid,
        awayteamid
    FROM 
        EPL_Games
    WHERE 
        goal_diff > 1
),
ManUtdAwayGames AS (
    SELECT 
        COUNT(*) AS cnt
    FROM 
        HighMarginGames
    WHERE 
        awayteamid = '89'
)
SELECT 
    cnt AS `符合条件的比赛数`
FROM 
    ManUtdAwayGames;