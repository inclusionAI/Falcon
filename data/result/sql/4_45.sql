WITH      filtered_disputed AS (
          SELECT    countrycode,
                    customerid,
                    invoicedate,
                    paperlessdate
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          WHERE     disputed = 'Yes'
          ),
          date_conversion AS (
          SELECT    countrycode,
                    customerid,
                    to_date (invoicedate, 'MM/dd/yyyy') AS invoice_date,
                    to_date (paperlessdate, 'MM/dd/yyyy') AS paperless_date
          FROM      filtered_disputed
          WHERE     invoicedate IS NOT NULL
          AND       paperlessdate IS NOT NULL
          ),
          days_filter AS (
          SELECT    countrycode,
                    customerid,
                    DATEDIFF(paperless_date, invoice_date) AS diff_days
          FROM      date_conversion
          WHERE     DATEDIFF(paperless_date, invoice_date) > 30
          )
SELECT    countrycode AS `countrycode`,
          COUNT(DISTINCT customerid) AS `customer_count`
FROM      days_filter
GROUP BY  countrycode;