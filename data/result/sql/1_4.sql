WITH grouped_investments AS (
    SELECT 
        gender AS `性别`,
        CAST(age AS INT) AS `年龄`,
        avenue AS `投资途径`,
        COUNT(*) AS `人数`
    FROM ant_icube_dev.di_finance_data
    WHERE 
        gender IS NOT NULL 
        AND age IS NOT NULL 
        AND avenue IS NOT NULL
    GROUP BY `性别`, `年龄`, `投资途径`
    HAVING COUNT(*) > 0  -- 确保有实际数据
)
SELECT 
    `性别`,
    `年龄`,
    `投资途径`,
    `人数`
FROM grouped_investments
ORDER BY 
    `性别`, 
    `年龄` ASC, 
    `人数` DESC;  -- 人数多的投资途径优先展示