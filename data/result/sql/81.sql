WITH      base_data AS (
          SELECT    genre,
                    platform,
                    CAST(global_sales AS DOUBLE) AS global_sales
          FROM      ant_icube_dev.di_video_game_sales
          ),
          avg_sales AS (
          SELECT    genre,
                    platform,
                    SUM(global_sales) AS sum_global_sales,
                    AVG(global_sales) AS avg_global_sales
          FROM      base_data
          GROUP BY  genre,
                    platform
          ),
          ranked_platforms AS (
          SELECT    genre,
                    platform,
                    sum_global_sales,
                    avg_global_sales,
                    ROW_NUMBER() OVER (
                    PARTITION BY genre
                    ORDER BY sum_global_sales DESC
                    ) AS rn
          FROM      avg_sales
          ),
          filtered_data AS (
          SELECT    rn ,genre,
                    platform,
                    sum_global_sales,
                    avg_global_sales
          FROM      ranked_platforms
          WHERE     rn <= 5
          )
SELECT 
genre AS `游戏类型`,
          platform AS `平台`,
          sum_global_sales AS `销售额`,
          avg_global_sales AS `平均销售额`
FROM      filtered_data order BY `平均销售额` DESC;