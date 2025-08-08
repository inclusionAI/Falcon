WITH installs_converted AS
(
    SELECT  app
            ,category
            ,CAST(TRANSLATE(installs, ',+', '') AS BIGINT) AS install_num
    FROM    ant_icube_dev.di_google_play_store_apps
    WHERE   installs IS NOT NULL
    AND     installs != ''
)
,category_median AS
(
    SELECT  category
            ,PERCENTILE_APPROX(install_num, 0.5) AS median_install
    FROM    installs_converted
    GROUP BY category
)
SELECT  a.app                              AS `应用`
        ,a.install_num / cm.median_install AS `倍数`
FROM    installs_converted a
JOIN    category_median cm
ON      a.category = cm.category
WHERE   a.install_num > 1000 * cm.median_install;