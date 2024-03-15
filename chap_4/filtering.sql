# Filtering

USE sakila;

# Condition Types

# Equality Conditions
SELECT c.email
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

# Inequality Conditions
SELECT c.email
FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) <> '2005-06-14';

# Data modification using inequality conditions

DELETE FROM rental
WHERE year(rental_date) = 2004;

DELETE FROM rental
WHERE year(rental_date) <> 2005 AND year(rental_date) <> 2006;

# Range Conditions
SELECT customer_id, rental_date
	FROM rental
	WHERE rental_date < '2005-05-25';
    
SELECT customer_id, rental_date
	FROM rental
	WHERE (rental_date <= '2005-06-16')
		AND (rental_date >= '2005-06-14');
        
# The BETWEEN operator
SELECT customer_id, rental_date
	FROM rental
	WHERE rental_date BETWEEN '2005-06-14' AND  '2005-06-16';
    
# Note: Lower limit goes after BETWEEN clase and Upper limit goes after AND clause

SELECT customer_id, payment_date, amount
	FROM payment
    WHERE amount BETWEEN 10.0 AND 11.99;
    
# String Ranges
SELECT last_name, first_name
	FROM customer
    WHERE last_name BETWEEN 'FA' AND 'FR';

SELECT last_name, first_name
	FROM customer
    WHERE last_name BETWEEN 'FA' AND 'FRB';

# Membership Conditions

SELECT title, rating
	FROM film
    WHERE rating = 'G' OR rating = 'PG';

# Note: Better approach
SELECT title, rating
	FROM film
    WHERE rating IN ('G', 'PG');
    
# Using subqueries

SELECT title, rating
	FROM film
    WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');
    
# Using NOT IN
SELECT title, rating
	FROM film
    WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

# Matching Conditions
SELECT last_name, first_name
	FROM customer
    WHERE left(last_name, 1) = 'Q'
    
# Using wildcards
SELECT last_name, first_name
	FROM customer
    WHERE last_name LIKE '_A_T%S';

SELECT last_name, first_name
	FROM customer
    WHERE last_name LIKE 'Q%' or last_name LIKE 'Y%';

# Using regular expresions
SELECT last_name, first_name
	FROM customer
    WHERE last_name REGEXP '^[QY]'

# Null: That Four-Letter Word
SELECT rental_id, customer_id
	FROM rental
    WHERE return_date IS NULL;

# a common mistake is:
SELECT rental_id, customer_id
	FROM rental
    WHERE return_date = NULL;
    
SELECT rental_id, customer_id, return_date
	FROM rental
    WHERE return_date IS NOT NULL;
    
SELECT rental_id, customer_id, return_date
	FROM rental
    WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';
    
SELECT rental_id, customer_id, return_date
	FROM rental
    WHERE return_date IS NULL
		OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';