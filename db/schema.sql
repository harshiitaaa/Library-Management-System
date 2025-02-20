CREATE TABLE Genre ( --weak entity 
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL 
);

CREATE SEQUENCE GenreSeq START WITH 1 INCREMENT BY 1;

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) UNIQUE NOT NULL,
    PublishedYear INT,
    GenreID INT, -- Foreign key to Genre table
    AvailableCopies INT NOT NULL DEFAULT 1,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

CREATE SEQUENCE BooksSeq START WITH 1 INCREMENT BY 1;

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    MembershipDate DATE NOT NULL
);

CREATE SEQUENCE MembersSeq START WITH 1 INCREMENT BY 1;

CREATE TABLE BorrowRecords (
    LoanID INT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE SEQUENCE BorrowRecordsSeq START WITH 1 INCREMENT BY 1;








-- CREATE TABLE Genre ( --weak entity 
--     GenreID INT PRIMARY KEY AUTO_INCREMENT ,
--     GenreName VARCHAR(100) NOT NULL 
-- );

-- CREATE TABLE Books (
--     BookID INT PRIMARY KEY AUTO_INCREMENT,
--     Title VARCHAR(255) NOT NULL,
--     Author VARCHAR(255) NOT NULL,
--     ISBN VARCHAR(13) UNIQUE NOT NULL,
--     PublishedYear INT,
--     GenreID INT, -- Foreign key to Genre table
--     AvailableCopies INT NOT NULL DEFAULT 1,
--     FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
-- );

-- CREATE TABLE Members (
--     MemberID INT PRIMARY KEY AUTO_INCREMENT,
--     FirstName VARCHAR(100) NOT NULL,
--     LastName VARCHAR(100) NOT NULL,
--     Email VARCHAR(255) UNIQUE NOT NULL,
--     PhoneNumber VARCHAR(15),
--     MembershipDate DATE NOT NULL
-- );

-- CREATE TABLE BorrowRecords (
--     LoanID INT PRIMARY KEY AUTO_INCREMENT,
--     BookID INT NOT NULL,
--     MemberID INT NOT NULL,
--     LoanDate DATE NOT NULL,
--     ReturnDate DATE,
--     FOREIGN KEY (BookID) REFERENCES Books(BookID),
--     FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
-- );
