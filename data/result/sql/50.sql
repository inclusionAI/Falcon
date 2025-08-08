SELECT
    countrycode AS `国家代码`,
    AVG(daystosettle) AS `平均处理周期`
FROM ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
WHERE disputed = 'Yes'
GROUP BY countrycode
HAVING AVG(daystosettle) > 35;