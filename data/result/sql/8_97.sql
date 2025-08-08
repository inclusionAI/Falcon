WITH filtered_apps AS
(
	SELECT  app
	       ,installs
	       ,price
	FROM ant_icube_dev.di_google_play_store_apps
	WHERE category = 'GAME'
	GROUP by app
	       ,installs
	       ,price
), cleaned_data AS
(
	SELECT  app
	       ,installs
	       ,cast(regexp_replace(installs,'[+,]','') AS bigint)  AS installs_num
	       ,cast(regexp_replace(price,'[^0-9.]','') AS decimal) AS price_num
	FROM filtered_apps
	WHERE price is not null
	AND price != ''
), ranked_apps AS
(
	SELECT  app
	       ,installs
	       ,price_num
	       ,ROW_NUMBER() OVER (order by installs_num DESC) AS rn
	FROM cleaned_data
)
select app AS `APP`, installs AS `下载量`, (
SELECT  AVG(price_num)
FROM ranked_apps
WHERE rn <= 3) AS `平均价格` from ranked_apps where rn <= 3;