SELECT * FROM customer_details;
SELECT * FROM exchange_details;
SELECT * FROM product_details;
SELECT * FROM sales_details;
SELECT * FROM stores_details;

-- 1. Find the Total Number of Customers
-- which products have the highest total sales quantities.
SELECT COUNT(*) AS Total_Customers FROM customer_details;

-- 2. Identify the Top 5 Products by Sales Quantity
SELECT 
    p.Product_Name,
    SUM(s.Quantity) AS Total_Quantity_Sold
FROM sales_details s
JOIN product_details p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductKey
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;

-- 3. Calculate Total Revenue by Country
--This query computes the total revenue generated by each country. It uses Unit_Price_USD and Quantity to calculate revenue.
SELECT 
    st.Country,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM sales_details s
JOIN stores_details st ON s.StoreKey = st.StoreKey
JOIN product_details p ON s.ProductKey = p.ProductKey
GROUP BY st.Country
ORDER BY Total_Revenue DESC;

-- 4. Find the Most Common Customer Gender
--This query identifies which gender is most common among customers.
SELECT 
    Gender,
    COUNT(*) AS Total_Customers
FROM customer_details
GROUP BY Gender
ORDER BY Total_Customers DESC;

--5. List Products with No Sales
--This query identifies products that are listed in the product_details table but have not been sold.
SELECT 
    Product_Name 
FROM product_details
WHERE ProductKey NOT IN (
    SELECT DISTINCT ProductKey
    FROM sales_details
);

--6. Determine the Most Profitable Store
--This query calculates which store generated the highest total profit. Profit is the difference between
-- Unit_Price_USD and Unit_Cost_USD, multiplied by the quantity sold.
SELECT 
    st.StoreKey,
    st.Country,
    SUM((p.Unit_Price_USD - p.Unit_Cost_USD) * s.Quantity) AS Total_Profit
FROM sales_details s
JOIN stores_details st ON s.StoreKey = st.StoreKey
JOIN product_details p ON s.ProductKey = p.ProductKey
GROUP BY st.StoreKey
ORDER BY Total_Profit DESC LIMIT 1;

--7. Find the Average Delivery Time for Orders
--This query calculates the average delivery time (in days) for all orders.
SELECT 
    AVG(julianday(Delivery_Date) - julianday(Order_Date)) AS Avg_Delivery_Time_Days
FROM sales_details
WHERE Delivery_Date IS NOT NULL AND Order_Date IS NOT NULL;

--8. Identify the Top 3 States with the Most Stores
--This query lists the states with the highest number of stores.
SELECT 
    State,
    COUNT(*) AS Total_Stores
FROM stores_details
GROUP BY State
ORDER BY Total_Stores DESC
LIMIT 3;

--9. Analyze Currency Usage in Sales
--This query finds the total sales quantity grouped by currency codes.
SELECT 
    Currency_Code,
    SUM(Quantity) AS Total_Sales_Quantity
FROM sales_details
GROUP BY Currency_Code
ORDER BY Total_Sales_Quantity DESC;

--10. Track Exchange Rate Trends
--This query retrieves the average exchange rate for each currency over time.
SELECT 
    Currency_Code,
    AVG(Exchange) AS Avg_Exchange_Rate
FROM exchange_details
GROUP BY Currency_Code
ORDER BY Avg_Exchange_Rate DESC;