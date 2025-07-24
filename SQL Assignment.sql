## 1.Create a table called employees with the following structure.
create database PW_Assignments;
use PW_Assignments;
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL(10, 2) DEFAULT 30000);

## 2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.
## Primary : Uniquely identifies each record. Eg: emp_id INT PRIMARY KEY
## NOT Null : Ensures a field must have a value. Eg: emp_name VARCHAR(255) NOT NULL
## UNIQUE : Prevents duplicate values in a column. Eg: email VARCHAR(255) UNIQUE
## CHECK: Limits the values that can be entered.Eg:  age INT CHECK (age >= 18)
## DEFAULT : Automatically assigns a value if none is provided. Eg : salary DECIMAL DEFAULT 30000
## Foreign : Ensures data in one table matches data in another. Eg: dept_id INT REFERENCES departments(dept_id)

## 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify  your answer.

## The NOT NULL constraint is applied when a column must always have a value. This is crucial for fields that are essential for a record to make sense.
## Examples:
##- An employee name (emp_name) must exist — a nameless employee wouldn't be very helpful.
##- A birthdate or timestamp might be mandatory to track entries.
## Purpose: Prevents missing, incomplete, or blank data in key columns.

## Can a Primary Key Contain NULL Values?
## Absolutely not. A primary key cannot contain NULL values — and here’s why:
##- Uniqueness Required: Every row must have a unique identifier.
##- NULL Is Unknown: NULL represents unknown or missing data. You can't guarantee uniqueness among unknowns.
##- Referential Integrity: If a primary key could be NULL, other tables linking via foreign keys would break down.

## 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

## To add:
## ALTER TABLE employees
## ADD CONSTRAINT chk_salary CHECK (salary >= 10000);

## To remove:
## ALTER TABLE employees
## DROP CONSTRAINT chk_salary;

## 5. . Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint.
 
 ## When a database operation like inserting, updating, or deleting data violates defined constraints, it leads to errors that prevent the action from being completed. Constraints are rules that ensure data integrity and consistency.
 
## - Primary Key Violation
##- Example: Trying to insert a duplicate value into a primary key column.
##- Consequence: The database rejects the new record.
## Error Message Example:
##  ERROR: duplicate key value violates unique constraint "students_pkey"

## - Foreign Key Violation
##- Example: - Example: Trying to insert a value in a child table that doesn’t exist in the referenced parent table.
##- - Consequence: Prevents the action to preserve referential integrity.
## Error Message Example:
##  ERROR: insert or update on table "orders" violates foreign key constraint "orders_customerid_fkey"

## 6.You created a products table without constraints as follows:

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2));

## Now, you realise that: 
-- Add primary key constraint
ALTER TABLE products
ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

-- Add default value to price column
ALTER TABLE products
ALTER COLUMN price SET DEFAULT 50.00;


## 7. Write a query to fetch the student_name and class_name for each student using an INNER JOIN.
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT);

INSERT INTO Students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100));

INSERT INTO Classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

SELECT s.student_name, c.class_name
FROM Students s
INNER JOIN Classes c 
ON s.class_id = c.class_id;

## 8. Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order .


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100));

INSERT INTO Customers (customer_id, customer_name) VALUES
(101, 'Alice'),
(102, 'Bob');

select * from Customers;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

INSERT INTO Orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);

select * from orders;

CREATE TABLE Products1 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id));

INSERT INTO Products1 (product_id, product_name, order_id) VALUES
(1, 'Laptop',1),
(2, 'Phone', null);

SELECT 
    p.order_id, 
    c.customer_name, 
    p.product_name
FROM Products1 p
LEFT JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id;

## 9.  Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.

CREATE TABLE sales (
    sales_id INT primary key,
    product_id int,
    amaount INT);

INSERT INTO sales (sales_id, product_id, amaount) VALUES
(1, 101,500),
(2, 102,300),
(3, 101, 700);

CREATE TABLE Products2 (
    product_id INT primary key,
    product_name VARCHAR(100));
    
insert into products2 (product_id, product_name) values
(101, 'Laptop'),
(102, 'Phone');

SELECT 
    p.product_name, 
    SUM(s.amaount) AS total_sales
FROM Products2 p
INNER JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_name;


##10. Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.

CREATE TABLE Orders1 (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT);

INSERT INTO Orders1 (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

CREATE TABLE Customers1 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50));

INSERT INTO Customers1 (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id));

