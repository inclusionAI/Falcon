WITH filtered_apps AS (
    SELECT 
        app,
        last_updated,
        rating
    FROM 
        ant_icube_dev.di_google_play_store_apps
    WHERE 
        category = 'TOOLS'
),
valid_records AS (
    SELECT 
        app,
        -- 完整日期解析逻辑
        to_date(
            concat(
                -- 年份处理（处理00→1900, 其他→20xx）
                CASE 
                    WHEN substr(last_updated, -2, 2) = '00' THEN '19'
                    ELSE '20' 
                END,
                substr(last_updated, -2, 2),
                '-',
                -- 月份缩写转数字
                CASE LOWER(substr(last_updated, INSTR(last_updated, '-')+1, 3))
                    WHEN 'jan' THEN '01'
                    WHEN 'feb' THEN '02'
                    WHEN 'mar' THEN '03'
                    WHEN 'apr' THEN '04'
                    WHEN 'may' THEN '05'
                    WHEN 'jun' THEN '06'
                    WHEN 'jul' THEN '07'
                    WHEN 'aug' THEN '08'
                    WHEN 'sep' THEN '09'
                    WHEN 'oct' THEN '10'
                    WHEN 'nov' THEN '11'
                    WHEN 'dec' THEN '12'
                    ELSE NULL -- 处理无效月份
                END,
                '-',
                -- 日期部分（补零确保2位数）
                LPAD(
                    CASE 
                        -- 提取第一个-之前的数字作为日期
                        WHEN INSTR(last_updated, '-') > 0 
                        THEN substr(last_updated, 1, INSTR(last_updated, '-')-1)
                        ELSE ''
                    END,
                    2, '0' -- 不足2位补零
                )
            ),
            'yyyy-MM-dd'
        ) AS update_date,
        CASE
            WHEN cast(rating AS double) BETWEEN 0 AND 5 
            THEN cast(rating AS double)
        END AS clean_rating
    FROM 
        filtered_apps
    WHERE 
        last_updated IS NOT NULL
        AND rating REGEXP '^[0-9\\\\.]+$'
        -- 确保日期格式匹配：数字-字母-数字
        AND last_updated RLIKE '^[0-9]{1,2}-[a-zA-Z]{3}-[0-9]{2}$'
)
SELECT
    app AS `APP`,
    clean_rating AS `用户评分`,
    update_date AS `最后更新日期`
FROM 
    valid_records
WHERE 
    clean_rating IS NOT NULL
    AND update_date IS NOT NULL  -- 确保日期有效
ORDER BY 
    update_date DESC  -- 按日期降序排列（最新在前）
LIMIT 10;