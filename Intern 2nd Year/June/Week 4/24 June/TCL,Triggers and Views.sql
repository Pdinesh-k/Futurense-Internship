-- Create the database
CREATE DATABASE librarymanagementsystem1;

USE librarymanagementsystem1;

-- Books - book_id, title, author, price, stock
CREATE TABLE books
(
    book_id INT(3) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT(5)
);

-- Members - member_id, name, age, address
CREATE TABLE members
(
    member_id INT(3) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT(3),
    address VARCHAR(100)
);

-- Borrow - borrow_id, member_id, book_id, borrow_date, return_date
CREATE TABLE borrow
(
    borrow_id INT(3) PRIMARY KEY,
    member_id INT(3),
    book_id INT(3),
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY(member_id) REFERENCES members(member_id),
    FOREIGN KEY(book_id) REFERENCES books(book_id)
);

-- Payment - payment_id, borrow_id, amount, mode, status
CREATE TABLE payment
(
    payment_id INT(3) PRIMARY KEY,
    borrow_id INT(3),
    amount DECIMAL(10, 2) NOT NULL,
    mode VARCHAR(30) CHECK(mode IN('cash','card','online')),
    status VARCHAR(30),
    FOREIGN KEY(borrow_id) REFERENCES borrow(borrow_id)
);

-- Insert values into books table
INSERT INTO books VALUES(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 300.00, 10);
INSERT INTO books VALUES(2, '1984', 'George Orwell', 250.00, 5);
INSERT INTO books VALUES(3, 'To Kill a Mockingbird', 'Harper Lee', 350.00, 15);

-- Insert values into members table
INSERT INTO members VALUES(101, 'Alice', 28, '123 Elm Street');
INSERT INTO members VALUES(102, 'Bob', 35, '456 Maple Avenue');
INSERT INTO members VALUES(103, 'Charlie', 22, '789 Oak Lane');

-- Insert values into borrow table
INSERT INTO borrow VALUES(1001, 101, 1, '2024-06-01', '2024-06-15');
INSERT INTO borrow VALUES(1002, 102, 2, '2024-06-05', '2024-06-20');
INSERT INTO borrow VALUES(1003, 103, 3, '2024-06-10', '2024-06-25');

-- Insert values into payment table
INSERT INTO payment VALUES(1, 1001, 300.00, 'cash', 'completed');
INSERT INTO payment VALUES(2, 1002, 250.00, 'card', 'completed');
INSERT INTO payment VALUES(3, 1003, 350.00, 'online', 'in process');

-- TCL Commands
-- 1) Commit
START TRANSACTION;
INSERT INTO books (book_id, title, author, price, stock) VALUES (4, 'Moby Dick', 'Herman Melville', 400.00, 8);
COMMIT;

-- 2) Rollback
START TRANSACTION;
INSERT INTO books (book_id, title, author, price, stock) VALUES (5, 'Pride and Prejudice', 'Jane Austen', 450.00, 10);
ROLLBACK;

-- 3) Savepoint
START TRANSACTION;
INSERT INTO books (book_id, title, author, price, stock) VALUES (6, 'War and Peace', 'Leo Tolstoy', 500.00, 6);
SAVEPOINT sp1;
ROLLBACK TO sp1;

-- Triggers
-- 1) Trigger to update stock after a book is borrowed
DELIMITER //
CREATE TRIGGER update_stock_after_borrow
AFTER INSERT ON borrow
FOR EACH ROW
BEGIN
    UPDATE books
    SET stock = stock - 1
    WHERE book_id = NEW.book_id;
END //
DELIMITER ;

-- 2) Trigger to check stock availability before borrowing
DELIMITER //
CREATE TRIGGER check_stock_before_borrow
BEFORE INSERT ON borrow
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    SELECT stock INTO available_stock FROM books WHERE book_id = NEW.book_id;
    IF available_stock < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this book';
    END IF;
END //
DELIMITER ;

-- 3) Trigger to automatically update payment status after borrow is completed
DELIMITER //
CREATE TRIGGER update_payment_status_after_borrow
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    IF NEW.status IS NULL THEN
        SET NEW.status = 'Pending';
    END IF;
END //
DELIMITER ;

-- 4) Trigger to prevent deletion of a book if it is currently borrowed
DELIMITER //
CREATE TRIGGER prevent_book_deletion
BEFORE DELETE ON books
FOR EACH ROW
BEGIN
    DECLARE borrow_count INT;
    SELECT COUNT(*) INTO borrow_count FROM borrow WHERE book_id = OLD.book_id;
    IF borrow_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete book as it is currently borrowed';
    END IF;
END //
DELIMITER ;

-- Views
-- 1) Create a view that displays the members with their corresponding borrowed books
CREATE VIEW MemberBorrowedBooks AS
SELECT m.member_id, m.name, b.book_id, bo.title, bo.borrow_date, bo.return_date
FROM members m
JOIN borrow bo ON m.member_id = bo.member_id
JOIN books b ON bo.book_id = b.book_id;

-- 2) Create or replace view to show payment details with borrow and member information
CREATE OR REPLACE VIEW PaymentDetails AS
SELECT p.payment_id, p.borrow_id, bo.member_id, m.name, m.age, m.address, p.amount, p.mode, p.status
FROM payment p
JOIN borrow bo ON p.borrow_id = bo.borrow_id
JOIN members m ON bo.member_id = m.member_id;

-- 3) Drop view if it exists
DROP VIEW IF EXISTS PaymentDetails;