 -- Procedures and Functions for Library Management System

-- Borrow Book Procedure
CREATE OR REPLACE PROCEDURE BorrowBook (
    book_id IN NUMBER,
    member_id IN NUMBER,
    result OUT VARCHAR2
)
IS
    available_copies NUMBER;
    book_not_available EXCEPTION;
BEGIN
    -- Check if the book is available
    SELECT AvailableCopies INTO available_copies
    FROM Books
    WHERE BookID = book_id;

    IF available_copies <= 0 THEN
        RAISE book_not_available;
    ELSE
        -- Deduct 1 from AvailableCopies
        UPDATE Books
        SET AvailableCopies = AvailableCopies - 1
        WHERE BookID = book_id;

        -- Insert a new row into BorrowRecords
        INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate)
        VALUES (book_id, member_id, SYSDATE);

        result := 'Book borrowed successfully';
    END IF;
EXCEPTION
    WHEN book_not_available THEN
        result := 'Book is not available';
END BorrowBook;


-- Return Book Procedure
CREATE OR REPLACE PROCEDURE ReturnBook (
    book_id IN NUMBER,
    member_id IN NUMBER,
    result OUT VARCHAR2
)
IS
    borrow_date DATE;
    fine_amount NUMBER(10, 2);
    days_late NUMBER;
BEGIN
    -- Update the ReturnDate in BorrowRecords
    UPDATE BorrowRecords
    SET ReturnDate = SYSDATE
    WHERE BookID = book_id AND MemberID = member_id AND ReturnDate IS NULL;

    -- Increase the AvailableCopies count for the returned book
    UPDATE Books
    SET AvailableCopies = AvailableCopies + 1
    WHERE BookID = book_id;

    -- Check if the return is late and log a fine if applicable
    SELECT BorrowDate INTO borrow_date
    FROM BorrowRecords
    WHERE BookID = book_id AND MemberID = member_id AND ReturnDate = SYSDATE;

    days_late := TRUNC(SYSDATE - borrow_date) - 14; -- Assuming a 2-week borrowing period

    IF days_late > 0 THEN
        fine_amount := days_late * 1.00; -- Assuming a fine of $1 per day late
        INSERT INTO Fines (MemberID, BookID, FineAmount, FineDate)
        VALUES (member_id, book_id, fine_amount, SYSDATE);
        result := 'Book returned successfully. Fine amount: $' || fine_amount;
    ELSE
        result := 'Book returned successfully. No fine.';
    END IF;
END ReturnBook;
/

 -- Add Book Procedure
CREATE OR REPLACE PROCEDURE AddBook (
    title IN VARCHAR2,
    author IN VARCHAR2,
    initial_copies IN NUMBER,
    result OUT VARCHAR2
)
IS
BEGIN
    -- Insert a new book into the Books table with an initial number of copies
    INSERT INTO Books (Title, Author, AvailableCopies)
    VALUES (title, author, initial_copies);

    result := 'Book added successfully';
END AddBook;











-- -- Procedures and Functions for Library Management System

-- -- Borrow Book Procedure
-- CREATE PROCEDURE BorrowBook (
--     IN book_id INT,
--     IN member_id INT,
--     OUT result VARCHAR(255)
-- )
-- BEGIN
--     DECLARE available_copies INT;
--     DECLARE book_not_available CONDITION FOR SQLSTATE '45000';

--     -- Check if the book is available
--     SELECT AvailableCopies INTO available_copies
--     FROM Books
--     WHERE BookID = book_id;

--     IF available_copies <= 0 THEN
--         SIGNAL book_not_available SET MESSAGE_TEXT = 'Book is not available';
--     ELSE
--         -- Deduct 1 from AvailableCopies
--         UPDATE Books
--         SET AvailableCopies = AvailableCopies - 1
--         WHERE BookID = book_id;

--         -- Insert a new row into BorrowRecords
--         INSERT INTO BorrowRecords (BookID, MemberID, BorrowDate)
--         VALUES (book_id, member_id, NOW());

--         SET result = 'Book borrowed successfully';
--     END IF;
-- END;

-- -- Return Book Procedure
-- CREATE PROCEDURE ReturnBook (
--     IN book_id INT,
--     IN member_id INT,
--     OUT result VARCHAR(255)
-- )
-- BEGIN
--     DECLARE borrow_date DATE;
--     DECLARE return_date DATE;
--     DECLARE fine_amount DECIMAL(10, 2);
--     DECLARE days_late INT;

--     -- Update the ReturnDate in BorrowRecords
--     UPDATE BorrowRecords
--     SET ReturnDate = NOW()
--     WHERE BookID = book_id AND MemberID = member_id AND ReturnDate IS NULL;

--     -- Increase the AvailableCopies count for the returned book
--     UPDATE Books
--     SET AvailableCopies = AvailableCopies + 1
--     WHERE BookID = book_id;

--     -- Check if the return is late and log a fine if applicable
--     SELECT BorrowDate INTO borrow_date
--     FROM BorrowRecords
--     WHERE BookID = book_id AND MemberID = member_id AND ReturnDate = NOW();

--     SET days_late = DATEDIFF(NOW(), borrow_date) - 14; -- Assuming a 2-week borrowing period

--     IF days_late > 0 THEN
--         SET fine_amount = days_late * 1.00; -- Assuming a fine of $1 per day late
--         INSERT INTO Fines (MemberID, BookID, FineAmount, FineDate)
--         VALUES (member_id, book_id, fine_amount, NOW());
--         SET result = CONCAT('Book returned successfully. Fine amount: $', fine_amount);
--     ELSE
--         SET result = 'Book returned successfully. No fine.';
--     END IF;
-- END;

-- -- Add Book Procedure
-- CREATE PROCEDURE AddBook (
--     IN title VARCHAR(255),
--     IN author VARCHAR(255),
--     IN initial_copies INT,
--     OUT result VARCHAR(255)
-- )
-- BEGIN
--     -- Insert a new book into the Books table with an initial number of copies
--     INSERT INTO Books (Title, Author, AvailableCopies)
--     VALUES (title, author, initial_copies);

--     SET result = 'Book added successfully';
-- END;