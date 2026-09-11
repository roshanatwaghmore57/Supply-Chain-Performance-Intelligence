create database supply_chain;
USE supply_chain;

DROP TABLE IF EXISTS dataco_staging;

CREATE TABLE dataco_staging (
    `Type` TEXT,
    `Days for shipping (real)` TEXT,
    `Days for shipment (scheduled)` TEXT,
    `Benefit per order` TEXT,
    `Sales per customer` TEXT,
    `Delivery Status` TEXT,
    `Late_delivery_risk` TEXT,
    `Category Id` TEXT,
    `Category Name` TEXT,
    `Customer City` TEXT,
    `Customer Country` TEXT,
    `Customer Email` TEXT,
    `Customer Fname` TEXT,
    `Customer Id` TEXT,
    `Customer Lname` TEXT,
    `Customer Password` TEXT,
    `Customer Segment` TEXT,
    `Customer State` TEXT,
    `Customer Street` TEXT,
    `Customer Zipcode` TEXT,
    `Department Id` TEXT,
    `Department Name` TEXT,
    `Latitude` TEXT,
    `Longitude` TEXT,
    `Market` TEXT,
    `Order City` TEXT,
    `Order Country` TEXT,
    `Order Customer Id` TEXT,
    `order date (DateOrders)` TEXT,
    `Order Id` TEXT,
    `Order Item Cardprod Id` TEXT,
    `Order Item Discount` TEXT,
    `Order Item Discount Rate` TEXT,
    `Order Item Id` TEXT,
    `Order Item Product Price` TEXT,
    `Order Item Profit Ratio` TEXT,
    `Order Item Quantity` TEXT,
    `Sales` TEXT,
    `Order Item Total` TEXT,
    `Order Profit Per Order` TEXT,
    `Order Region` TEXT,
    `Order State` TEXT,
    `Order Status` TEXT,
    `Order Zipcode` TEXT,
    `Product Card Id` TEXT,
    `Product Category Id` TEXT,
    `Product Description` TEXT,
    `Product Image` TEXT,
    `Product Name` TEXT,
    `Product Price` TEXT,
    `Product Status` TEXT,
    `shipping date (DateOrders)` TEXT,
    `Shipping Mode` TEXT
);

LOAD DATA LOCAL INFILE
'C:/Users/hp/OneDrive/Desktop/Data Science-502/New folder/DataCoSupplyChainDataset.csv'
INTO TABLE dataco_staging
CHARACTER SET latin1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) AS total_rows
FROM dataco_staging;
select * from dataco_staging;
SELECT *
FROM dataco_staging
LIMIT 10;

SELECT
    MIN(`Days for shipping (real)`) AS min_actual_days,
    MAX(`Days for shipping (real)`) AS max_actual_days,
    MIN(`Days for shipment (scheduled)`) AS min_scheduled_days,
    MAX(`Days for shipment (scheduled)`) AS max_scheduled_days
FROM dataco_staging;

SELECT
    `Delivery Status`,
    COUNT(*) AS orders
FROM dataco_staging
GROUP BY `Delivery Status`;

SELECT
    `Shipping Mode`,
    COUNT(*) AS shipments
FROM dataco_staging
GROUP BY `Shipping Mode`;

USE supply_chain;

DROP TABLE IF EXISTS fact_supply_chain;

CREATE TABLE fact_supply_chain (
    order_id INT,
    order_item_id INT,

    product_id INT,
    product_name VARCHAR(100),
    category_id INT,
    category_name VARCHAR(50),

    customer_id INT,
    customer_segment VARCHAR(30),

    order_date DATETIME,
    shipping_date DATETIME,

    actual_shipping_days INT,
    scheduled_shipping_days INT,

    delivery_status VARCHAR(30),
    late_delivery_risk TINYINT,

    shipping_mode VARCHAR(30),

    order_city VARCHAR(100),
    order_state VARCHAR(100),
    order_country VARCHAR(100),
    order_region VARCHAR(50),

    order_quantity INT,

    product_price DECIMAL(12,4),
    sales DECIMAL(12,4),
    order_item_discount DECIMAL(12,4),
    order_item_discount_rate DECIMAL(12,8),
    order_item_total DECIMAL(12,4),
    order_profit DECIMAL(12,4),
    profit_ratio DECIMAL(12,8),

    product_status TINYINT
);

