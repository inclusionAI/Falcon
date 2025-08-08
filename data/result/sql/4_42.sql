WITH      industry_avg AS (
          SELECT    AVG(CAST(dayslate AS BIGINT)) AS industry_avg_days
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          )
SELECT    customerid AS `customerid`,
          COUNT(*) AS `逾期次数`
FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_historieswhere paperlessbill = 'Paper'
AND       CAST(dayslate AS BIGINT) > (
          SELECT    industry_avg_days
          FROM      industry_avg
          )
GROUP BY  customerid;