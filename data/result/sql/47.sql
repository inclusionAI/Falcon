WITH      customer_country_amount AS (
          SELECT    countrycode,
                    customerid,
                    SUM(CAST(invoiceamount AS DECIMAL(10, 2))) AS total_amount
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
         where dayslate > 0
          GROUP BY  countrycode,
                    customerid
          )
SELECT    countrycode AS `countrycode`,
          SUM(total_amount) AS `累计逾期金额`
FROM      customer_country_amount
GROUP BY  countrycode
ORDER BY  countrycode;