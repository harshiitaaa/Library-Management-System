ALTER TABLE authors DROP CONSTRAINT SYS_C0040706;
CREATE TABLE authors (
    author_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255),
    birth_year NUMBER,
    nationality VARCHAR2(100)
);
CREATE TABLE genres (
    genre_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) UNIQUE
);

CREATE TABLE books (
    book_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    title VARCHAR2(255),
    author_id NUMBER,
    genre_id NUMBER,
    isbn VARCHAR2(20) UNIQUE,
    publication_year NUMBER,
    available_copies NUMBER,
    CONSTRAINT fk_books_authors FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE SET NULL,
    CONSTRAINT fk_books_genres FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE SET NULL
);

CREATE TABLE book_loans (
    loan_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    book_id NUMBER,
    member_id NUMBER,
    loan_date DATE DEFAULT SYSDATE,
    return_date DATE,
    status VARCHAR2(50) CHECK (status IN ('borrowed', 'returned', 'overdue')),
    CONSTRAINT fk_loans_books FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);
