WITH customer_summary AS (
    SELECT
        countrycode,
        customerid,
        SUM(CAST(dayslate AS BIGINT)) AS total_dayslate,
        SUM(CAST(invoiceamount AS DOUBLE)) AS total_invoiceamount
    FROM
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    GROUP BY
        countrycode, customerid
)
SELECT
    countrycode AS `countrycode`,
    customerid AS `customerid`,
    total_dayslate AS `total_dayslate`,
    total_invoiceamount AS `total_invoiceamount`,
    RANK() OVER (PARTITION BY countrycode ORDER BY total_invoiceamount DESC) AS `invoice_rank`
FROM
    customer_summary
ORDER BY
    `invoice_rank`;