INSERT INTO Order_Details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Orders1 o
INNER JOIN 
    Customers1 c ON o.customer_id = c.customer_id
INNER JOIN 
    Order_Details od ON o.order_id = od.order_id;





## SQL Commands

use mavenmovies;
## 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
# primary key
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_NAME = 'PRIMARY'
  AND TABLE_SCHEMA = 'mavenmovies';
 
 # Foreign key
 SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME IS NOT NULL
  AND TABLE_SCHEMA = 'mavenmovies';
  
##  A primary key is a column (or a combination of columns) in a table that uniquely identifies each record. It ensures that every row is distinct and cannot contain NULL values. For example, in a movie rental database, each film might be assigned a unique film_id that acts as the primary key—this guarantees no two films have the same identifier.
##In contrast, a foreign key is used to establish a relationship between two tables. It is a column that references the primary key in another table, linking data together. Unlike a primary key, a foreign key does not need to be unique and may contain NULL values depending on the design. For instance, the customer_id in a rentals table could be a foreign key pointing back to the customers table, indicating which customer made a particular rental.
##The fundamental difference lies in their role: primary keys enforce entity integrity, ensuring every record is identifiable; foreign keys enforce referential integrity, maintaining valid relationships between tables. Additionally, changing the values in a primary key can disrupt identity, while changing foreign key values can break links to other tables.

## 2- List all details of actors
SELECT * FROM actor;

## 3 -List all customer information from DB
SELECT * FROM customer;

## 4-List different countries
SELECT DISTINCT country 
FROM country
ORDER BY country;

## 5- Display all active customers.
SELECT * 
FROM customer
WHERE active = 1;

## 6- List of all rental IDs for customer with ID 1.
SELECT rental_id 
FROM rental 
WHERE customer_id = 1;

##7- Display all the films whose rental duration is greater than 5 .
SELECT * 
FROM film 
WHERE rental_duration > 5;

## 8-  List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT * FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

## 9. Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;

## 10. Display the first 10 records from the customer table .
SELECT * 
FROM customer 
ORDER BY customer_id 
LIMIT 10;

## 11. Display the first 3 records from the customer table whose first name starts with ‘b’.
use mavenmovies;

SELECT *
FROM customer
WHERE first_name LIKE 'B%'
LIMIT 3;

## 12. Display the names of the first 5 movies which are rated as ‘G’.
SELECT title
FROM film
WHERE rating = 'G'
LIMIT 5;

## 13. Find all customers whose first name starts with "a".
select * from customer
where first_name like 'a%';

## 14. Find all customers whose first name ends with "a".

select * from customer
where first_name like '%a';

## 15. Display the list of first 4 cities which start and end with ‘a’ .
select * from city
where city LIKE 'A%a'
LIMIT 4;

## 16.  Find all customers whose first name have "NI" in any position.
select * from customer
where first_name like '%ni%';

## 17. Find all customers whose first name have "r" in the second position 
SELECT *
FROM customer
WHERE first_name LIKE '_r%';

## 18.  Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * FROM customer
WHERE first_name LIKE 'A%' 
AND LENGTH(first_name) >= 5;

## 19. Find all customers whose first name starts with "a" and ends with "o".
SELECT * FROM customer
WHERE first_name LIKE 'A%o'
and first_name LIKE '%o';

## 20.  Get the films with pg and pg-13 rating using IN operator.
SELECT * FROM film
WHERE rating IN ('PG', 'PG-13');

## 21. Get the films with length between 50 to 100 using between operator.
SELECT * FROM film
WHERE length BETWEEN 50 AND 100;

## 22. Get the top 50 actors using limit operator.
SELECT * FROM actor
ORDER BY actor_id
LIMIT 50;

## 23. Get the distinct film ids from inventory table.
SELECT DISTINCT film_id
FROM inventory;


## FUNCTIONS

use sakila;

## 1. Retrieve the total number of rentals made in the Sakila database.
SELECT COUNT(*) AS total_rentals
FROM rental;

## 2. Find the average rental duration (in days) of movies rented from the Sakila database.
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration_days
FROM rental
WHERE return_date IS NOT NULL;

## 3. Display the first name and last name of customers in uppercase.
SELECT 
    UPPER(first_name) AS first_name_uppercase,
    UPPER(last_name) AS last_name_uppercase
FROM customer;

## 4. Extract the month from the rental date and display it alongside the rental ID.
SELECT 
    rental_id,
    MONTH(rental_date) AS rental_month
FROM rental;

