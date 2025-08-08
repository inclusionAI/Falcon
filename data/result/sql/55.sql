WITH filtered_data AS (
    SELECT
        city,
        company,
        date_joined,
        CAST(SUBSTR(valuation, 2) AS DOUBLE) AS valuation_num
    FROM
        ant_icube_dev.di_unicorn_startups
    WHERE
        country = 'United States'
),
ranked_data AS (
    SELECT
        city,
        company,
        date_joined,
        -- 修改点：使用DENSE_RANK()代替RANK()
        DENSE_RANK() OVER (PARTITION BY city ORDER BY valuation_num DESC) AS `排名`
    FROM
        filtered_data
)
SELECT
    city AS `城市`,
    company AS `公司`,
    date_joined AS `加入日期`,
    `排名`
FROM
    ranked_data
ORDER BY
    `城市`,
    `排名`;