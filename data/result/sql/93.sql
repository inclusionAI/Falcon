WITH filtered_apps AS (
    SELECT
        type,
        CAST(rating AS DOUBLE) AS numeric_rating
    FROM
        ant_icube_dev.di_google_play_store_apps
    WHERE
        category = 'GAME'
        AND  regexp_instr(rating, '^[0-9\\\\.]+$') > 0

),
app_categories AS (
    SELECT
        CASE
            WHEN type = 'Free' THEN 'Free'
            ELSE 'Paid'
        END AS `应用类型`,
        numeric_rating AS `评分`
    FROM
        filtered_apps
)
SELECT
    AVG(CASE WHEN `应用类型` = 'Paid' THEN `评分` END) - 
    AVG(CASE WHEN `应用类型` = 'Free' THEN `评分` END) AS `评分差异`
FROM
    app_categories;