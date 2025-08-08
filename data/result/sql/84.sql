WITH      filtered_year AS (
          SELECT    genre,
                    name,
                    eu_sales
          FROM      ant_icube_dev.di_video_game_sales
          WHERE     YEAR = '2005'
          ),
          filtered_sales AS (
          SELECT    genre,
                    name,
          FROM      filtered_year
          WHERE     CAST(eu_sales AS DOUBLE) > 0.5
          )
SELECT    genre AS `genre`,
          COUNT(name) AS `数量`
FROM      filtered_sales
GROUP BY  genre
ORDER BY  genre;