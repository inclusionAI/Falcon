WITH      filtered_data AS (
          SELECT    loan_id,
                    CAST(applicantincome AS DOUBLE) AS applicantincome,
                    CAST(coapplicantincome AS DOUBLE) AS coapplicantincome,
                    CAST(loanamount AS DOUBLE) AS loanamount
          FROM      ant_icube_dev.di_finance_loan_approval_prediction_data
          WHERE     education = 'Graduate'
          ),
          grouped_data AS (
          SELECT    loan_id,
                    applicantincome + coapplicantincome AS total_income,
                    AVG(loanamount) AS avg_loanamount
          FROM      filtered_data
          GROUP BY  loan_id,
                    applicantincome + coapplicantincome
          HAVING    AVG(loanamount) > 200
          )
SELECT    loan_id AS `loan_id`,
          total_income AS `总申请收入`,
          avg_loanamount AS `平均贷款金额`
FROM      grouped_data
ORDER BY  loan_id;