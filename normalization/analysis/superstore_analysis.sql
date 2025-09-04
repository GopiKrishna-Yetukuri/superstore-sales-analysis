-- ===================================================
	-- analysing the data for businees insights
-- ===================================================

-- Total number of customers
  
SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- Finding total sales and total profit

SELECT 
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM OrderDetails;

-- sales by region

SELECT 
    c.Region,
    ROUND(SUM(od.Sales),2) AS Total_Sales
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.Order_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Sales DESC;

-- top5 customers by sales

SELECT 
    c.Customer_Name,
    ROUND(SUM(od.Sales),2) AS Total_Sales
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.Order_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Sales DESC
LIMIT 5;

-- sales and profit by category and sub-category

SELECT 
    p.Category,
    p.Sub_Category,
    ROUND(SUM(od.Sales),2) AS Total_Sales,
    ROUND(SUM(od.Profit),2) AS Total_Profit
FROM OrderDetails od
JOIN Products p ON od.Product_ID = p.Product_ID
GROUP BY p.Category, p.Sub_Category
ORDER BY Total_Sales DESC;

-- monthly sales trend

SELECT 
    DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month,
    ROUND(SUM(od.Sales),2) AS Total_Sales
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.Order_ID
GROUP BY DATE_FORMAT(o.Order_Date, '%Y-%m')
ORDER BY Month;

-- top10 profitable products

SELECT 
    p.Product_Name,
    ROUND(SUM(od.Profit),2) AS Total_Profit
FROM OrderDetails od
JOIN Products p ON od.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- average discount by region

SELECT 
    c.Region,
    ROUND(AVG(od.Discount),2) AS Avg_Discount
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.Order_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Avg_Discount DESC;

-- top10 losing orders or orders with negative profits

SELECT 
    o.Order_ID,
    SUM(od.Sales) AS Order_Sales,
    SUM(od.Profit) AS Order_Profit
FROM OrderDetails od
JOIN Orders o ON od.Order_ID = o.Order_ID
GROUP BY o.Order_ID
HAVING SUM(od.Profit) < 0
ORDER BY Order_Profit ASC
LIMIT 10;

-- life time values of top10 customers

SELECT 
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    ROUND(SUM(od.Sales),2) AS Total_Sales,
    ROUND(SUM(od.Profit),2) AS Total_Profit
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN OrderDetails od ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;