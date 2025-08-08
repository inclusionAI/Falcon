WITH      filtered_data AS (
          SELECT    platform,
                    CAST(global_sales AS DOUBLE) AS global_sales
          FROM      ant_icube_dev.di_video_game_sales
          WHERE     genre = 'Sports'
          )
SELECT    platform AS `平台`,
          AVG(global_sales) AS `平均全球销售额`
FROM      filtered_data
GROUP BY  platform
ORDER BY  `平台`;