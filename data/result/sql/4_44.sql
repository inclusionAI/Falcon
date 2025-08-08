WITH      avg_daily_amount AS (
          SELECT    customerid,
                    SUM(CAST(invoiceamount AS DOUBLE)) / NULLIF(SUM(CAST(daystosettle AS BIGINT)), 0) AS avg_daily
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          WHERE     daystosettle IS NOT NULL
          AND       daystosettle != ''
          AND       invoiceamount IS NOT NULL
          AND       invoiceamount != ''
          GROUP BY  customerid
          ),
          recent_overdue AS (
          SELECT    customerid,
                    SUM(CAST(invoiceamount AS DOUBLE)) AS overdue_amount
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          WHERE     CAST(dayslate AS BIGINT) > 0
          
          AND       invoiceamount IS NOT NULL
          AND       invoiceamount != ''
          GROUP BY  customerid
          )
SELECT    a.customerid AS `客户id`
FROM      avg_daily_amount a
INNER     JOIN recent_overdue r ON a.customerid = r.customerid
WHERE     r.overdue_amount >  1.5*a.avg_daily;