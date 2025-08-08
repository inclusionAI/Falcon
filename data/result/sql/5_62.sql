WITH      max_dates AS (
          SELECT    industry,
                    MAX(to_date (date_joined, 'MM/dd/yyyy')) AS latest_date
          FROM      ant_icube_dev.di_unicorn_startups
          GROUP BY  industry
          )
SELECT    a.industry AS `行业`,
          a.company AS `公司`
FROM      ant_icube_dev.di_unicorn_startups a
INNER     JOIN max_dates b ON a.industry = b.industry
AND       to_date (a.date_joined, 'MM/dd/yyyy') = b.latest_date;