# Grouping & Aggregates

USE sakila;

#Grouping Concepts

SELECT customer_id
	FROM rental;

# using GROUP BY clause:

SELECT customer_id
	FROM rental
		GROUP BY customer_id;

# using COUNT() clause:

SELECT customer_id, count(*)
	FROM rental
		GROUP BY customer_id;

# adding ORDER BY clause:
SELECT customer_id, COUNT(*)
	FROM rental
		GROUP BY customer_id
				ORDER BY 2 DESC;

# using HAVING filter condition:
SELECT customer_id, COUNT(*)
	FROM rental
		GROUP BY customer_id
				HAVING COUNT(*) >= 40;

# Aggregate Functions
# using all common aggregate functions:
SELECT MAX(amount) max_amt,
		MIN(amount) min_amt,
		AVG(amount) avg_amt,
		SUM(amount) tot_amt, 
		COUNT(amount) num_payments
	FROM payment;

# Implicit versus Explicit Groups

# must explicitly specify how data will be grouped:
SELECT customer_id,
		MAX(amount) AS max_amt,
		MIN(amount) AS min_amt,
		AVG(amount) AS avg_amt,
		SUM(amount) AS tot_amt, 
		COUNT(*) AS num_payments
	FROM payment
		GROUP BY customer_id;
        
# Counting Distinct Values
SELECT COUNT(customer_id) as num_rows,
		COUNT(DISTINCT customer_id) AS num_customer
	FROM payment;

# Using Expressions
SELECT MAX(DATEDIFF(return_date, rental_date))
	FROM rental;

# How Nulls are Handled
CREATE TABLE number_tbl
	(val SMALLINT);

INSERT INTO number_tbl VALUES (1);

INSERT INTO number_tbl VALUES (3);

INSERT INTO number_tbl VALUES (5);

SELECT COUNT(*) AS num_rows,
		COUNT(val) AS num_vasl,
		SUM(val) AS total,
		MAX(val) AS max_vals,
		AVG(val) AS avg_vals
	FROM number_tbl;

INSERT INTO number_tbl VALUES (NULL);

SELECT COUNT(*) AS num_rows,
		COUNT(val) AS num_vasl,
		SUM(val) AS total,
		MAX(val) AS max_vals,
		AVG(val) AS avg_vals
	FROM number_tbl;

# Generating Groups
# Single-Column Grouping

SELECT actor_id, COUNT(*)
	FROM film_actor
		GROUP BY actor_id;

# Multicolumn Grouping
SELECT fa.actor_id, f.rating, COUNT(*)
	FROM film_actor AS fa
		INNER join film AS f
			ON fa.film_id = f.film_id
				GROUP BY fa.actor_id, f.rating
					ORDER BY 1, 2;


# Grouping via Expressions

SELECT EXTRACT(YEAR FROM rental_date) AS year, COUNT(*) AS how_many
	FROM rental
		GROUP BY EXTRACT(YEAR FROM rental_date);

# Generating Rollups 
SELECT fa.actor_id, f.rating, COUNT(*)
	FROM film_actor AS fa
		INNER JOIN film AS f
			ON fa.film_id = f.film_id
				GROUP BY fa.actor_id, f.rating WITH ROLLUP
					ORDER BY 1, 2;

# Group Filter Conditions
SELECT fa.actor_id, f.rating, COUNT(*)
	FROM film_actor AS fa
		INNER JOIN film AS f
			WHERE f.rating IN ('G', 'PG')
				GROUP BY fa.actor_id, f.rating
					HAVING COUNT(*) > 9;

