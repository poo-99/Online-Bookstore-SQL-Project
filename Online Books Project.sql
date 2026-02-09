-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM '‪C:/All Excel Practice Files/Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:/All Excel Practice Files/Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:/All Excel Practice Files/Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
Select * from books
where genre='Fiction';

-- 2) Find books published after the year 1950:
Select * from books
where published_year > 1950;

-- 3) List all customers from the Canada:
Select * from customers
where country='Canada';

-- 4) Show orders placed in November 2023:
Select * from orders
where order_date Between '2023-11-01' And '2023-11-30;'

-- 5) Retrieve the total stock of books available:
Select SUM(stock) As Total_Stock
From Books;

-- 6) Find the details of the most expensive book:
select * from Books
Order By Price Desc 
Limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders
where quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * from Orders
where total_amount>20;

-- 9) List all genres available in the Books table:
Select Distinct genre from Books;

-- 10) Find the book with the lowest stock:
Select * from books 
order by stock 
Limit 1;

-- 11) Calculate the total revenue generated from all orders:
Select SUM(total_amount) as Revenue
From orders;






-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select * from orders;

Select b.genre,SUM(o.quantity) As Total_Books_Sold
From Orders o
Join Books b On o.book_id=b.book_id
Group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
Select AVG(price) As Average_price
From Books
Where genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
Select o.customer_id,c.name,Count(o.order_id) As Order_count
from orders o
Join customers c on o.customer_id=c.customer_id
Group By o.customer_id ,c.name
having count(order_id) >= 2;

-- 4) Find the most frequently ordered book:
select o.book_id,b.title,Count(o.order_id) As Order_count
from orders o
Join Books b On o.book_id=b.book_id
Group By o.book_id,b.title
order by order_count Desc Limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where genre='Fantasy'
order by price desc 
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select b.author,SUM(o.quantity) As Total_Books_Sold
from Orders o
Join books b on o.book_id=b.book_id
Group by b.Author;


-- 7) List the cities where customers who spent over $30 are located:
select Distinct c.city ,total_amount
from orders o
Join customers c On o.customer_id=c.customer_id
where o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
select c.customer_id,c.name,Sum(o.total_amount) As Total_Spent
From orders o
Join customers c On o.customer_id=c.customer_id
Group By c.customer_id,c.name
order By Total_spent desc Limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
select b.book_id,b.title,b.stock,Coalesce(Sum(quantity),0) As Order_quantity,
    b.stock- Coalesce(Sum(o.quantity),0) As Remaining_quantity
From books b
Left join orders o On b.book_id=o.book_id
Group By b.book_id order by b.book_id;







