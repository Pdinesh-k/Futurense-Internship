USE sales_db;

-- String Functions:
-- 1) Concatenate the first name and last name of customers.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- 2) Convert the product names to uppercase.
SELECT UPPER(product_name) AS upper_product_name
FROM products;

-- 3) Find the position of 'e' in customer emails.
SELECT email, INSTR(email, 'e') AS position_of_e
FROM customers;

-- 4) Extract the first 5 characters of product descriptions.
SELECT SUBSTR(description, 1, 5) AS short_description
FROM products;

-- 5) Trim leading and trailing spaces from customer addresses.
SELECT TRIM(address) AS trimmed_address
FROM customers;

-- Date and Time Functions:
-- 6) Get the current date and time.
SELECT SYSDATE() AS current_timestamp;

-- 7) Calculate the number of days between the order date and the current date.
SELECT order_id, DATEDIFF(CURRENT_DATE(), order_date) AS days_since_order
FROM orders;

-- 8) Find the last day of the month for order dates.
SELECT order_id, LAST_DAY(order_date) AS last_day_of_order_month
FROM orders;

-- Numeric Functions:
-- 9) Find the average order amount.
SELECT AVG(order_amount) AS average_order_amount
FROM orders;

-- 10) Calculate the square root of the product price.
SELECT product_id, product_name, SQRT(price) AS sqrt_price
FROM products;