## 5. Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
SELECT 
    customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
ORDER BY rental_count DESC;

## 6. Find the total revenue generated by each store.
SELECT 
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

## 7. Determine the total number of rentals for each category of movies.
SELECT 
    c.name AS category_name,
    COUNT(*) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_rentals DESC;

## 8. Find the average rental rate of movies in each language.
SELECT 
    l.name AS language_name,
    AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY average_rental_rate DESC;

## 9. Display the title of the movie, customer s first name, and last name who rented it.

SELECT 
    f.title AS movie_title,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY f.title, c.last_name, c.first_name;

## 10. Retrieve the names of all actors who have appeared in the film "Gone with the Wind."

SELECT 
    a.first_name,
    a.last_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Gone with the Wind'
ORDER BY a.last_name, a.first_name;

## 11. Retrieve the customer names along with the total amount they've spent on rentals.

SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN rental r ON p.rental_id = r.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

## 12. List the titles of movies rented by each customer in a particular city (e.g., 'London').

SELECT 
    c.first_name,
    c.last_name,
    ci.city AS customer_city,
    f.title AS movie_title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
ORDER BY c.last_name, c.first_name, f.title;

## 13. Display the top 5 rented movies along with the number of times they've been rented.
use sakila;
SELECT 
    f.title AS movie_title,
    COUNT(r.rental_id) AS times_rented
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    f.title
ORDER BY 
    times_rented DESC
LIMIT 5;

## 14.Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).

SELECT 
    customer_id
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
WHERE 
    i.store_id IN (1, 2)
GROUP BY 
    customer_id
HAVING 
    COUNT(DISTINCT i.store_id) = 2;
    
## Windows Function:

## 1. Rank the customers based on the total amount they've spent on rentals.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    total_spent DESC;
    

## 2.  Calculate the cumulative revenue generated by each film over time.

SELECT 
    f.title AS film_title,
    DATE(p.payment_date) AS revenue_date,
    SUM(p.amount) OVER (
        PARTITION BY f.film_id
        ORDER BY p.payment_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
JOIN 
    payment p ON r.rental_id = p.rental_id
ORDER BY 
    f.title, 
    revenue_date;
    
## 3.  Determine the average rental duration for each film, considering films with similar lengths.

SELECT 
    FLOOR(f.length / 30) * 30 AS length_bucket,
    f.title AS film_title,
    f.length AS film_length,
    AVG(DATE_PART('day', r.return_date - r.rental_date)) AS avg_rental_duration_days
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.return_date IS NOT NULL
GROUP BY 
    length_bucket, f.title, f.length
ORDER BY 
    length_bucket, avg_rental_duration_days DESC;
    
## 4. Identify the top 3 films in each category based on their rental counts.

SELECT * FROM (
    SELECT 
        c.name AS category_name,
        f.title AS film_title,
        COUNT(r.rental_id) AS rental_count,
        RANK() OVER (
            PARTITION BY c.name 
            ORDER BY COUNT(r.rental_id) DESC
        ) AS rank_in_category
    FROM 
        category c
    JOIN 
        film_category fc ON c.category_id = fc.category_id
    JOIN 
        film f ON fc.film_id = f.film_id
    JOIN 
        inventory i ON f.film_id = i.film_id
    JOIN 
        rental r ON i.inventory_id = r.inventory_id
    GROUP BY 
        c.name, f.title
) ranked_films
WHERE 
    rank_in_category <= 3
ORDER BY 
    category_name, rental_count DESC;
    
    
## 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(AVG(COUNT(r.rental_id)) OVER (), 2) AS avg_rentals,
    COUNT(r.rental_id) - ROUND(AVG(COUNT(r.rental_id)) OVER (), 2) AS rental_diff
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    rental_diff DESC;
    
## 6. Find the monthly revenue trend for the entire rental store over time.

SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    ROUND(SUM(amount), 2) AS total_monthly_revenue
FROM 
    payment
GROUP BY 
    month
ORDER BY 
    month;
    
## 7.Identify the customers whose total spending on rentals falls within the top 20% of all customers.

SELECT 
    customer_id,
    first_name,
    last_name,
    total_spent
FROM (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) AS total_spent,
        NTILE(5) OVER (
            ORDER BY SUM(p.amount) DESC
        ) AS spending_percentile
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
) ranked
WHERE 
    spending_percentile = 1
ORDER BY 
    total_spent DESC;
    

## 8.  Calculate the running total of rentals per category, ordered by rental count.

