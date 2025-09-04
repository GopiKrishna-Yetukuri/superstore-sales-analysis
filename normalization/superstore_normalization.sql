-- ==========================================================
-- normalizing the single flat table into multiple tables
-- ==========================================================
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- Create Customers table

CREATE TABLE Customers (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50)
);

-- Insert unique customers (resolve duplicates by using GROUP BY)

INSERT INTO Customers (Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code, Region)
SELECT 
    Customer_ID,
    MAX(Customer_Name),
    MAX(Segment),
    MAX(Country),
    MAX(City),
    MAX(State),
    MAX(Postal_Code),
    MAX(Region)
FROM superstore
GROUP BY Customer_ID;

-- Create Products table

CREATE TABLE Products (
    Product_ID VARCHAR(20) PRIMARY KEY,
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(200)
);

-- Insert unique products
INSERT INTO Products (Product_ID, Category, Sub_Category, Product_Name)
SELECT 
    Product_ID,
    MAX(Category),
    MAX(Sub_Category),
    MAX(Product_Name)
FROM superstore
GROUP BY Product_ID;

-- Create Orders table

CREATE TABLE Orders (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

-- Insert orders that reference valid customers
INSERT INTO Orders (Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID)
SELECT DISTINCT 
    s.Order_ID,
    s.Order_Date,
    s.Ship_Date,
    s.Ship_Mode,
    s.Customer_ID
FROM superstore s
WHERE s.Customer_ID IN (SELECT Customer_ID FROM Customers);

-- Create OrderDetails table

CREATE TABLE OrderDetails (
    OrderDetail_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

-- Insert order details that reference valid orders & products
INSERT INTO OrderDetails (Order_ID, Product_ID, Sales, Quantity, Discount, Profit)
SELECT 
    s.Order_ID,
    s.Product_ID,
    s.Sales,
    s.Quantity,
    s.Discount,
    s.Profit
FROM superstore s
WHERE s.Order_ID IN (SELECT Order_ID FROM Orders)
  AND s.Product_ID IN (SELECT Product_ID FROM Products);