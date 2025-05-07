--QUESTION 1
-- Solution: Transform into 1NF
-- Split Products into separate rows.
-- Step 1: Create the original table (for reference)
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Step 2: Insert data
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 3: Normalize to 1NF
SELECT
    OrderID,
    CustomerName,
    TRIM(product) AS Product
FROM ProductDetail,
JSON_TABLE(
    CONCAT('["', REPLACE(Products, ',', '","'), '"]'),
    '$[*]' COLUMNS (product VARCHAR(255) PATH '$')
) AS split_products;

-- QUESTION 2
-- Solution: Transform into 2NF
-- Break into two tables to remove partial dependency:
-- Orders: OrderID, CustomerName
-- OrderItems: OrderID, Product, Quantity
-- Step 1: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Populate the Orders table with distinct OrderID-CustomerName pairs
INSERT INTO Orders
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Populate OrderItems with relevant data
INSERT INTO OrderItems
SELECT OrderID, Product, Quantity
FROM OrderDetails;