SELECT 
    c.name AS category_name,
    COUNT(r.rental_id) AS rental_count,
    SUM(COUNT(r.rental_id)) OVER (
        ORDER BY COUNT(r.rental_id) DESC
    ) AS running_total
FROM 
    category c
JOIN 
    film_category fc ON c.category_id = fc.category_id
JOIN 
    film f ON fc.film_id = f.film_id
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    c.name
ORDER BY 
    rental_count DESC;
    
##9.  Find the films that have been rented less than the average rental count for their respective categories.

SELECT 
    category_name,
    film_title,
    film_rentals,
    category_avg_rentals
FROM (
    SELECT 
        c.name AS category_name,
        f.title AS film_title,
        COUNT(r.rental_id) AS film_rentals,
        AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.name) AS category_avg_rentals
    FROM 
        category c
    JOIN 
        film_category fc ON c.category_id = fc.category_id
    JOIN 
        film f ON fc.film_id = f.film_id
    JOIN 
        inventory i ON f.film_id = i.film_id
    JOIN 
        rental r ON i.inventory_id = r.inventory_id
    GROUP BY 
        c.name, f.title
) stats
WHERE 
    film_rentals < category_avg_rentals
ORDER BY 
    category_name, film_rentals ASC;
    
## 10.  Identify the top 5 months with the highest revenue and display the revenue generated in each month.
use sakila;
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    ROUND(SUM(amount), 2) AS total_revenue
FROM 
    payment
GROUP BY 
    month
ORDER BY 
    total_revenue DESC
LIMIT 5;


## Normalisation & CTE:

## 1.a. Identify a table in the Sakila database that violates 1NF. Explain how you  would normalize it to achieve 1NF.

		# Here, the awards column contains multiple values in a single cell, which breaks 1NF.

CREATE TABLE actor_award 
    (award_id INT PRIMARY KEY AUTO_INCREMENT,
    actor_id INT,
    award_name VARCHAR(100),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id));
    
## 2.a Choose a table in Sakila and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to no

	## Step 1: 
       ## Understand the Table Structur
       ## All columns contain atomic values.
       ## No repeating groups.
       
   ## Step 2: 
       ## Determine 2NF Compliance
	   ##2NF requires:
       ##The table must be in 1NF.
       ## All non-key attributes must be fully functionally dependent on the entire primary key.
       
   ## Step 3: How to Normalize if It Violates 2N.
   
CREATE TABLE film_language (
    film_id INT,
    language_id INT,
    rating VARCHAR(10),
    special_features VARCHAR(255),
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (language_id) REFERENCES language(language_id)
);

## 3.a.  Identify a table in Sakila that violates 3NF. Describe the transitive dependencies  present and outline.

## customer table in the Sakila database.it’s a  example that can violate Third Normal Form (3NF) due to transitive dependencies.

## Table structure:
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    store_id INT,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50),
    address_id INT,
    active BOOLEAN,
    create_date DATETIME,
    last_update DATETIME
);

-- Steps to Normalize to 3NF
-- - Analyze the dependency:
-- - Create a separate table for store-customer relationships if needed.
-- - Decompose the table:
-- - Determine whether address_id is meant to describe the customer’s address or the store’s address.
-- - Ensure customer only contains attributes directly dependent on customer_id.
-- - If it’s the store’s address, it shouldn’t be in the customer table.
-- - Remove store_id and address_id from customer if they’re not directly related to the customer.
-- - Update relationships:
-- - Use foreign keys to link to store and address tables appropriately.

## 4.a.Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.

--  Step 1: Unnormalized Form (UNF)
-- film table starts like this:

CREATE TABLE film (
    film_id INT,
    title VARCHAR(255),
    release_year YEAR,
    language VARCHAR(50),
    special_features VARCHAR(255),
    actors VARCHAR(255)
);


-- Problems:
-- - special_features might contain "Trailers,Deleted Scenes" → multi-valued.
-- - actors might contain "Tom Hanks, Meryl Streep" → multi-valued.
-- - language is stored as text, not linked to a separate entity.
-- This violates 1NF because:
-- - Columns contain non-atomic values.
-- - There's redundancy and lack of structure.

-- Step 2: First Normal Form (1NF)
-- To achieve 1NF:
-- - Ensure all columns contain atomic values.
-- - Remove repeating groups.
-- 🔧 Fixes:
-- - Split special_features into a separate table:

