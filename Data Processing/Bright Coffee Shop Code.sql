SELECT *
FROM case_study1.sales_analysis.bright_coffee_shop_sales
LIMIT 10;

-- Convert Unit Price from string to decimal (double)
SELECT 
    transaction_id,
    unit_price,
    CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS unit_price_clean
FROM case_study1.sales_analysis.bright_coffee_shop_sales;

-- To check number of records
SELECT COUNT(*) AS total_records
FROM case_study1.sales_analysis.bright_coffee_shop_sales; -- There are 149116 total records

-- To check duplicates
SELECT *,
    COUNT(*)
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL
HAVING COUNT(*) > 1; -- No duplicates found

-- To check for null values
SELECT *
FROM case_study1.sales_analysis.bright_coffee_shop_sales
WHERE (transaction_id, transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail) IS NULL; -- No null values

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The processing part

-- 1. TOTAL AMOUNT FOR EACH TRANSACTION
SELECT 
    transaction_id,
    transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS Total_amount 
FROM case_study1.sales_analysis.bright_coffee_shop_sales;

    -- TOTAL REVENUE
    SELECT 
        SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue 
    FROM case_study1.sales_analysis.bright_coffee_shop_sales;

    SELECT -- This shows total revenue per transaction
        transaction_id,
        SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue_Per_Transaction
    FROM case_study1.sales_analysis.bright_coffee_shop_sales
    GROUP BY ALL;

-- NOW WE CAN  BREAK DOWN THIS REVENUE 

-- 2. TOTAL REVENUE PER PRODUCT CATEGORY
SELECT 
    product_category,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue_Per_Category
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- 3. TOTAL REVENUE PER PRODUCT CATEGORY AND PRODUCT DETAILS
SELECT 
    product_category,
    product_detail,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue_Per_Product 
FROM case_study1.sales_analysis.bright_coffee_shop_sales
-- WHERE product_category = 'Tea'
GROUP BY ALL
ORDER BY product_category;

-- 4. TOTAL REVENUE PER PRODUCT TYPE
SELECT 
    product_type,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue_Per_Type
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- 5. TOTAL UNITS SOLD
SELECT 
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales;

-- BREAK DOWN UNITS SOLD
-- UNITS SOLD PER PRODUCT CATEGORY
SELECT 
    product_category,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- UNITS SOLD PER PRODUCT TYPE
SELECT 
    product_type,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- UNITS SOLD PER PRODUCT CATEGORY AND PRODUCT DETAILS
SELECT 
    product_category,
    product_detail,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL
ORDER BY product_category;

-- UNITS SOLD PER STORE LOCATION
SELECT 
    store_location,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL
ORDER BY store_location;
 
 -- TOTAL UNITS SOLD PER DAY
SELECT 
    DAYNAME(transaction_date) AS Day_Name,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

 -- TOTAL UNITS SOLD PER MONTH
SELECT 
     MONTHNAME(transaction_date) AS Month_Name,
    SUM(transaction_qty) AS Total_Units_Sold
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- 6. TOTAL REVENUE PER STORE LOCATION
SELECT 
    store_location,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue_Per_Store
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- 7. TOTAL REVENUE BASED ON THE TIME OF THE DAY (WHICH PART OF THE DAY DID WE ,MAKE MORE MONEY)
    --  Earliest and latest transaction time 
    SELECT 
        MIN(transaction_time), -- earliest transaction time
        MAX(transaction_time) -- latest transaction time
    FROM case_study1.sales_analysis.bright_coffee_shop_sales;

    -- 6am - 11:59:59 => Morning
    -- 12pm - 16:59:59 => Afternoon
    -- 17pm - 19:59:59 => Evening
    -- After 200 => Night

SELECT 
    -- transaction_time,
    -- product_category,
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '07:00:00' AND '19:59:59' THEN 'Evining'
        ELSE 'Night'
    END AS time_bucket,
     SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS Total_Revenue
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;

-- NUMBER OF TRANSACTION PER TIME BUCKET
SELECT 
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '07:00:00' AND '19:59:59' THEN 'Evining'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(transaction_id) AS total_transactions
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;


-- 8. Date extraction (Month name, month_id, day_name,)
SELECT 
    transaction_date,
    MONTHNAME(transaction_date) AS Month_Name,
    MONTH(transaction_date) AS Month_Number,
    DATE_FORMAT(transaction_date,'yyyy-MMM') AS Month_Id,
    DAYNAME(transaction_date) AS Day_Name,
    DAYOFWEEK(transaction_date) AS Day_Number
FROM case_study1.sales_analysis.bright_coffee_shop_sales;
-- WHERE MONTHNAME(transaction_date) = 'Feb';

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COMBINE ALL THE CODES
SELECT 
    transaction_id,
    transaction_date,
    YEAR(transaction_date) AS year,
    MONTHNAME(transaction_date) AS month_name,
    MONTH(transaction_date) AS month_number,
    DATE_FORMAT(transaction_date,'yyyy-MMM') AS month_id,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_number,
    product_category,
    product_type,
    product_detail,
    store_location,
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '07:00:00' AND '19:59:59' THEN 'Evining'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(transaction_id) AS total_transactions,
    SUM(transaction_qty) AS total_units_sold,
    SUM(transaction_qty * (CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)))) AS total_revenue
FROM case_study1.sales_analysis.bright_coffee_shop_sales
GROUP BY ALL;