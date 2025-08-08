WITH valid_sales AS (
    SELECT 
        genre,
        year,
        name,
        -- 安全转换销售额并处理空值/无效值
        COALESCE(cast(jp_sales AS DOUBLE), 0.0) AS jp_sales
    FROM ant_icube_dev.di_video_game_sales
    WHERE jp_sales IS NOT NULL 
        AND jp_sales != ''
        AND cast(jp_sales AS DOUBLE) > 0 -- 排除零销售额
        AND year REGEXP '^[0-9]+$' -- 保证年份只有数字

),
ranked_games AS (
    SELECT 
        genre,
        year,
        name,
        jp_sales,
        -- 使用DENSE_RANK正确处理排名并列
        DENSE_RANK() OVER(
            PARTITION BY genre, year 
            ORDER BY jp_sales DESC
        ) AS sales_rank
    FROM valid_sales
)
SELECT 
    genre AS `游戏类型`,
    year AS `年份`,
    name AS `游戏名称`,
    jp_sales AS `日本销售额`
FROM ranked_games
WHERE sales_rank = 1 -- 只取每个类型每年的第一名
ORDER BY 
    genre, -- 按类型排序
    year, -- 按年份排序
    jp_sales DESC; -- 最后按销售额排序