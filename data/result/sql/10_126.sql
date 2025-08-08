WITH filtered_data AS (
    SELECT
        index,
        close,
        date
    FROM
        ant_icube_dev.stock_exchange_index_data
    WHERE
        TO_DATE(date, 'yyyy-MM-dd') >= DATEADD(GETDATE(), -20 * 365,'day')
),
avg_close_per_index AS (
    SELECT
        index,
        avg(cast(close as double)) as avg_close
    FROM
        filtered_data
    GROUP BY
        index
)
SELECT
    count(distinct a.date) as `交易日数量`
FROM
    filtered_data a
JOIN
    avg_close_per_index b
ON
    a.index = b.index
WHERE
    cast(a.close as double) > b.avg_close