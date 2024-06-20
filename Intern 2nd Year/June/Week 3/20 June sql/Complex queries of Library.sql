-- Create the database
CREATE DATABASE LibraryManagementSystem;

-- Use the database
USE LibraryManagementSystem;

-- Create the authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create the books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    published_date DATE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Create the members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    join_date DATE
);

-- Create the loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);


-- Insert sample data into authors table
INSERT INTO authors (name) VALUES ('J.K. Rowling'), ('George Orwell'), ('J.R.R. Tolkien');

-- Insert sample data into books table
INSERT INTO books (title, author_id, published_date) VALUES 
('Harry Potter and the Philosopher''s Stone', 1, '1997-06-26'),
('1984', 2, '1949-06-08'),
('The Hobbit', 3, '1937-09-21');

-- Insert sample data into members table
INSERT INTO members (name, join_date) VALUES 
('Alice', '2023-01-15'),
('Bob', '2023-03-22'),
('Charlie', '2024-02-10');

-- Insert sample data into loans table
INSERT INTO loans (book_id, member_id, loan_date, return_date) VALUES 
(1, 1, '2024-05-01', '2024-05-15'),
(2, 2, '2024-05-05', NULL),
(3, 3, '2024-05-10', '2024-05-20');


-- Query 1: Find all books loaned by members who joined in the last year.
SELECT b.title, m.name, l.loan_date
FROM books b
JOIN loans l ON b.book_id = l.book_id
JOIN members m ON l.member_id = m.member_id
WHERE m.join_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Query 2: List all books along with their authors.
SELECT b.title, a.name AS author_name
FROM books b
JOIN authors a ON b.author_id = a.author_id;

-- Query 3: Find the most loaned book in the last month.
SELECT b.title, COUNT(l.loan_id) AS loan_count
FROM books b
JOIN loans l ON b.book_id = l.book_id
WHERE l.loan_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY b.title
ORDER BY loan_count DESC
LIMIT 1;

-- Query 4: List members who have not returned a book within 30 days.
SELECT m.name, b.title, l.loan_date
FROM members m
JOIN loans l ON m.member_id = l.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL AND l.loan_date <= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Query 5: Find the author with the most books in the library.
SELECT a.name, COUNT(b.book_id) AS book_count
FROM authors a
JOIN books b ON a.author_id = b.author_id
GROUP BY a.name
ORDER BY book_count DESC
LIMIT 1;

-- Query 6: Find all overdue books.
SELECT b.title, m.name, l.loan_date
FROM books b
JOIN loans l ON b.book_id = l.book_id
JOIN members m ON l.member_id = m.member_id
WHERE l.return_date IS NULL AND l.loan_date <= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Query 7: List all members who have borrowed books by a specific author.
SELECT DISTINCT m.name
FROM members m
JOIN loans l ON m.member_id = l.member_id
JOIN books b ON l.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';

-- Query 8: Find the number of books loaned out each month for the past year.
SELECT DATE_FORMAT(l.loan_date, '%Y-%m') AS loan_month, COUNT(l.loan_id) AS loan_count
FROM loans l
WHERE l.loan_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY loan_month
ORDER BY loan_month;

-- Query 9: List the top 3 members with the most book loans.
SELECT m.name, COUNT(l.loan_id) AS loan_count
FROM members m
JOIN loans l ON m.member_id = l.member_id
GROUP BY m.name
ORDER BY loan_count DESC
LIMIT 3;

-- Query 10: Find all books that have never been loaned out.
SELECT b.title
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
WHERE l.loan_id IS NULL;
