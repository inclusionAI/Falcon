WITH      avg_days AS (
          SELECT    customerid,
                    AVG(CAST(dayslate AS INT)) AS avg_days
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          GROUP BY  customerid
          HAVING    AVG(CAST(dayslate AS INT)) > 3
          ),
          last_invoice AS (
          SELECT    customerid,
                    invoiceamount,
                    ROW_NUMBER() OVER (
                    PARTITION BY customerid
                    ORDER BY  to_date (invoicedate, 'MM/dd/yyyy') DESC
                    ) AS rn
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          )
SELECT    a.customerid AS `客户id`
FROM      avg_days a
JOIN      last_invoice l ON a.customerid = l.customerid
WHERE     l.rn = 1
AND       CAST(l.invoiceamount AS DECIMAL) > 100;