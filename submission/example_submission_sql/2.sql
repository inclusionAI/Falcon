WITH store_sales AS (
    SELECT 
        Store,
        SUM(Weekly_Sales) AS Total_Sales
    FROM 
        walmart_sales
    GROUP BY 
        Store
)
SELECT 
    ss.Store,
    ws.Type,
    ss.Total_Sales
FROM 
    store_sales ss
JOIN 
    walmart_stores ws ON ss.Store = ws.Store;