USE supply_chain;

INSERT INTO fact_supply_chain
SELECT
    CAST(NULLIF(TRIM(`Order Id`), '') AS UNSIGNED),
    CAST(NULLIF(TRIM(`Order Item Id`), '') AS UNSIGNED),

    CAST(NULLIF(TRIM(`Product Card Id`), '') AS UNSIGNED),
    TRIM(`Product Name`),
    CAST(NULLIF(TRIM(`Product Category Id`), '') AS UNSIGNED),
    TRIM(`Category Name`),

    CAST(NULLIF(TRIM(`Order Customer Id`), '') AS UNSIGNED),
    TRIM(`Customer Segment`),

    STR_TO_DATE(TRIM(`order date (DateOrders)`), '%c/%e/%Y %H:%i'),
    STR_TO_DATE(TRIM(`shipping date (DateOrders)`), '%c/%e/%Y %H:%i'),

    CAST(NULLIF(TRIM(`Days for shipping (real)`), '') AS UNSIGNED),
    CAST(NULLIF(TRIM(`Days for shipment (scheduled)`), '') AS UNSIGNED),

    TRIM(`Delivery Status`),
    CAST(NULLIF(TRIM(`Late_delivery_risk`), '') AS UNSIGNED),

    TRIM(`Shipping Mode`),

    TRIM(`Order City`),
    TRIM(`Order State`),
    TRIM(`Order Country`),
    TRIM(`Order Region`),

    CAST(NULLIF(TRIM(`Order Item Quantity`), '') AS UNSIGNED),

    CAST(NULLIF(TRIM(`Product Price`), '') AS DECIMAL(12,4)),
    CAST(NULLIF(TRIM(`Sales`), '') AS DECIMAL(12,4)),
    CAST(NULLIF(TRIM(`Order Item Discount`), '') AS DECIMAL(12,4)),
    CAST(NULLIF(TRIM(`Order Item Discount Rate`), '') AS DECIMAL(12,8)),
    CAST(NULLIF(TRIM(`Order Item Total`), '') AS DECIMAL(12,4)),
    CAST(NULLIF(TRIM(`Order Profit Per Order`), '') AS DECIMAL(12,4)),
    CAST(NULLIF(TRIM(`Order Item Profit Ratio`), '') AS DECIMAL(12,8)),

    CAST(NULLIF(TRIM(`Product Status`), '') AS UNSIGNED)

FROM dataco_staging;

SELECT COUNT(*) AS total_rows
FROM fact_supply_chain;

SELECT
    shipping_mode,
    COUNT(*) AS shipments
FROM fact_supply_chain
GROUP BY shipping_mode;

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    MIN(shipping_date) AS first_shipping_date,
    MAX(shipping_date) AS last_shipping_date
FROM fact_supply_chain;

USE supply_chain;

DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    category_name VARCHAR(50),
    product_price DECIMAL(12,4),
    product_status TINYINT
);


INSERT INTO dim_product (
    product_id,
    product_name,
    category_id,
    category_name,
    product_price,
    product_status
)
SELECT
    product_id,
    MAX(product_name),
    MAX(category_id),
    MAX(category_name),
    MAX(product_price),
    MAX(product_status)
FROM fact_supply_chain
WHERE product_id IS NOT NULL
GROUP BY product_id;

SELECT COUNT(*) AS product_count
FROM dim_product;

USE supply_chain;

DROP TABLE IF EXISTS dim_location;

CREATE TABLE dim_location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    order_city VARCHAR(100),
    order_state VARCHAR(100),
    order_country VARCHAR(100),
    order_region VARCHAR(50)
);

INSERT INTO dim_location (
    order_city,
    order_state,
    order_country,
    order_region
)
SELECT
    order_city,
    order_state,
    order_country,
    order_region
FROM fact_supply_chain
GROUP BY
    order_city,
    order_state,
    order_country,
    order_region;
    
    SELECT COUNT(*) AS location_count
FROM dim_location;

USE supply_chain;

DROP TABLE IF EXISTS dim_shipping;

CREATE TABLE dim_shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    shipping_mode VARCHAR(30) UNIQUE
);

INSERT INTO dim_shipping (shipping_mode)
SELECT DISTINCT
    TRIM(shipping_mode)
FROM fact_supply_chain
WHERE shipping_mode IS NOT NULL;



