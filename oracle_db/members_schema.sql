CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255),
    dob DATE,
    membership_type_id INT,
    join_date DATE,
    status VARCHAR(50)
);

CREATE TABLE membership_types (
    membership_type_id INT PRIMARY KEY,
    type_name VARCHAR(100),
    max_books_allowed INT,
    monthly_fee DECIMAL(8,2)
);

CREATE TABLE borrow_history (
    borrow_id INT PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    status VARCHAR(50)
);

CREATE TABLE contact_details (
    contact_id INT PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    email VARCHAR(255),
    phone_number VARCHAR(15),
    address TEXT
);
