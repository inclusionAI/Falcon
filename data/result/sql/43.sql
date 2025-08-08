WITH      filtered_data AS (
          -- 筛选存在争议且结算时间超过30天的记录    
          SELECT    customerid,
                    invoiceamount
          FROM      ant_icube_dev.di_finance_factoring_ibm_late_payment_histories
          WHERE     disputed = 'Yes'
          AND       CAST(daystosettle AS INT) > 30
          ),
          sum_amount AS ( -- 按客户计算总金额   
          SELECT    customerid,
                    SUM(CAST(invoiceamount AS DOUBLE)) AS total_amount
          FROM      filtered_data
          GROUP BY  customerid
          ),
          ranked_result AS (
          -- 按总金额降序排名    
          SELECT    customerid,
                    total_amount,
                    ROW_NUMBER() OVER (
                    ORDER BY  total_amount DESC
                    ) AS rn
          FROM      sum_amount
          )
          -- 获取金额总和最大的客户
SELECT    customerid AS `客户ID`,
          total_amount AS `总金额`
FROM      ranked_result where rn = 1;