WITH yearly_data AS
(
    SELECT  code
            ,entity
            ,CAST(year AS INT)                    AS year
            ,CAST(no_of_internet_users AS BIGINT) AS users
    FROM    ant_icube_dev.di_global_lnternet_users
    WHERE   year IS NOT NULL
    AND     no_of_internet_users IS NOT NULL
)
,cumulative AS
(
    SELECT  code
            ,entity
            ,year
            ,users
            ,SUM(users) OVER (PARTITION BY code ORDER BY year) AS cumulative_total
    FROM    yearly_data
    WHERE   year <= 2020
)
SELECT  code              AS `国家代码`
        ,entity           AS `国家名称`
        ,users            AS `2020年互联网用户数`
        ,cumulative_total AS `按年份累计的用户总数`
FROM    cumulative
WHERE   year = 2020