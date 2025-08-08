WITH category_avg AS
(
    SELECT  category
            ,AVG(CAST(rating AS DOUBLE)) AS avg_rating
    FROM    ant_icube_dev.di_google_play_store_apps
    WHERE   rating IS NOT NULL
    AND     rating != ''
    AND     CAST(rating AS DOUBLE) IS NOT NULL
    GROUP BY category
)
,app_detail AS
(
    SELECT  a.app
            ,a.category
            ,CAST(a.rating AS DOUBLE) AS rating
            ,b.avg_rating
    FROM    ant_icube_dev.di_google_play_store_apps a
    INNER JOIN  category_avg b
    ON      a.category = b.category
    WHERE   a.rating IS NOT NULL
    AND     a.rating != ''
    AND     CAST(a.rating AS DOUBLE) IS NOT NULL
)
SELECT  app                    AS `应用名称`
        ,category              AS `类别`
        ,(rating - avg_rating) AS `评分差值`
FROM    app_detail
WHERE   (
            rating - avg_rating
        ) > 0.9;