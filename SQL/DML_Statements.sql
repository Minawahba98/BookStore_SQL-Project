-- Insert data into Branch table
INSERT INTO Branch (branch_id, manager_id, branch_address, contact_no)
VALUES 
('BR001', 'MGR001', '123 Main Street, NY', '1234567890'),
('BR002', 'MGR002', '456 Elm Street, CA', '9876543210');

-- Insert data into Employees table
INSERT INTO employees (emp_id, emp_name, position, salary, branch_id)
VALUES 
('EMP001', 'Alice Johnson', 'Manager', 75000, 'BR001'),
('EMP002', 'Bob Smith', 'Clerk', 40000, 'BR001'),
('EMP003', 'Charlie Davis', 'Manager', 80000, 'BR002'),
('EMP004', 'Dana Lee', 'Clerk', 42000, 'BR002');

-- Insert data into Books table
INSERT INTO books (isbn, book_title, category, rental_price)
VALUES
('978-3-16-148410-0', 'The Great Gatsby', 'Fiction', 9.99),
('978-1-86197-876-9', 'Sapiens', 'Non-Fiction', 14.99),
('978-0-7432-7356-5', 'The Da Vinci Code', 'Mystery', 12.99);

-- Update employee salary based on performance
UPDATE employees
SET salary = salary + 5000
WHERE position = 'Manager';

-- Delete outdated book categories
DELETE FROM books
WHERE category = 'Outdated';

-- Retrieve employee details along with their branch information
SELECT 
    e.emp_id, e.emp_name, e.position, e.salary, b.branch_address, b.contact_no
FROM 
    employees e
JOIN 
    Branch b ON e.branch_id = b.branch_id;

-- Calculate total sales per branch
SELECT branch_id, SUM(total_amount) AS total_sales
FROM transactions
GROUP BY branch_id;

-- Average salary per position
SELECT position, AVG(salary) AS average_salary
FROM employees
GROUP BY position;

-- Maximum and minimum book rental price
SELECT 
    MAX(rental_price) AS max_price, 
    MIN(rental_price) AS min_price
FROM books;

-- Count the number of employees in each branch
SELECT branch_id, COUNT(emp_id) AS employee_count
FROM employees
GROUP BY branch_id;

-- Total number of books in each category
SELECT category, COUNT(isbn) AS book_count
FROM books
GROUP BY category;

-- Find branches with more than 2 employees
SELECT branch_id, COUNT(emp_id) AS employee_count
FROM employees
GROUP BY branch_id
HAVING COUNT(emp_id) > 2;

-- Find books that belong to categories with more than 5 books
SELECT 
    b.category, b.book_title
FROM 
    books b
JOIN 
    (
        SELECT category
        FROM books
        GROUP BY category
        HAVING COUNT(isbn) > 5
    ) AS popular_categories ON b.category = popular_categories.category;

-- Total transactions grouped by employee who facilitated the sale
SELECT 
    e.emp_name, COUNT(t.transaction_id) AS total_transactions, SUM(t.total_amount) AS total_sales
FROM 
    employees e
JOIN 
    transactions t ON e.emp_id = t.employee_id
GROUP BY 
    e.emp_name;

-- Find the branch with the highest number of employees
SELECT branch_id
FROM employees
GROUP BY branch_id
ORDER BY COUNT(emp_id) DESC
LIMIT 1;

-- Employee and their branch details with no transactions (LEFT JOIN example)
SELECT 
    e.emp_name, b.branch_address, t.transaction_id
FROM 
    employees e
LEFT JOIN 
    Branch b ON e.branch_id = b.branch_id
LEFT JOIN 
    transactions t ON e.emp_id = t.employee_id
WHERE 
    t.transaction_id IS NULL;

-- Find employees and their manager's branch information
SELECT 
    e.emp_id, e.emp_name, e.position, b.manager_id, b.branch_address
FROM 
    employees e
JOIN 
    Branch b ON e.branch_id = b.branch_id;

-- Total salary expenditure across all branches
SELECT SUM(salary) AS total_salary
FROM employees;

-- Average rental price of all books
SELECT AVG(rental_price) AS average_price
FROM books;


--Find the most popular book:
SELECT issued_book_name, COUNT(*) AS times_issued
FROM issued_status
GROUP BY issued_book_name
ORDER BY times_issued DESC
LIMIT 1;


--Calculate total revenue by category:
SELECT category, SUM(rental_price) AS total_revenue
FROM books b
JOIN issued_status i ON b.isbn = i.issued_book_isbn
GROUP BY category
ORDER BY total_revenue DESC;


--Find members with overdue books:
SELECT i.issued_member_id, m.member_name, i.issued_date, r.return_date, 
       (r.return_date - i.issued_date) AS overdue_days
FROM issued_status i
JOIN return_status r ON i.issued_id = r.issued_id
JOIN members m ON i.issued_member_id = m.member_id
WHERE (r.return_date - i.issued_date) > 14;
