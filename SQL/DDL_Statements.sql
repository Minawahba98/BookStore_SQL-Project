Drop Table If exists Branch ;
create Table Branch 
( 
	branch_id varchar(15) Primary Key , 
	manager_id	varchar(15),
	branch_address	varchar(55),
	contact_no varchar(15) 
) ;

--- Employees Create
create Table employees (
emp_id Varchar(25) Primary Key , 
emp_name Varchar(25),
position Varchar(25),
salary	int,
branch_id Varchar(25),
) ;

-- Books table
create Table books(
isbn Varchar(25),
book_title Varchar(75),
category Varchar(10),
rental_price Float, 
status Varchar(20),
author Varchar(37),
publisher Varchar(55)
)


-- members
create table members (
member_id Varchar(10) Primary Key,	
member_name Varchar(55),
member_address	Varchar(55),
reg_date Date

)

--issued_table

Create Table issued_status (
	issued_id	Varchar(75) Primary key,
	issued_member_id Varchar(75)	,
	issued_book_name Varchar(75) ,
	issued_date Date ,
	issued_book_isbn varchar(75) ,
	issued_emp_id Varchar(75)
)


-- Return 
create Table retue_status (
return_id Varchar(75),
issued_id Varchar(75)	,
return_book_name Varchar(75),
return_date	Date ,
return_book_isbn Varchar(75)

)
--Forgin Key
alter Table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id)

--1. Check for duplicate members

SELECT member_id, COUNT(*) 
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;

-- Handle Null 
SELECT *
FROM members
WHERE member_id IS NULL 
   OR member_name IS NULL 
   OR member_address IS NULL 
   OR reg_date IS NULL;

--
--Validate issued_status consistency:

SELECT *
FROM issued_status i
LEFT JOIN books b ON i.issued_book_isbn = b.isbn
WHERE b.isbn IS NULL;

-- Validate return_status consistency:

SELECT *
FROM return_status r
LEFT JOIN issued_status i ON r.issued_id = i.issued_id
WHERE i.issued_id IS NULL;



UPDATE return_status
SET issued_id = 'VALID_ISSUED_ID'
WHERE issued_id = 'INVALID_ISSUED_ID';

