WITH      investment_filtered AS (
          SELECT    source,
                    CAST(mutual_funds AS BIGINT) AS mutual_funds_amount,
                    CAST(fixed_deposits AS BIGINT) AS fixed_deposits_amount,
                    CAST(gold AS BIGINT) AS gold_amount,
                    CAST(government_bonds AS BIGINT) AS government_bonds_amount,
                    CAST(ppf AS BIGINT) AS ppf_amount,
                    CAST(equity_market AS BIGINT) AS equity_market_amount,
                    CAST(debentures AS BIGINT) AS debentures_amount
          FROM      ant_icube_dev.di_finance_data
          WHERE    avenue = 'Mutual Fund'
          ),
          channel_unpivot AS (
          SELECT    source,
                    'mutual_funds' AS channel,
                    mutual_funds_amount AS amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'fixed_deposits',
                    fixed_deposits_amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'gold',
                    gold_amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'government_bonds',
                    government_bonds_amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'ppf',
                    ppf_amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'equity_market',
                    equity_market_amount
          FROM      investment_filtered
          UNION ALL
          SELECT    source,
                    'debentures',
                    debentures_amount
          FROM      investment_filtered
          )
SELECT    source AS `渠道`,
          SUM(amount) AS `总投资金额`,
          AVG(amount) AS `平均投资金额`
FROM      channel_unpivot group BY source order BY  RANK() OVER (ORDER BY  SUM(amount) DESC)