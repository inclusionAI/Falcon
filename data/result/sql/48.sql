WITH      customer_avg AS (
          SELECT    customerid,
                    countrycode,
                    AVG(CAST(dayslate AS DOUBLE)) AS avg_dayslate
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          GROUP BY  customerid,
                    countrycode
          ),
          country_avg AS (
          SELECT    countrycode,
                    AVG(CAST(dayslate AS DOUBLE)) AS avg_country_dayslate
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          GROUP BY  countrycode
          )
SELECT    customerid AS `客户id`,
          ca.countrycode AS `国家代码`,
          ca.avg_dayslate AS `平均逾期天数`
FROM      customer_avg ca
JOIN      country_avg co ON ca.countrycode = co.countrycode
WHERE     ca.avg_dayslate > co.avg_country_dayslate;