WITH high_temp_sales AS (
    -- Step 1: Join sales data with temperature data for days with temperature > 30
    SELECT 
        s.Dept,
        s.Weekly_Sales,
        f.Temperature
    FROM walmart_sales s
    JOIN walmart_features f ON s.Store = f.Store AND s.Date = f.Date
    WHERE f.Temperature > 30
),
dept_sales_summary AS (
    -- Step 2: Calculate total sales per department for high temperature days
    SELECT 
        Dept,
        SUM(Weekly_Sales) as total_sales
    FROM high_temp_sales
    GROUP BY Dept
),
overall_avg_sales AS (
    -- Step 3: Calculate overall average sales across all departments
    SELECT 
        AVG(total_sales) as avg_sales
    FROM dept_sales_summary
)
-- Step 4: Calculate percentage difference from overall average
SELECT 
    d.Dept,
    d.total_sales,
    ((d.total_sales - o.avg_sales) / o.avg_sales) * 100 as sales_diff_percentage
FROM dept_sales_summary d
CROSS JOIN overall_avg_sales o
ORDER BY d.Dept;