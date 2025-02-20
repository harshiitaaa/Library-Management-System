import random
from faker import Faker
import datetime

fake = Faker()

# Define the genres
genres = [
    "Fiction", "Non-Fiction", "Fantasy", "Romance", "Mystery",
    "Horror", "Science Fiction", "History", "Crime", "Comedy"
]

# Generate SQL for the Genre table
def generate_genres():
    sql = "INSERT INTO Genre (GenreID, GenreName) VALUES\n"
    sql += ",\n".join([f"({i + 1}, '{genre}')" for i, genre in enumerate(genres)])
    sql += ";"
    return sql

# Generate SQL for the Books table
def generate_books(num_books):
    sql = "INSERT INTO Books (BookID, Title, Author, ISBN, PublishedYear, GenreID, AvailableCopies) VALUES\n"
    books = []
    for book_id in range(1, num_books + 1):
        title = fake.sentence(nb_words=5).replace("'", "''")  # Escape single quotes
        author = fake.name().replace("'", "''")
        isbn = fake.isbn13()
        year = random.randint(1900, 2023)
        genre_id = random.randint(1, 10)
        copies = random.randint(1, 10)
        books.append(f"({book_id}, '{title}', '{author}', '{isbn}', {year}, {genre_id}, {copies})")
    sql += ",\n".join(books)
    sql += ";"
    return sql

# Generate SQL for the Members table
def generate_members(num_members):
    sql = "INSERT INTO Members (MemberID, FirstName, LastName, Email, PhoneNumber, MembershipDate) VALUES\n"
    members = []
    for member_id in range(1, num_members + 1):
        first_name = fake.first_name().replace("'", "''")
        last_name = fake.last_name().replace("'", "''")
        email = fake.email().replace("'", "''")
        phone = fake.phone_number()
        membership_date = fake.date_between(start_date='-10y', end_date='today')
        members.append(f"({member_id}, '{first_name}', '{last_name}', '{email}', '{phone}', '{membership_date}')")
    sql += ",\n".join(members)
    sql += ";"
    return sql

# Generate SQL for the BorrowRecords table
def generate_borrow_records(num_records, num_books, num_members):
    sql = "INSERT INTO BorrowRecords (LoanID, BookID, MemberID, LoanDate, ReturnDate) VALUES\n"
    records = []
    for loan_id in range(1, num_records + 1):
        book_id = random.randint(1, num_books)
        member_id = random.randint(1, num_members)
        loan_date = fake.date_between(start_date='-5y', end_date='today')
        # Some books might not be returned yet
        return_date = loan_date + datetime.timedelta(days=random.randint(1, 30)) if random.random() < 0.8 else "NULL"
        return_date = f"'{return_date}'" if return_date != "NULL" else "NULL"
        records.append(f"({loan_id}, {book_id}, {member_id}, '{loan_date}', {return_date})")
    sql += ",\n".join(records)
    sql += ";"
    return sql

# Generate the data
num_books = 5000
num_members = 500
num_borrow_records = 15000

# Write to a file
with open("fake_data.sql", "w", encoding="utf-8") as file:
    file.write("-- Genre Table\n")
    file.write(generate_genres())
    file.write("\n\n-- Books Table\n")
    file.write(generate_books(num_books))
    file.write("\n\n-- Members Table\n")
    file.write(generate_members(num_members))
    file.write("\n\n-- BorrowRecords Table\n")
    file.write(generate_borrow_records(num_borrow_records, num_books, num_members))

print("SQL file with fake data generated: fake_data.sql")