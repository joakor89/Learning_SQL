# Query Mechanics
USE sakila

SELECT first_name, last_name
	FROM customer
    WHERE last_name = 'ZIEGLER';
    
SELECT * 
	FROM category;

# Query Clauses
# The SELECT Clause

SELECT * 
	FROM language;
    
SELECT language_id, name, last_update
	FROM language;

SELECT name 
	FROM language;

SELECT language_id, 
	'COMMON' language_usage,
    language_id * 3.1415927 lang_pi_value,
    upper(name) language_name
FROM language;

SELECT version(),
	user(),
    database();

# Column Aliases

SELECT language_id,
	'COMMON' language_usage,
    language_id * 3.1415927 lang_pi_value,
    upper(name) language_name
FROM language;

SELECT language_id, 
'COMMON' AS language_usage,
language_id * 3.1415927 AS lang_pi_value,
    upper(name) AS language_name
FROM language;

# Removing Duplicates

SELECT actor_id 
	FROM film_actor 
	ORDER BY actor_id;

SELECT DISTINCT actor_id 
	FROM film_actor 
	ORDER BY actor_id;


# The FROM Clause
# Tables
# Derive (subquery-generated) tables

SELECT concat(cust.last_name, ', ', cust.first_name) full_name
	FROM
    (SELECT first_name, last_name, email
    FROM customer
    WHERE first_name = 'JESSIE'
    ) cust;

# Temporary tables

CREATE TEMPORARY TABLE actors_j
	(actor_id smallint(5),
    first_name varchar(45),
    last_name varchar(45)
    );

INSERT INTO actors_j
	SELECT actor_id, first_name, last_name
    FROM actor
    WHERE last_name LIKE 'J%';

SELECT *
	FROM actors_j;

# Views

CREATE VIEW cust_vw AS
	SELECT customer_id, first_name, last_name, active
    FROM customer;

SELECT first_name, last_name
	FROM cust_vw
    WHERE active = 0;

# Table Links

SELECT customer.first_name, customer.last_name, time(rental.rental_date) rental_time
	FROM customer
		INNER JOIN rental
		ON customer.customer_id = rental.customer_id
    WHERE date(rental.rental_date) = '2005-06-14';

# Defining Table Aliases

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
	FROM customer AS c
		INNER JOIN rental AS r
		ON c.customer_id = r.customer_id
    WHERE date(r.rental_date) = '2005-06-14';

# The WHERE Clause

SELECT title
	FROM film 
    WHERE rating = 'G' AND rental_duration >= 7;

SELECT title
	FROM film 
    WHERE rating = 'G' OR rental_duration >= 7;

SELECT title, rating, rental_duration
	FROM film 
    WHERE (rating = 'G' AND rental_duration >= 7)
		OR (rating = 'PG-13' AND rental_duration < 4)

# The GROUP BY & HAVING Clauses

SELECT c.first_name, c.last_name, COUNT(*)
	FROM customer AS c
		INNER JOIN rental AS r
        ON c.customer_id = r.customer_id
	GROUP BY c.first_name, c.last_name
    HAVING COUNT(*) >= 40;

# Ther ORDER BY Clause

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

### Adding ORDER BY

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.first_name;

# Ascending versus Descending Sort Order

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY time(r.rental_date) desc;

# Sorting via Numeric Placeholders

SELECT c.first_name, c.last_name,
	time(r.rental_date) rental_time
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY 3 desc;















