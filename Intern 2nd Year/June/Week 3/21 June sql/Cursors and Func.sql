USE librarymanagementsystem;

-- Query 1: Create a procedure to insert a new book into the books table
DELIMITER $$
CREATE PROCEDURE insert_book(IN book_title VARCHAR(255), IN book_author VARCHAR(255), IN book_genre VARCHAR(100), IN book_price DECIMAL(10,2))
BEGIN
    INSERT INTO books (title, author, genre, price) VALUES (book_title, book_author, book_genre, book_price);
END$$
DELIMITER ;

-- Execute Query 1
CALL insert_book('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 15.99);

-- Query 2: Create a function to calculate the total price of all books in a specific genre
DELIMITER $$
CREATE FUNCTION total_price_by_genre(genre_name VARCHAR(100))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(10,2);
    SELECT SUM(price) INTO total_price FROM books WHERE genre = genre_name;
    RETURN total_price;
END$$
DELIMITER ;

-- Execute Query 2
SELECT total_price_by_genre('Fiction');

-- Query 3: Create a procedure with an IN parameter to retrieve details of a specific book by its ID
DELIMITER $$
CREATE PROCEDURE get_book_details(IN book_id INT)
BEGIN
    SELECT * FROM books WHERE id = book_id;
END$$
DELIMITER ;

-- Execute Query 3
CALL get_book_details(1);

-- Query 4: Create a procedure with an OUT parameter to get the count of books in the books table
DELIMITER $$
CREATE PROCEDURE get_book_count(OUT total_books INT)
BEGIN
    SELECT COUNT(*) INTO total_books FROM books;
END$$
DELIMITER ;

-- Execute Query 4
CALL get_book_count(@total_books);
SELECT @total_books AS total_books;

-- Query 5: Create a procedure to update the price of a book based on its ID
DELIMITER $$
CREATE PROCEDURE update_book_price(IN book_id INT, IN new_price DECIMAL(10,2))
BEGIN
    UPDATE books SET price = new_price WHERE id = book_id;
END$$
DELIMITER ;

-- Execute Query 5
CALL update_book_price(1, 18.99);

-- Query 6: Create a procedure to delete a book from the books table by its ID
DELIMITER $$
CREATE PROCEDURE delete_book(IN book_id INT)
BEGIN
    DELETE FROM books WHERE id = book_id;
END$$
DELIMITER ;

-- Execute Query 6
CALL delete_book(2);

-- Query 7: Create a function to get the average price of all books in the library
DELIMITER $$
CREATE FUNCTION avg_price_of_books()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_price DECIMAL(10,2);
    SELECT AVG(price) INTO avg_price FROM books;
    RETURN avg_price;
END$$
DELIMITER ;

-- Execute Query 7
SELECT avg_price_of_books();

-- Query 8: Create a cursor to iterate through all books and print their titles
DELIMITER $$
CREATE PROCEDURE print_book_titles()
BEGIN
    DECLARE book_title VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    DECLARE book_cursor CURSOR FOR SELECT title FROM books;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN book_cursor;

    get_titles: LOOP
        FETCH book_cursor INTO book_title;
        IF done THEN
            LEAVE get_titles;
        END IF;
        SELECT book_title;
    END LOOP get_titles;

    CLOSE book_cursor;
END$$
DELIMITER ;

-- Execute Query 8
CALL print_book_titles();

-- Query 9: Create a procedure to get the most expensive book in each genre
DELIMITER $$
CREATE PROCEDURE most_expensive_books_per_genre()
BEGIN
    SELECT genre, title, MAX(price) AS max_price
    FROM books
    GROUP BY genre;
END$$
DELIMITER ;

-- Execute Query 9
CALL most_expensive_books_per_genre();

-- Query 10: Create a function to get the count of books by a specific author
DELIMITER $$
CREATE FUNCTION count_books_by_author(author_name VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE book_count INT;
    SELECT COUNT(*) INTO book_count FROM books WHERE author = author_name;
    RETURN book_count;
END$$
DELIMITER ;

-- Execute Query 10
SELECT count_books_by_author('F. Scott Fitzgerald');