UPDATE dim_shipping
SET shipping_mode = TRIM(TRAILING '\r' FROM shipping_mode);

SELECT 
    shipping_mode,
    LENGTH(shipping_mode) AS length_value,
    HEX(shipping_mode) AS hex_value
FROM dim_shipping
ORDER BY shipping_id;

SELECT *
FROM dim_shipping;

USE supply_chain;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day_of_week INT,
    day_name VARCHAR(20)
);

INSERT INTO dim_date (
    date_id,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day_of_week,
    day_name
)
SELECT DISTINCT
    DATE_FORMAT(order_date, '%Y%m%d') + 0 AS date_id,
    DATE(order_date) AS full_date,
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    DAYOFWEEK(order_date) AS day_of_week,
    DAYNAME(order_date) AS day_name
FROM fact_supply_chain
WHERE order_date IS NOT NULL;

SELECT *
FROM dim_date
ORDER BY full_date
LIMIT 10;

SELECT 
    COUNT(*) AS total_dates,
    MIN(full_date) AS first_date,
    MAX(full_date) AS last_date
FROM dim_date;
-- =========================================
-- BUSINESS ANALYSIS QUERIES
-- =========================================
-- 1. Delivery Status Performance
SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM fact_supply_chain
GROUP BY delivery_status
ORDER BY total_orders DESC;

-- Shipping Mode
SELECT
    shipping_mode,
    COUNT(*) AS total_orders
FROM fact_supply_chain
GROUP BY shipping_mode
ORDER BY total_orders DESC;

-- Region Performance
SELECT
    order_region,
    COUNT(*) AS total_orders
FROM fact_supply_chain
GROUP BY order_region
ORDER BY total_orders DESC limit 5;

-- Top 5 products with most orders
SELECT
    product_name,
    COUNT(*) AS total_orders
FROM fact_supply_chain
GROUP BY product_name
ORDER BY total_orders DESC
LIMIT 5;

-- Top 5 products by profit
SELECT
    product_name,
    ROUND(SUM(order_profit), 2) AS total_profit
FROM fact_supply_chain
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 5;

-- Top 5 regions by profit
SELECT
    order_region,
    ROUND(SUM(order_profit), 2) AS total_profit
FROM fact_supply_chain
GROUP BY order_region
ORDER BY total_profit DESC
LIMIT 5;

-- Average delivery delay by shipping mode
SELECT
    shipping_mode,
    ROUND(AVG(actual_shipping_days - scheduled_shipping_days), 2) AS avg_delay
FROM fact_supply_chain
GROUP BY shipping_mode
ORDER BY avg_delay DESC;

-- products causing the most late deliveries:
SELECT
    product_name,
    ROUND(AVG(late_delivery_risk), 2) AS late_rate
FROM fact_supply_chain
GROUP BY product_name
ORDER BY late_rate DESC
LIMIT 5;

-- Which regions have the highest delivery delays?
SELECT
    order_region,
    ROUND(AVG(actual_shipping_days - scheduled_shipping_days), 2) AS avg_delay
FROM fact_supply_chain
GROUP BY order_region
ORDER BY avg_delay DESC
LIMIT 5;

-- Top 5 regions by sales
SELECT
    order_region,
    ROUND(SUM(sales), 2) AS total_sales
FROM fact_supply_chain
GROUP BY order_region
ORDER BY total_sales DESC
LIMIT 5;

-- Average delivery delay by region
SELECT
    order_region,
    ROUND(AVG(actual_shipping_days ), 2) AS avg_actual_shipping,
    ROUND(AVG(scheduled_shipping_days), 2) AS avg_scheduled_shipping,
    ROUND(
        AVG(actual_shipping_days - scheduled_shipping_days), 2
    ) AS avg_delay
FROM fact_supply_chain
GROUP BY order_region
ORDER BY avg_delay DESC;

-- Sales by Shipping Mode
SELECT
    shipping_mode,
    ROUND(SUM(sales), 2) AS total_sales
FROM fact_supply_chain
GROUP BY shipping_mode
ORDER BY total_sales DESC;

-- Profit by Shipping Mode
SELECT
    shipping_mode,
    ROUND(SUM(order_profit), 2) AS total_profit
FROM fact_supply_chain
GROUP BY shipping_mode
ORDER BY total_profit DESC;

