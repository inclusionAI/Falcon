WITH free_apps AS
(
    SELECT  content_rating
    FROM    ant_icube_dev.di_google_play_store_apps
    WHERE   type = 'Free'
)
SELECT  content_rating AS `content_rating`
        ,COUNT(*)      AS `app_count`
FROM    free_apps
GROUP BY content_rating;