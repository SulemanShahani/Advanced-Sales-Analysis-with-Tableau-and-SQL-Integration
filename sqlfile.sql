use salesdata;
SELECT 
    `Product Id`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Revenue
FROM
    orders
GROUP BY
    `Product Id`;
    
SELECT 
    `Product Id`,
    Revenue,
    RankNum
FROM (
    SELECT 
        `Product Id`,
        SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Revenue,
        RANK() OVER (ORDER BY SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) DESC) AS RankNum
    FROM
        orders
    GROUP BY
        `Product Id`
) AS RankedRevenue
WHERE
    RankNum <= 10
ORDER BY
    RankNum;

USE salesdata;

SELECT 
    `Product Id`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalRevenue
FROM
    orders
GROUP BY
    `Product Id`
ORDER BY
    TotalRevenue DESC
LIMIT 10;









-- find top 5 highest selling products in each region
USE salesdata;

-- Step 1: Calculate total sales (revenue) per product and region
SELECT 
    `Region`,
    `Product Id`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalRevenue
FROM
    orders
GROUP BY
    `Region`, `Product Id`;

-- Step 2: Rank products within each region based on total revenue
SELECT 
    `Region`,
    `Product Id`,
    TotalRevenue,
    RankNum
FROM (
    SELECT 
        `Region`,
        `Product Id`,
        TotalRevenue,
        ROW_NUMBER() OVER (PARTITION BY `Region` ORDER BY TotalRevenue DESC) AS RankNum
    FROM (
        SELECT 
            `Region`,
            `Product Id`,
            SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalRevenue
        FROM
            orders
        GROUP BY
            `Region`, `Product Id`
    ) AS RankedRevenue
) AS RankedWithRank
WHERE
    RankNum <= 5
ORDER BY
    `Region`, RankNum;




-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
USE salesdata;

-- Query to calculate sales for each month in 2022
SELECT 
    YEAR(`Order Date`) AS Year,
    MONTH(`Order Date`) AS Month,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Sales
FROM
    orders
WHERE
    YEAR(`Order Date`) = 2022
GROUP BY
    YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY
    Year, Month;

-- Query to calculate sales for each month in 2023
SELECT 
    YEAR(`Order Date`) AS Year,
    MONTH(`Order Date`) AS Month,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Sales
FROM
    orders
WHERE
    YEAR(`Order Date`) = 2023
GROUP BY
    YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY
    Year, Month;

-- Month-over-Month Growth Comparison:
SELECT 
    CONCAT(MONTHNAME(s2023.Month), ' ', s2023.Year) AS Month_Year,
    s2023.Sales AS Sales_2023,
    s2022.Sales AS Sales_2022,
    ROUND(((s2023.Sales - s2022.Sales) / s2022.Sales) * 100, 2) AS Growth_Percentage
FROM (
    -- Subquery for 2023 sales
    SELECT 
        YEAR(`Order Date`) AS Year,
        MONTH(`Order Date`) AS Month,
        SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Sales
    FROM
        orders
    WHERE
        YEAR(`Order Date`) = 2023
    GROUP BY
        YEAR(`Order Date`), MONTH(`Order Date`)
) AS s2023
JOIN (
    -- Subquery for 2022 sales
    SELECT 
        YEAR(`Order Date`) AS Year,
        MONTH(`Order Date`) AS Month,
        SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS Sales
    FROM
        orders
    WHERE
        YEAR(`Order Date`) = 2022
    GROUP BY
        YEAR(`Order Date`), MONTH(`Order Date`)
) AS s2022 ON s2023.Month = s2022.Month
ORDER BY
    s2023.Year, s2023.Month;

-- Total sales per month
SELECT 
    YEAR(`Order Date`) AS Year,
    MONTH(`Order Date`) AS Month,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY
    Year, Month;


-- Total sales per product category
SELECT 
    `Category`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Category`;


-- Total sales per region
SELECT 
    `Region`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Region`;


-- Top 10 selling products
SELECT 
    `Product Id`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Product Id`
ORDER BY
    TotalSales DESC
LIMIT 10;

-- Total sales per customer segment
SELECT 
    `Segment`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Segment`;

-- Total sales per product subcategory
SELECT 
    `Sub Category`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Sub Category`;

-- Average order size (total sales / number of orders)
SELECT 
    COUNT(`Order Id`) AS TotalOrders,
    AVG(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS AvgOrderSize
FROM
    orders;


-- Average discount percentage and its impact on sales
SELECT 
    AVG(`Discount Percent`) AS AvgDiscountPercent,
    SUM(`List Price` * `Quantity`) AS TotalSalesWithoutDiscount,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSalesWithDiscount
FROM
    orders;



-- Customer lifetime value (total sales per customer)
SELECT 
    `Customer Id`,
    SUM(`List Price` * (1 - (`Discount Percent` / 100)) * `Quantity`) AS TotalSales
FROM
    orders
GROUP BY
    `Customer Id`
ORDER BY
    TotalSales DESC;










