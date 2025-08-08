WITH      filtered_data AS (
          SELECT    platform,
                  name,
                    CAST(eu_sales AS DOUBLE) + CAST(jp_sales AS DOUBLE) AS total_sales
          FROM      ant_icube_dev.di_video_game_sales
          WHERE     CAST(eu_sales AS DOUBLE) + CAST(jp_sales AS DOUBLE) > 1.0
          ),
          platform_stats AS (
          SELECT    platform,
name,
                    total_sales
          FROM      filtered_data
          GROUP BY  platform,
                    name,
                    total_sales
          )
SELECT    
         name,
          total_sales AS `总销售额`,
          (total_sales / SUM(total_sales) OVER ()) * 100 AS `占比`
FROM      platform_stats