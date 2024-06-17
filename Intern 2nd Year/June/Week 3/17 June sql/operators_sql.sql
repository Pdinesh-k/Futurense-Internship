-- 1) Calculate the total number of orders placed by each customer
SELECT cid, COUNT(*) AS total_orders
FROM orders
GROUP BY cid;

-- 2) Find the top 5 most expensive products
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;

-- 3) Retrieve customers who have not placed any orders
SELECT c.*
FROM customer c
LEFT JOIN orders o ON c.cid = o.cid
WHERE o.oid IS NULL;

-- 4) Update the stock level of a product by adding 10 to the current stock
UPDATE products
SET stock = stock + 10
WHERE pid = 101; -- Example product ID

-- 5) Delete all orders that have not been shipped
DELETE FROM orders
WHERE status = 'not shipped';

-- 6) Retrieve the average order amount for each customer
SELECT cid, AVG(amt) AS avg_order_amount
FROM orders
GROUP BY cid;

-- 7) Find the total revenue for each month in the current year
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(amt) AS total_revenue
FROM orders
WHERE YEAR(order_date) = YEAR(CURDATE())
GROUP BY month;

-- 8) Retrieve the products that have not been ordered in the last 6 months
SELECT *
FROM products p
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  JOIN order_items oi ON o.oid = oi.oid
  WHERE oi.pid = p.pid
  AND o.order_date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- 9) Find customers who placed more than 3 orders in the last month
SELECT cid, COUNT(*) AS order_count
FROM orders
WHERE order_date > DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY cid
HAVING order_count > 3;

-- 10) Retrieve the details of products with prices between 100 and 500
SELECT *
FROM products
WHERE price BETWEEN 100 AND 500;
