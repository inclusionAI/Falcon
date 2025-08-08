WITH category_avg AS
(
	SELECT  category
	       ,AVG(cast(rating AS double)) AS avg_rating
	FROM ant_icube_dev.di_google_play_store_apps
	WHERE rating is not null
	AND rating != ''
	GROUP BY  category
)
SELECT  a.app                    AS `app`
       ,a.category               AS `category`
       ,cast(a.rating AS double) AS `rating`
       ,c.avg_rating             AS `所属类别平均分`
from ant_icube_dev.di_google_play_store_apps a
INNER JOIN category_avg c
ON a.category = c.category 
where cast(a.rating AS double) > c.avg_rating
ORDER BY c.avg_rating DESC LIMIT 10;