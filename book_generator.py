import random
from faker import Faker
import datetime

fake = Faker()

# Define genres
genres = [
    "Fiction", "Non-Fiction", "Fantasy", "Romance", "Mystery",
    "Horror", "Science Fiction", "History", "Crime", "Comedy"
]

def generate_genres():
    sql = "INSERT INTO genres (genre_id, name) VALUES\n"
    sql += ",\n".join([f"({i + 1}, '{genre}')" for i, genre in enumerate(genres)])
    sql += ";"
    return sql

def generate_authors(num_authors):
    sql = "INSERT INTO authors (author_id, name, birth_year, nationality) VALUES\n"
    authors = []
    for author_id in range(1, num_authors + 1):
        name = fake.name().replace("'", "''")
        birth_year = random.randint(1900, 2000)
        nationality = fake.country().replace("'", "''")
        authors.append(f"({author_id}, '{name}', {birth_year}, '{nationality}')")
    sql += ",\n".join(authors)
    sql += ";"
    return sql

def generate_books(num_books, num_authors):
    sql = "INSERT INTO books (book_id, title, author_id, genre_id, isbn, publication_year, available_copies) VALUES\n"
    books = []
    for book_id in range(1, num_books + 1):
        title = fake.sentence(nb_words=4).replace("'", "''")
        author_id = random.randint(1, num_authors)
        genre_id = random.randint(1, len(genres))
        isbn = fake.isbn13()
        publication_year = random.randint(1900, 2023)
        available_copies = random.randint(1, 10)
        books.append(f"({book_id}, '{title}', {author_id}, {genre_id}, '{isbn}', {publication_year}, {available_copies})")
    sql += ",\n".join(books)
    sql += ";"
    return sql

def generate_book_loans(num_loans, num_books, num_members):
    sql = "INSERT INTO book_loans (loan_id, book_id, member_id, loan_date, return_date, status) VALUES\n"
    loans = []
    for loan_id in range(1, num_loans + 1):
        book_id = random.randint(1, num_books)
        member_id = random.randint(1, num_members)
        loan_date = fake.date_between(start_date='-5y', end_date='today')
        return_date = loan_date + datetime.timedelta(days=random.randint(1, 30)) if random.random() < 0.8 else "NULL"
        return_date = f"'{return_date}'" if return_date != "NULL" else "NULL"
        status = "Returned" if return_date != "NULL" else "Borrowed"
        loans.append(f"({loan_id}, {book_id}, {member_id}, '{loan_date}', {return_date}, '{status}')")
    sql += ",\n".join(loans)
    sql += ";"
    return sql

# Generate the data
num_authors = 5000
num_books = 500000
num_members = 500
num_loans = 15000

# Write to a file
with open("books_data.sql", "w", encoding="utf-8") as file:
    file.write("-- Genres Table\n")
    file.write(generate_genres())
    file.write("\n\n-- Authors Table\n")
    file.write(generate_authors(num_authors))
    file.write("\n\n-- Books Table\n")
    file.write(generate_books(num_books, num_authors))
    file.write("\n\n-- Book Loans Table\n")
    file.write(generate_book_loans(num_loans, num_books, num_members))

print("SQL file with fake data generated: books_data.sql")
