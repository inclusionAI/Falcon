WITH filtered_invoices AS (
    SELECT
        customerid,
        invoicenumber
    FROM
        ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
    WHERE
        paperlessbill = 'Paper'
        AND CAST(daystosettle AS BIGINT) > 60
)
SELECT
    customerid AS `客户ID`,
    COUNT(invoicenumber) AS `发票总数`
FROM
    filtered_invoices
GROUP BY
    customerid
ORDER BY
    customerid;