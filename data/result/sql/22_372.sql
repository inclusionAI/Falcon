WITH Canadian_events AS (
    SELECT
        e.*
    FROM
        ant_icube_dev.ufc_events_stats e
        INNER JOIN ant_icube_dev.ufc_country_data cd ON e.country = cd.country
    WHERE
        cd.country = 'Canada'
),
-- 合并 fighter_1 和 fighter_2 的所有选手
AllFightersInEvents AS (
    SELECT
        ce.city,
        TRIM(ce.fighter_1) AS fighter_name,
        CAST(f.win_percent AS DOUBLE) AS win_percent,
        CAST(f.height_ft AS DOUBLE) AS height_ft
    FROM
        Canadian_events ce
        INNER JOIN ant_icube_dev.ufc_fighters_stats f ON TRIM(ce.fighter_1) = TRIM(f.last_name)
    WHERE
        f.win_percent IS NOT NULL
    UNION
    ALL
    SELECT
        ce.city,
        TRIM(ce.fighter_2) AS fighter_name,
        CAST(f.win_percent AS DOUBLE) AS win_percent,
        CAST(f.height_ft AS DOUBLE) AS height_ft
    FROM
        Canadian_events ce
        INNER JOIN ant_icube_dev.ufc_fighters_stats f ON TRIM(ce.fighter_2) = TRIM(f.last_name)
    WHERE
        f.win_percent IS NOT NULL
),
-- 为所有选手创建唯一列表
DistinctFighters AS (
    SELECT
        DISTINCT fighter_name,
        win_percent,
        height_ft
    FROM
        AllFightersInEvents
),
-- 对所有选手统一排名
RankedFighters AS (
    SELECT
        fighter_name,
        win_percent,
        height_ft,
        RANK() OVER (
            ORDER BY
                win_percent DESC
        ) AS rn
    FROM
        DistinctFighters
),
-- 获取前5名选手（含并列）
Top5Fighters AS (
    SELECT
        fighter_name,
        height_ft
    FROM
        RankedFighters
    WHERE
        rn <= 5
) -- 计算各城市平均身高
SELECT
    afe.city AS `赛事城市`,
    AVG(t5f.height_ft) AS `平均身高`
FROM
    AllFightersInEvents afe
    INNER JOIN Top5Fighters t5f ON afe.fighter_name = t5f.fighter_name
GROUP BY
    afe.city;