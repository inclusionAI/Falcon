WITH      quarterly_settled_overdue AS (
          SELECT    customerid,
                    YEAR(to_date (settleddate, 'MM/dd/yyyy')) AS settle_year,
                    MONTH(to_date (settleddate, 'MM/dd/yyyy')) AS settle_month,
                    SUM(CAST(invoiceamount AS DOUBLE)) AS total_overdue
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          WHERE     MONTH(to_date (settleddate, 'MM/dd/yyyy')) IN (3, 6, 9, 12)
          AND       CAST(dayslate AS INT) > 0
          GROUP BY  customerid,
                    YEAR(to_date (settleddate, 'MM/dd/yyyy')),
                    MONTH(to_date (settleddate, 'MM/dd/yyyy'))
          ),
          monthly_invoice_totals AS (
          SELECT    customerid,
                    YEAR(to_date (invoicedate, 'MM/dd/yyyy')) AS invoice_year,
                    MONTH(to_date (invoicedate, 'MM/dd/yyyy')) AS invoice_month,
                    SUM(CAST(invoiceamount AS DOUBLE)) AS total_invoice
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          GROUP BY  customerid,
                    YEAR(to_date (invoicedate, 'MM/dd/yyyy')),
                    MONTH(to_date (invoicedate, 'MM/dd/yyyy'))
          )
SELECT    qso.customerid AS `customerid`
FROM      quarterly_settled_overdue qso
JOIN      monthly_invoice_totals mit ON qso.customerid = mit.customerid
AND       qso.settle_year = mit.invoice_year
AND       qso.settle_month = mit.invoice_month
WHERE     qso.total_overdue / mit.total_invoice > 0.2
GROUP BY  qso.customerid;