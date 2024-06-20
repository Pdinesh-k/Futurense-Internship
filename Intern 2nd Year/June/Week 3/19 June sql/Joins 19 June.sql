-- ANOMALIES
-- Update Anomaly: Update the price of a product and see the impact on existing orders
UPDATE Products
SET price = 52000
WHERE pid = 1;

-- Delete Anomaly: Delete a product and see the impact on existing orders
DELETE FROM Products
WHERE pid = 5;

-- Insertion Anomaly: Try inserting an order for a non-existent customer
INSERT INTO Orders (oid, cid, pid, amt)
VALUES (10005, 106, 2, 1);

-- Candidate Keys: Display product information and choose the primary key
SELECT pid, pname, price, stock, location
FROM Products;


-- Foreign Keys: Join Orders and Customer tables using the foreign key relationship
SELECT o.oid, c.cname, o.pid
FROM Orders o
INNER JOIN Customer c ON o.cid = c.cid
WHERE o.cid = 102;

-- 1NF: Example of table adhering to 1NF
CREATE TABLE Products_1NF (
    pid INT PRIMARY KEY,
    pname VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    stock INT,
    location VARCHAR(30) CHECK(location IN ('Mumbai', 'Delhi'))
);

-- 2NF: Example of table adhering to 2NF
-- Decomposed Orders table into Orders and Order_Items
CREATE TABLE Orders_2NF (
    oid INT PRIMARY KEY,
    cid INT,
    amt INT NOT NULL,
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    oid INT,
    pid INT,
    product_color VARCHAR(30),
    FOREIGN KEY (oid) REFERENCES Orders_2NF(oid),
    FOREIGN KEY (pid) REFERENCES Products(pid)
);

-- 3NF: Example of table adhering to 3NF
-- Decomposed Orders table into Orders and CustomerCity
CREATE TABLE Orders_3NF (
    oid INT PRIMARY KEY,
    cid INT,
    pid INT,
    amt INT NOT NULL,
    FOREIGN KEY (cid) REFERENCES Customer(cid),
    FOREIGN KEY (pid) REFERENCES Products(pid)
);

CREATE TABLE CustomerCity (
    cid INT PRIMARY KEY,
    city VARCHAR(50),
    FOREIGN KEY (cid) REFERENCES Customer(cid)
);

-- BCNF: Example of table adhering to BCNF
-- Decomposed Orders table into Order_Info and Order_Details
CREATE TABLE Order_Info (
    oid INT PRIMARY KEY,
    amt INT NOT NULL,
    FOREIGN KEY (oid) REFERENCES Orders(oid)
);

CREATE TABLE Order_Details (
    oid INT,
    cid INT,
    pid INT,
    PRIMARY KEY (oid, cid, pid),
    FOREIGN KEY (oid) REFERENCES Orders(oid),
    FOREIGN KEY (cid) REFERENCES Customer(cid),
    FOREIGN KEY (pid) REFERENCES Products(pid)
);
