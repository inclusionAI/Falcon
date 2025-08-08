WITH filtered_data AS
(
    SELECT  entity
            ,cellular_subscription
    FROM    ant_icube_dev.di_global_lnternet_users
    WHERE   year = '2020'
)
,converted_data AS
(
    SELECT  entity
            ,CAST(cellular_subscription AS BIGINT) AS cellular_subscription
    FROM    filtered_data
)
SELECT  entity                                                   AS `国家`
        ,cellular_subscription                                   AS `蜂窝订阅用户数`
        ,ROW_NUMBER() OVER (ORDER BY cellular_subscription DESC) AS `排名`
        ,AVG(cellular_subscription) OVER (PARTITION BY entity)   AS `平均订阅量`
FROM    converted_data
ORDER BY `排名`;