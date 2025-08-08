WITH app_preprocessed AS
(
    SELECT  category
            ,app
            ,CAST(REGEXP_REPLACE(installs, '[+,]', '') AS BIGINT) AS install_value
            ,CASE
                    WHEN rating RLIKE '^\\d+(\\.\\d+)?$' THEN CAST(rating AS DOUBLE)
                    ELSE NULL
            END                                                   AS rating_value
    FROM    ant_icube_dev.di_google_play_store_apps
    WHERE   installs IS NOT NULL
    AND     rating IS NOT NULL
    AND     REGEXP_REPLACE(installs, '[+,]', '') != ''
)
,category_stats AS
(
    SELECT  category
            ,COUNT(*)                             AS total_apps
            ,PERCENTILE_APPROX(rating_value, 0.5) AS median_rating
    FROM    app_preprocessed
    GROUP BY category
)
,ranked_apps AS
(
    SELECT  category
            ,app
            ,install_value
            ,rating_value
            ,ROW_NUMBER() OVER (PARTITION BY category ORDER BY install_value DESC) AS install_rank
    FROM    app_preprocessed
)
SELECT  r.category       AS `category`
        ,r.app           AS `app`
FROM    ranked_apps r
JOIN    category_stats c
ON      r.category = c.category
WHERE   r.install_rank <= CEIL(c.total_apps * 0.05)
AND     r.rating_value < c.median_rating;