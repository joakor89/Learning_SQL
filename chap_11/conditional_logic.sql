# Conditional Logic

USE sakila;

# What is Conditional Logic?

SELECT first_name, last_name,
	CASE
		WHEN active = 1 THEN 'ACTIVE'
        ELSE 'INACTIVE'
	END AS activity_type
FROM customer;
			
# The CASE Expresion

# Searched case expressions
# syntax:

-- CASE
-- 		WHEN C1 THEN E1
-- 		WHEN C2 THEN E2
-- 		WHEN CN THEN EN
-- 	[ELSE ED]
-- END

# search case expression in detail:
-- CASE
-- 	WHEN category.name IN ('Children', 'Family', 'Sports', 'Animation')
-- 		THEN 'All Ages'
-- 	WHEN category.name = 'Horror'
-- 		THEN 'Adult'
-- 	WHEN category.name IN ('Music', 'Games')
-- 		THEN 'Teens'
-- 	ELSE 'Other'
-- END

# using subqueries on rental's number:
SELECT c.first_name, c.last_name,
		CASE
			WHEN active = 0 THEN 0
            ELSE
				(SELECT COUNT(*)
					FROM rental AS r
						WHERE r.customer_id = c.customer_id)
		END AS num_rentals
	FROM customer AS c;

# Simple case expressions
# syntax:

-- CASE V0
-- 		WHEN V1 THEN E1
--         WHEN V2 THEN E2
--         ...
--         WHEN VN THEN EN
-- 	[ELSE ED]
-- END

# simple case expression in detail:
-- CASE category.name
-- 		WHEN 'Children' THEN 'All Ages'
--         WHEN 'Family' THEN 'All Ages'
--         WHEN 'Sports' THEN 'All Ages'
--         WHEN 'Animation' THEN 'All Ages'
--         WHEN 'Horror' THEN 'Adult'
--         WHEN 'Music' THEN 'Teens'
--         WHEN 'Games' THEN 'Teens'
-- 	ELSE 'Other'
-- END

# Example of Case Expressions

# Result set transformation
SELECT monthname(rental_date) AS rental_month,
		COUNT(*) AS num_rentals
	FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
	GROUP BY monthname(rental_date);

SELECT
		SUM(CASE WHEN monthname(rental_date) = 'May' THEN 1
			ELSE 0 END) AS May_rentals,
		SUM(CASE WHEN monthname(rental_date) = 'June' THEN 1
			ELSE 0 END) AS June_rentals,
		SUM(CASE WHEN monthname(rental_date) = 'July' THEN 1
			ELSE 0 END) AS July_rentals
	FROM rental	
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';

# Checking for Existence

SELECT a.first_name, a.last_name,
		CASE
			WHEN EXISTS (SELECT 1 
							FROM film_actor AS fa
								INNER JOIN film AS f
									ON fa.film_id = f.film_id
							WHERE fa.actor_id = a.actor_id
								AND f.rating = 'G') THEN 'Y'
			ELSE 'N'
		END AS g_actor,
        
        CASE
			WHEN EXISTS (SELECT 1 
							FROM film_actor AS fa
								INNER JOIN film AS f
									ON fa.film_id = f.film_id
							WHERE fa.actor_id = a.actor_id
								AND f.rating = 'PG') THEN 'Y'
			ELSE 'N'
		END AS pg_actor,
        
        CASE
			WHEN EXISTS (SELECT 1 
							FROM film_actor AS fa
								INNER JOIN film AS f
									ON fa.film_id = f.film_id
							WHERE fa.actor_id = a.actor_id
								AND f.rating = 'NC-17') THEN 'Y'
			ELSE 'N'
		END AS nc17_actor
	FROM actor AS a
WHERE a.last_name LIKE 'S%' OR first_name LIKE 'S%';

SELECT f.title,
		CASE (SELECT COUNT(*)
				FROM inventory AS i
					WHERE i.film_id = f.film_id)
			WHEN 0 THEN 'Out of Stock'
            WHEN 1 THEN 'Scarce'
            WHEN 2 THEN 'Scarce'
            WHEN 3 THEN 'Available'
            WHEN 4 THEN 'Available'
		ELSE 'Commong'
	END AS film_availability
FROM film AS f
;

# Division-by-Zero Errors

SELECT 100 / 0;

# wrapping up on conditional logics as follow:

SELECT c.first_name, c.last_name,
		SUM(p.amount) AS tot_payment_amt,
        COUNT(p.amount) AS num_payments,
        SUM(p.amount) / 
			CASE WHEN COUNT(p.amount) = 0 THEN 1
				ELSE COUNT(p.amount)
			END
	FROM customer AS c
        LEFT OUTER JOIN payment AS p
			ON c.customer_id = p.customer_id
	GROUP BY c.first_name, c.last_name;
    
# Conditional Updates

-- UPDATE customer
-- SET = 
-- 	CASE
--         WHEN 90 <= (SELECT DATEDIFF(NOW(), MAX(rental_date))
-- 						FROM rental AS r
-- 					WHERE r.customer_id = customer.customer_id)
--                     THEN 0 
-- 				ELSE 1
-- 			END
-- 		WHERE active = 1;

# Handling NULL Values

SELECT c.first_name, c.last_name,
		CASE
			WHEN a.address IS NULL THEN 'Unknown'
			ELSE a.address
		END AS address,
        
        CASE
			WHEN ct.city IS NULL THEN 'Unknown'
			ELSE ct.city
		END AS city,
        
        CASE
			WHEN cn.country IS NULL THEN 'Unknown'
			ELSE cn.country
		END AS country
        
	FROM customer AS c
		LEFT OUTER JOIN address AS a
			ON c.address_id = a.address_id
		LEFT OUTER JOIN city AS ct
			ON a.city_id = ct.city_id
		LEFT OUTER JOIN country AS cn
			ON ct.country_id = cn.country_id;
            

# on null values calculation:
SELECT (7 * 5) / ((3 + 14) * NULL);

