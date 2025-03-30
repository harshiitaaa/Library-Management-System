CREATE TABLE fines (
    fine_id INT PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    fine_type_id INT,
    amount DECIMAL(8,2),
    due_date DATE,
    status VARCHAR(50)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    fine_id INT REFERENCES fines(fine_id),
    amount_paid DECIMAL(8,2),
    payment_date DATE,
    payment_method VARCHAR(50)
);

CREATE TABLE fine_types (
    fine_type_id INT PRIMARY KEY,
    description VARCHAR(255),
    amount DECIMAL(8,2)
);

CREATE TABLE overdue_books (
    overdue_id INT PRIMARY KEY,
    book_id INT REFERENCES books(book_id),
    member_id INT REFERENCES members(member_id),
    days_late INT,
    fine_id INT REFERENCES fines(fine_id)
);