CREATE TABLE special_feature (
    feature_id INT PRIMARY KEY,
    feature_name VARCHAR(50)
);

CREATE TABLE film_feature (
    film_id INT,
    feature_id INT,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (feature_id) REFERENCES special_feature(feature_id)
);
-- - Split actors into a separate table:
CREATE TABLE actor (
    actor_id INT PRIMARY KEY,
    actor_name VARCHAR(100)
);

CREATE TABLE film_actor (
    film_id INT,
    actor_id INT,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);
-- - Normalize language:
CREATE TABLE language (
    language_id INT PRIMARY KEY,
    name VARCHAR(50)
);

ALTER TABLE film
ADD language_id INT,
DROP COLUMN language;

-- Add foreign key
ALTER TABLE film
ADD FOREIGN KEY (language_id) REFERENCES language(language_id);


-- Now the film table contains only atomic values and foreign keys—1NF achieved.


-- 2NF requires:
-- - The table is in 1NF.
-- - All non-key attributes are fully dependent on the entire primary key.
-- Let’s say the film table has a composite key like (film_id, language_id) and includes attributes like language_name, language_origin.
-- problem:
-- - language_name depends only on language_id, not the full key → partial dependency.
-- Fix:
-- Move language-related attributes to the language table:

ALTER TABLE language
ADD origin VARCHAR(100);


-- And remove them from film.
-- Now, every non-key attribute in film depends only on film_id, which is its single-column primary key—2NF achieved.

## 5.a write a query using a CTE to retrieve the distinct list of actor names and the number of films they  have acted in from the actor and film_actor tables.

WITH ActorFilmCount AS (
    SELECT
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM
        actor a
    JOIN
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY
        a.actor_id, a.first_name, a.last_name
)
SELECT DISTINCT
    actor_name,
    film_count
FROM
    ActorFilmCount
ORDER BY
    film_count DESC;
    
## 6.a  Create a CTE that combines information from the film and language tables to display the film title,  language name, and rental rate.

WITH FilmLanguageInfo AS (
    SELECT
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM
        film f
    JOIN
        language l ON f.language_id = l.language_id)
SELECT *
FROM FilmLanguageInfo
ORDER BY film_title;

## 7.a.  Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.

WITH CustomerRevenue AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM
        customer c
    JOIN
        payment p ON c.customer_id = p.customer_id
    GROUP BY
        c.customer_id, c.first_name, c.last_name)
SELECT *
FROM CustomerRevenue
ORDER BY total_revenue DESC;

## 8. a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

WITH FilmRanking AS (
    SELECT
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM
        film
)
SELECT *
FROM FilmRanking
ORDER BY duration_rank;

## 9. a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the  customer table to retrieve additional customer details.

WITH FrequentRenters AS (
    SELECT
        customer_id,
        COUNT(*) AS rental_count
    FROM
        rental
    GROUP BY
        customer_id
    HAVING
        COUNT(*) > 2
)

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.address_id,
    fr.rental_count
FROM
    customer c
JOIN
    FrequentRenters fr ON c.customer_id = fr.customer_id
ORDER BY
    fr.rental_count DESC;
    

## 10.a. Write a query using a CTE to find the total number of rentals made each month, considering the  rental_date from the rental table

WITH MonthlyRentalCounts AS (
    SELECT
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(*) AS total_rentals
    FROM
        rental
    GROUP BY
        DATE_FORMAT(rental_date, '%Y-%m')
)
SELECT *
FROM MonthlyRentalCounts
ORDER BY rental_month;


 ## 11. a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.

 WITH ActorPairs AS (
    SELECT
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM
        film_actor fa1
    JOIN
        film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE
        fa1.actor_id < fa2.actor_id)
SELECT
    ap.film_id,
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2
FROM
    ActorPairs ap
JOIN
    actor a1 ON ap.actor1_id = a1.actor_id
JOIN
    actor a2 ON ap.actor2_id = a2.actor_id
ORDER BY
    ap.film_id, actor_1, actor_2;




## 12.a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column

 WITH RECURSIVE StaffHierarchy AS (
    
    SELECT
        staff_id,
        first_name,
        last_name,
        reports_to,
        1 AS level
    FROM
        staff
    WHERE
        staff_id = 1 

    UNION ALL

 
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to,
        sh.level + 1
    FROM
        staff s
    INNER JOIN
        StaffHierarchy sh ON s.reports_to = sh.staff_id
)

SELECT *
FROM StaffHierarchy
ORDER BY level, staff_id;

 



