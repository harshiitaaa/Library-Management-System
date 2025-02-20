CREATE OR REPLACE PACKAGE Book_Management AS -- PACKAGE SPECIFICATION FOR BOOK MANAGEMENT
    -- Procedures
    PROCEDURE CheckOutBook(p_book_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE ReturnBook(p_book_id IN NUMBER, p_user_id IN NUMBER);
    PROCEDURE AddNewBook(p_title IN VARCHAR2, p_author IN VARCHAR2, p_genre IN NUMBER, p_year_published IN NUMBER, p_copies IN NUMBER);

    -- Functions
    FUNCTION GetAvailableCopies(p_book_id IN NUMBER) RETURN NUMBER;
    FUNCTION SearchBookByTitle(p_title IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION SearchBookByAuthor(p_author IN VARCHAR2) RETURN SYS_REFCURSOR;

    -- Cursors
    CURSOR BooksByGenre(p_genre IN NUMBER) IS SELECT * FROM Books WHERE GenreID = p_genre;
    CURSOR BooksByYear(p_year_published IN NUMBER) IS SELECT * FROM Books WHERE PublishedYear = p_year_published;
END Book_Management;

CREATE OR REPLACE PACKAGE Member_Management AS -- PACKAGE SPECIFICATION FOR MEMBER MANAGEMENT
    -- Procedures
    PROCEDURE RegisterMember(p_member_id IN NUMBER, p_name IN VARCHAR2, p_address IN VARCHAR2, p_phone IN VARCHAR2);
    PROCEDURE UpdateMemberDetails(p_member_id IN NUMBER, p_name IN VARCHAR2, p_address IN VARCHAR2, p_phone IN VARCHAR2);
    PROCEDURE CheckMembershipValidity(p_member_id IN NUMBER, p_validity OUT VARCHAR2);

    -- Functions
    FUNCTION GetTotalBooksBorrowed(p_member_id IN NUMBER) RETURN NUMBER;
END Member_Management;






/*
BOOK MANAGEMENT PACKAGE BODY
*/

-- Book_Management Package Body
CREATE OR REPLACE PACKAGE BODY Book_Management AS

    -- Procedure to check out a book
    PROCEDURE CheckOutBook(p_book_id IN NUMBER, p_user_id IN NUMBER) IS
        v_available NUMBER;
    BEGIN
        -- Check if book is available
        SELECT AvailableCopies INTO v_available FROM Books WHERE BookID = p_book_id;
        
        IF v_available > 0 THEN
            -- Decrease available copies
            UPDATE Books SET AvailableCopies = AvailableCopies - 1 WHERE BookID = p_book_id;

            -- Insert record in BorrowRecords
            INSERT INTO BorrowRecords (LoanID, BookID, MemberID, LoanDate, ReturnDate)
            VALUES (SEQ_BORROWRECORDS.NEXTVAL, p_book_id, p_user_id, SYSDATE, NULL);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No available copies for this book.');
        END IF;
    END CheckOutBook;

    -- Procedure to return a book
    PROCEDURE ReturnBook(p_book_id IN NUMBER, p_user_id IN NUMBER) IS
    BEGIN
        -- Update the return date in BorrowRecords
        UPDATE BorrowRecords 
        SET ReturnDate = SYSDATE
        WHERE BookID = p_book_id AND MemberID = p_user_id AND ReturnDate IS NULL;

        -- Increase available copies
        UPDATE Books SET AvailableCopies = AvailableCopies + 1 WHERE BookID = p_book_id;
    END ReturnBook;

    -- Procedure to add a new book
    PROCEDURE AddNewBook(p_title IN VARCHAR2, p_author IN VARCHAR2, p_genre IN NUMBER, p_year_published IN NUMBER, p_copies IN NUMBER) IS
    BEGIN
        INSERT INTO Books (BookID, Title, Author, GenreID, PublishedYear, AvailableCopies)
        VALUES (SEQ_BOOKS.NEXTVAL, p_title, p_author, p_genre, p_year_published, p_copies);
    END AddNewBook;

    -- Function to get available copies of a book
    FUNCTION GetAvailableCopies(p_book_id IN NUMBER) RETURN NUMBER IS
        v_copies NUMBER;
    BEGIN
        SELECT AvailableCopies INTO v_copies FROM Books WHERE BookID = p_book_id;
        RETURN v_copies;
    END GetAvailableCopies;

    -- Function to search books by title
    FUNCTION SearchBookByTitle(p_title IN VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT * FROM Books WHERE LOWER(Title) LIKE '%' || LOWER(p_title) || '%';
        RETURN v_cursor;
    END SearchBookByTitle;

    -- Function to search books by author
    FUNCTION SearchBookByAuthor(p_author IN VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT * FROM Books WHERE LOWER(Author) LIKE '%' || LOWER(p_author) || '%';
        RETURN v_cursor;
    END SearchBookByAuthor;

END Book_Management;





/*
Member Management Package Body
*/
-- Member_Management Package Body
CREATE OR REPLACE PACKAGE BODY Member_Management AS

    -- Procedure to register a new member
    PROCEDURE RegisterMember(p_member_id IN NUMBER, p_name IN VARCHAR2, p_address IN VARCHAR2, p_phone IN VARCHAR2) IS
    BEGIN
        INSERT INTO Members (MemberID, FirstName, LastName, Email, PhoneNumber, MembershipDate)
        VALUES (p_member_id, p_name, '', '', p_phone, SYSDATE);
    END RegisterMember;

    -- Procedure to update member details
    PROCEDURE UpdateMemberDetails(p_member_id IN NUMBER, p_name IN VARCHAR2, p_address IN VARCHAR2, p_phone IN VARCHAR2) IS
    BEGIN
        UPDATE Members
        SET FirstName = p_name, PhoneNumber = p_phone
        WHERE MemberID = p_member_id;
    END UpdateMemberDetails;

    -- Procedure to check membership validity
    PROCEDURE CheckMembershipValidity(p_member_id IN NUMBER, p_validity OUT VARCHAR2) IS
        v_member_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_member_count FROM Members WHERE MemberID = p_member_id;
        
        IF v_member_count > 0 THEN
            p_validity := 'Valid';
        ELSE
            p_validity := 'Invalid';
        END IF;
    END CheckMembershipValidity;

    -- Function to get the total number of books borrowed by a member
    FUNCTION GetTotalBooksBorrowed(p_member_id IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM BorrowRecords WHERE MemberID = p_member_id;
        RETURN v_total;
    END GetTotalBooksBorrowed;

END Member_Management;
