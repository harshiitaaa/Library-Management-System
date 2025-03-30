import random
import faker
from datetime import datetime, timedelta

fake = faker.Faker()

# Membership Types Data
membership_types = [
    (1, 'Basic', 5, 9.99),
    (2, 'Premium', 10, 19.99),
    (3, 'Elite', 15, 29.99)
]

# Generate Members Data
members = []
for i in range(1, 1251):
    member_id = i
    name = fake.name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=80).strftime('%Y-%m-%d')
    membership_type_id = random.choice([1, 2, 3])
    join_date = fake.date_between(start_date='-5y', end_date='today').strftime('%Y-%m-%d')
    status = random.choice(['Active', 'Inactive'])
    members.append((member_id, name, dob, membership_type_id, join_date, status))

# Generate Borrow History Data
borrow_history = []
for i in range(1, 3000):  # More than members to reflect multiple borrows
    borrow_id = i
    member_id = random.randint(1, 1250)
    book_id = random.randint(1, 1500)
    borrow_date = fake.date_between(start_date='-5y', end_date='today')
    return_date = borrow_date + timedelta(days=random.randint(7, 30)) if random.random() > 0.2 else None
    status = 'Returned' if return_date else 'Borrowed'
    return_date = return_date.strftime('%Y-%m-%d') if return_date else None
    borrow_history.append((borrow_id, member_id, book_id, borrow_date.strftime('%Y-%m-%d'), return_date, status))

# Generate Contact Details Data
contact_details = []
for i in range(1, 1251):
    contact_id = i
    member_id = i
    email = fake.email()
    phone_number = fake.phone_number()
    address = fake.address().replace('\n', ', ')
    contact_details.append((contact_id, member_id, email, phone_number, address))

# # Print SQL Insert Statements
# with open("members_data.sql", "w") as f:
#     f.write("INSERT INTO membership_types (membership_type_id, type_name, max_books_allowed, monthly_fee) VALUES\n")
#     f.write(",\n".join([f"({m[0]}, '{m[1]}', {m[2]}, {m[3]})" for m in membership_types]) + ";\n\n")
    
#     f.write("INSERT INTO members (member_id, name, dob, membership_type_id, join_date, status) VALUES\n")
#     f.write(",\n".join([f"({m[0]}, '{m[1]}', '{m[2]}', {m[3]}, '{m[4]}', '{m[5]}')" for m in members]) + ";\n\n")
    
#     f.write("INSERT INTO borrow_history (borrow_id, member_id, book_id, borrow_date, return_date, status) VALUES\n")
#     f.write(",\n".join([f"({b[0]}, {b[1]}, {b[2]}, '{b[3]}', " + ("NULL" if b[4] is None else f"'{b[4]}'") + f", '{b[5]}')" for b in borrow_history]) + ";\n")
    
#     f.write("INSERT INTO contact_details (contact_id, member_id, email, phone_number, address) VALUES\n")
#     f.write(",\n".join([f"({c[0]}, {c[1]}, '{c[2]}', '{c[3]}', '{c[4]}')" for c in contact_details]) + ";\n\n")

with open("members_data.sql", "w") as f:
    for m in membership_types:
        f.write(f"INSERT INTO membership_types (membership_type_id, type_name, max_books_allowed, monthly_fee) VALUES ({m[0]}, '{m[1]}', {m[2]}, {m[3]});\n")
    
    for m in members:
        f.write(f"INSERT INTO members (member_id, name, dob, membership_type_id, join_date, status) VALUES ({m[0]}, '{m[1]}', '{m[2]}', {m[3]}, '{m[4]}', '{m[5]}');\n")
    
    for b in borrow_history:
        return_date = 'NULL' if b[4] is None else f"'{b[4]}'"
        f.write(f"INSERT INTO borrow_history (borrow_id, member_id, book_id, borrow_date, return_date, status) VALUES ({b[0]}, {b[1]}, {b[2]}, '{b[3]}', {return_date}, '{b[5]}');\n")
    
    for c in contact_details:
        f.write(f"INSERT INTO contact_details (contact_id, member_id, email, phone_number, address) VALUES ({c[0]}, {c[1]}, '{c[2]}', '{c[3]}', '{c[4]}');\n")