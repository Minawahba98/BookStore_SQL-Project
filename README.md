
# Management System Data Analysis
![Description of Image](Images/photo-1518373714866-3f1478910cc0.jpg)


## 1. Overview

This project focuses on creating a structured library management system, consisting of six interrelated tables to manage branches, employees, books, members, issued books, and returned books. The database schema ensures consistency and data integrity while providing insights through data analysis. Below is a summary of the database structure and relationships:

### Schema Overview

The database schema consists of six main tables, each with specific roles in the management system:

1. **Branch Table:** Stores information about branches, including their ID, manager, address, and contact number.
2. **Employees Table:** Tracks employee details and associates them with branches via the `branch_id` foreign key.
3. **Books Table:** Holds book-related details such as title, category, rental price, and author.
4. **Members Table:** Manages member details, including their registration date and address.
5. **Issued_Status Table:** Tracks books issued to members, linking `Books`, `Members`, and the employee handling the transaction.
6. **Return_Status Table:** Records returned books, linking them to the `Issued_Status` table.

### Relationships:
- The `Employees` table is connected to the `Branch` table through the `branch_id` foreign key.
- The `Issued_Status` table links:
  - `Books` via `issued_book_isbn`.
  - `Members` via `issued_member_id`.
  - Employees via `issued_emp_id`.
- The `Return_Status` table depends on `Issued_Status` for identifying the issued transaction.

---

## 2. Database Setup

### Prerequisites
Ensure you have the following setup before running the SQL queries:
- A relational database system (e.g., MySQL, PostgreSQL, etc.)
- A client tool like MySQL Workbench, pgAdmin, or a command-line interface.

### Database and Table Creation
Run the following SQL commands to set up the database and its tables:

#### Branch Table
```sql
DROP TABLE IF EXISTS Branch;
CREATE TABLE Branch (
    branch_id VARCHAR(15) PRIMARY KEY,
    manager_id VARCHAR(15),
    branch_address VARCHAR(55),
    contact_no VARCHAR(15)
);
```

#### Employees Table
```sql
CREATE TABLE Employees (
    emp_id VARCHAR(25) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(25),
    salary INT,
    branch_id VARCHAR(25)
);
```

#### Books Table
```sql
CREATE TABLE Books (
    isbn VARCHAR(25),
    book_title VARCHAR(75),
    category VARCHAR(10),
    rental_price FLOAT,
    status VARCHAR(20),
    author VARCHAR(37),
    publisher VARCHAR(55)
);
```

#### Members Table
```sql
CREATE TABLE Members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(55),
    member_address VARCHAR(55),
    reg_date DATE
);
```

#### Issued Status Table
```sql
CREATE TABLE Issued_Status (
    issued_id VARCHAR(75) PRIMARY KEY,
    issued_member_id VARCHAR(75),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(75),
    issued_emp_id VARCHAR(75)
);
```

#### Return Status Table
```sql
CREATE TABLE Return_Status (
    return_id VARCHAR(75),
    issued_id VARCHAR(75),
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_isbn VARCHAR(75)
);
```

#### Foreign Key Constraints
```sql
ALTER TABLE Issued_Status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES Members(member_id);
```

---

## 3. Data Cleaning and Validation

### Identifying Duplicate Members
```sql
SELECT member_id, COUNT(*)
FROM Members
GROUP BY member_id
HAVING COUNT(*) > 1;
```
Action: Investigate and remove duplicate entries.

### Handling Null Values
```sql
SELECT *
FROM Members
WHERE member_id IS NULL 
   OR member_name IS NULL 
   OR member_address IS NULL 
   OR reg_date IS NULL;
```
Action: Update records with valid data or remove them if irreparable.

### Validating Issued_Status Consistency
```sql
SELECT *
FROM Issued_Status i
LEFT JOIN Books b ON i.issued_book_isbn = b.isbn
WHERE b.isbn IS NULL;
```
Action: Identify and update invalid book references in `Issued_Status`.

### Validating Return_Status Consistency
```sql
SELECT *
FROM Return_Status r
LEFT JOIN Issued_Status i ON r.issued_id = i.issued_id
WHERE i.issued_id IS NULL;
```
Action: Correct invalid `issued_id` values in `Return_Status`.

### Updating Invalid References
```sql
UPDATE Return_Status
SET issued_id = 'VALID_ISSUED_ID'
WHERE issued_id = 'INVALID_ISSUED_ID';
```

---

## 4. Data Analysis & Insights

### Most Popular Book
```sql
SELECT issued_book_name, COUNT(*) AS times_issued
FROM Issued_Status
GROUP BY issued_book_name
ORDER BY times_issued DESC
LIMIT 1;
```
**Insight:** Displays the most frequently issued book.

### Total Revenue by Category
```sql
SELECT category, SUM(rental_price) AS total_revenue
FROM Books b
JOIN Issued_Status i ON b.isbn = i.issued_book_isbn
GROUP BY category
ORDER BY total_revenue DESC;
```
**Insight:** Identifies the most profitable book categories.

### Members with Overdue Books
```sql
SELECT i.issued_member_id, m.member_name, i.issued_date, r.return_date, 
       (r.return_date - i.issued_date) AS overdue_days
FROM Issued_Status i
JOIN Return_Status r ON i.issued_id = r.issued_id
JOIN Members m ON i.issued_member_id = m.member_id
WHERE (r.return_date - i.issued_date) > 14;
```
**Insight:** Lists members who returned books after the due date.

---

## 5. Future Improvements
1. Add additional constraints (e.g., NOT NULL) to critical columns to improve data integrity.
2. Normalize the database further by breaking down repeating fields into separate tables.
3. Implement triggers for automatic updates on related tables.

---

## 6. Diagram Overview

The schema diagram below visually represents the relationships between the tables in the database:

- **Branch Table**: Associated with `Employees` through `branch_id`.
- **Employees Table**: Tracks employees and links them to branches.
- **Books Table**: Central repository for all book-related data.
- **Members Table**: Stores information about library members.
- **Issued_Status Table**: Tracks book issuance and is linked to `Members`, `Books`, and `Employees`.
- **Return_Status Table**: Logs book returns and links to the `Issued_Status` table for tracking purposes.

The diagram provides a clear view of how the tables are interconnected, ensuring consistency and data integrity across the system.

---

## 7. Conclusion
This management system provides a structured approach for managing branches, employees, books, members, and transactions. The analysis yields insights such as popular books, overdue records, and total revenue by category, helping optimize operations and decision-making.
=======
# BookStore_SQL-Project
This project demonstrates SQL skills through database creation, data management, and analysis. It includes scripts to manage branches, employees, books, and transactions, showcasing real-world applications of SQL. Perfect for learning and portfolio building.
>>>>>>> fcdd7735bebe85b8bf535633e93a45b131204b32
