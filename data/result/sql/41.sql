SELECT  *
FROM    (
            SELECT  customerid
                    ,SUM(CAST(invoiceamount AS DOUBLE)) AS total_amount
            FROM    ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
            GROUP BY customerid
        )
WHERE   total_amount > (
                           SELECT  AVG(total_amount)
                           FROM    (
                                       SELECT  customerid
                                               ,SUM(CAST(invoiceamount AS DOUBLE)) AS total_amount
                                       FROM    ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
                                       GROUP BY customerid
                                   )
                       );