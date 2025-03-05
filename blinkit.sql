-- See all the data imported:
SELECT  * FROM blinkit;

/*
DATA CLEANING:
Cleaning the Item_Fat_Content field ensures data consistency and accuracy in analysis. 
The presence of multiple variations of the same category (e.g., LF, low fat vs. Low Fat) 
can cause issues in reporting, aggregations, and filtering. By standardizing these values, 
we improve data quality, making it easier to generate insights and maintain uniformity in our datasets.
*/
UPDATE blinkit 
SET 
    Item_Fat_Content = CASE
        WHEN Item_Fat_Content IN ('LF' , 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;
    
-- After executing this query check the data has been cleaned or not using below query
select distinct (item_fat_content) from blinkit;


-- A. KPI’s
-- 1. TOTAL SALES:
SELECT 
    CAST(SUM(Total_sales) / 1000000 AS DECIMAL (10 , 2 )) AS Total_Sales_Millions
FROM
    blinkit;
    
-- 2. AVERAGE SALES:
SELECT 
    CAST(AVG(Total_sales) AS DECIMAL (10 , 2 )) AS Avg_Sales
FROM
    blinkit;
    
-- 3. NO OF ITEMS:
SELECT 
    COUNT(*) AS No_of_Items
FROM
    blinkit;

-- 4. AVG RATING:
SELECT 
    CAST(AVG(Rating) AS DECIMAL (10 , 1 )) AS Avg_Rating
FROM
    blinkit;


-- B. Total Sales by Fat Content:
SELECT 
    Item_Fat_content,
    CAST(SUM(Total_sales) AS DECIMAL (10 , 2 )) AS Total_Sales
FROM
    blinkit
GROUP BY Item_Fat_content
ORDER BY Total_Sales DESC;

-- C. Total Sales by Item Type:
SELECT 
    Item_Type,
    CAST(SUM(Total_sales) AS DECIMAL (10 , 2 )) AS Total_Sales
FROM
    blinkit
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- D. Fat Content by Outlet for Total Sales
SELECT 
    Outlet_Location_Type,
    COALESCE(ROUND(SUM(CASE
                        WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales
                        ELSE 0
                    END),
                    2),
            0.00) AS Low_Fat,
    COALESCE(ROUND(SUM(CASE
                        WHEN Item_Fat_Content = 'Regular' THEN Total_Sales
                        ELSE 0
                    END),
                    2),
            0.00) AS Regular
FROM
    blinkit
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- E. Total Sales by Outlet Establishment:
SELECT 
    Outlet_Establishment_Year,
    CAST(SUM(total_sales) AS DECIMAL (10 , 2 )) AS Total_Sales
FROM
    blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- F. Percentage of Sales by Outlet Size:
SELECT 
	Outlet_Size, 
	CAST(SUM(Total_sales) AS DECIMAL (10,2)) AS Total_Sales,
	CAST((SUM(Total_sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL (10,2)) AS Sales_Percentage
FROM 
	blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- G. Sales by Outlet Location:
SELECT 
	Outlet_Location_Type,
    CAST(SUM(Total_Sales) AS DECIMAL (10,2)) AS Total_Sales
FROM 
	blinkit
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- H. All Metrics by Outlet Type:
SELECT 
    Outlet_Type,
    CAST(SUM(Total_Sales) AS DECIMAL (10 , 2 )) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL (10 , 0 )) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL (10 , 2 )) AS Avg_Rating,
    CAST(AVG(Item_Visibility) AS DECIMAL (10 , 2 )) AS Item_Visibility
FROM
    blinkit
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
 
    
