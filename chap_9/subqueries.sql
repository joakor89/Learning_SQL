# Subqueries

USE sakila;

# What is a Subquery?
SELECT customer_id, first_name, last_name
	FROM customer
		WHERE customer_id = (SELECT MAX(customer_id) FROM customer);
        
SELECT MAX(customer_id)
	FROM customer;
    
SELECT customer_id, first_name, last_name
	FROM customer
		WHERE customer_id = 599;
        
# Subquery Types
# Noncorrelated Subqueries

SELECT city_id, city
	FROM city
		WHERE country_id <>
			(SELECT country_id FROM country WHERE country = 'India')
            
# Multiple-Row, Single-Column Subqueries

# The IN & NOT IN operators

SELECT country_id
	FROM country
		WHERE country IN('Canada', 'Mexico');
        
SELECT country_id
	FROM country
			WHERE country = 'Canada' OR country = 'Mexico';

# using IN operator:            
SELECT city_id, city
	FROM city 
		WHERE country_id IN
			(SELECT country_id
				FROM country
					WHERE country IN ('Canada', 'Mexico'));

# using NOT IN operator:
SELECT city_id, city
	FROM city 
		WHERE country_id NOT IN
			(SELECT country_id
				FROM country
					WHERE country IN ('Canada', 'Mexico'));

# The ALL operator
SELECT first_name, last_name
	FROM customer
		WHERE customer_id <> ALL
			(SELECT customer_id
				FROM payment
					WHERE amount = 0);

# using the NOT IN to perform the same operation
SELECT first_name, last_name
	FROM customer
		WHERE customer_id NOT IN
			(SELECT customer_id
				FROM payment
					WHERE amount = 0);

SELECT first_name, last_name
	FROM customer
		WHERE customer_id NOT IN (122, 452, NULL);

SELECT customer_id, COUNT(*)
	FROM rental
		GROUP BY customer_id
			HAVING COUNT(*) > ALL
            (SELECT COUNT(*)
				FROM rental AS r
					INNER JOIN customer AS c
						ON r.customer_id = c.customer_id
							INNER JOIN address AS a
								ON c.address_ID = a.address_ID
									INNER JOIN city AS ct
										ON a.city_id = ct.city_id
											INNER JOIN country AS co
												ON ct.country_id = co.country_id
													WHERE co.country IN ('United States', 'Mexico', 'Canada')
														GROUP BY r.customer_id);

# The ANY operator
SELECT customer_id, SUM(amount)
	FROM payment
		GROUP BY customer_id
			HAVING SUM(amount) > ANY
				(SELECT SUM(p.amount)
					FROM payment AS p
						INNER JOIN customer AS c
							ON p.customer_id = c.customer_id
								INNER JOIN address AS a
									on c.address_id = a.address_id
										INNER JOIN city AS ct
											ON a.city_id = ct.city_id
												INNER JOIN country AS co
													ON ct.country_id = co.country_id
														WHERE co.country IN('Bolivia', 'Paraguay', 'Chile') 
															GROUP BY co.country
                );

# Multicolumn Subqueries
SELECT fa.actor_id, fa.film_id
	FROM film_actor AS fa
		WHERE fa.actor_id IN 
			(SELECT actor_id
				FROM actor
					WHERE last_name = 'MONROE')
						AND fa.film_id IN
							(SELECT film_id
								FROM film
									WHERE rating = 'PG');


SELECT actor_id, film_id
	FROM film_actor
		WHERE (actor_id, film_id) IN
			(SELECT a.actor_id, f.film_id
				FROM actor AS a
					CROSS JOIN film AS f
						WHERE a.last_name = 'MONROE'
							AND f.rating = 'PG');

# Correlated Subqueries
SELECT first_name, last_name
	FROM customer AS c
		WHERE 20 = 
			(SELECT COUNT(*)
				FROM rental AS r
					WHERE r.customer_id = c.customer_id);

# using range condition:
SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE
			(SELECT SUM(p.amount)
				FROM payment AS p
					WHERE p.customer_id = c.customer_id
						BETWEEN 180 AND 240);

# The EXIST operator

SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE EXISTS
			(SELECT 1
				FROM rental AS r
					WHERE r.customer_id = c.customer_id
						AND date(r.rental_date) < '2005-05-25');

SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE EXISTS
			(SELECT r.rental_date, r.customer_id, 'ABCD' str, 2 * 3 / 7 nmbr 
				FROM rental AS r
					WHERE r.customer_id = c.customer_id
						AND date(r.rental_date) < '2005-05-25');

SELECT a.first_name, a.last_name
	FROM actor AS a
		WHERE NOT EXISTS
			(SELECT 1
				FROM film_actor AS fa
					INNER JOIN film AS f
						ON f.film_id = fa.film_id
							WHERE fa.actor_id = a.actor_id
								AND f.rating = 'R');

# Data Manipulation usin Correlated Subqueries

UPDATE customer AS c
	SET c.last_update = 
		(SELECT MAX(r.rental_date)
			FROM rental AS r
				WHERE r.customer_id = c.customer_id);

UPDATE customer AS c
	SET c.last_update = 
		(SELECT MAX(r.rental_date)
			FROM rental AS r
				WHERE r.customer_id = c.customer_id)
	WHERE EXISTS
		(SELECT 1
			FROM rental AS r
				WHERE r.customer_id = c.customer_id);

-- DELETE FROM customer AS c
-- 	WHERE 365 < ALL
-- 		(SELECT DATEDIFF(now(), r.rental_date) days_since_last_rental
-- 			FROM rental AS r
-- 				WHERE r.customer_id = c.customer_id);

# When to Use Subqueries
# Subqueries as Data Sources

SELECT c.first_name, c.last_name,
		pymnt.num_rentals, pymnt.tot_payments
	FROM customer AS c 
		INNER JOIN 
			(SELECT customer_id,
					COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
				FROM payment
                GROUP BY customer_id) AS pymnt
					ON c.customer_id = pymnt.customer_id;

SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
	FROM payment
		GROUP BY customer_id;

# Data fabrication

SELECT 'Small fry' AS name, 0 AS low_limit, 74.99  AS high_limit
	UNION ALL
		SELECT 'Average Joes' AS name, 75 AS low_limit, 149.99 AS high_limit
			UNION ALL
				SELECT 'Heavy Hitters' AS name, 150 AS low_limit, 9999999.99 AS high_limit;

SELECT pymnt_grps.name, COUNT(*) AS num_customers
	FROM
    (SELECT customer_id,
		COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
			FROM payment
				GROUP BY customer_id) AS pymnt
		INNER JOIN
			(SELECT 'Small fry' AS name, 0 AS low_limit, 74.99  AS high_limit
				UNION ALL
					SELECT 'Average Joes' AS name, 75 AS low_limit, 149.99 AS high_limit
					UNION ALL
						SELECT 'Heavy Hitters' AS name, 150 AS low_limit, 9999999.99 AS high_limit) AS pymnt_grps
		ON pymnt.tot_payments
			BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
				GROUP BY pymnt_grps.name;

# Task-Oriented subqueries

SELECT c.first_name, c.last_name, ct.city,
		sum(p.amount) AS tot_payments, COUNT(*) AS tot_rentals
	FROM payment AS p
		INNER JOIN customer AS c
			ON p.customer_id = c.customer_id
				INNER JOIN address AS a
					ON c.address_id = a.address_id
						INNER JOIN city AS ct
							ON a.city_id = ct.city_id
								GROUP BY c.first_name, c.last_name, ct.city;

# optimized version
SELECT customer_id,
		COUNT(*) AS tot_rental, SUM(amount) AS tot_payments
	FROM PAYMENT
		GROUP BY customer_id;

SELECT c.first_name, c.last_name,
		ct.city,
			pymnt.tot_payments, pymnt.tot_rentals
    FROM 
		(SELECT customer_id,
				COUNT(*) AS tot_rentals, SUM(amount) AS tot_payments
			FROM payment
				GROUP BY customer_id
                ) AS pymnt
                INNER JOIN customer AS c
					ON pymnt.customer_id = c.customer_id
						INNER JOIN address AS a
							ON c.address_id = a.address_id
								INNER JOIN city AS ct
									ON a.city_id = ct.city_id;

# Common table expressions

-- WITH actors_s AS
-- 	(SELECT actor_id, first_name, last_name
-- 		FROM actor
-- 			WHERE last_name LIKE 'S%'
--             ),
--             actors_s_pg AS
-- 				(SELECT s.actor_id, s.first_name, s.last_name,
-- 						f.film_id, f.title
-- 					FROM actors_s AS s
-- 						INNER JOIN film_actor AS fa
-- 							ON s.actor_id = fa.actor_id
-- 								INNER JOIN film AS f
-- 									ON f.film_id = fa.film_id
-- 					WHERE f.rating = 'PG'),
--                     actors_s_pg_avenue AS
-- 						(SELECT spg.first_name, spg.last_name, p.amount
-- 							FROM actors_s_pg AS spg
-- 								INNER JOIN inventory AS i
-- 									ON i.film_id = spg.film_id
-- 										INNER JOIN rental AS r
-- 											ON i.inventory_id = r.inventory_id
-- 												INNER JOIN payment AS p
-- 													ON r.rental_id = p.rental_id
--                                                     ) -- end of With clause
--                                                     SELECT spg_rev.first_name, spg_rev.last_name,
-- 															SUM(speg_rev.amount) AS tot_revenue
-- 														FROM actors_s_pg_avenue AS spg_rev
-- 															GROUP BY spg_rev.first_name, spg_rev.last_name
-- 																ORDER BY 3 DESC;


WITH actors_s AS (
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE last_name LIKE 'S%'
),
actors_s_pg AS (
    SELECT s.actor_id, s.first_name, s.last_name,
           f.film_id, f.title
    FROM actors_s AS s
    INNER JOIN film_actor AS fa ON s.actor_id = fa.actor_id
    INNER JOIN film AS f ON f.film_id = fa.film_id
    WHERE f.rating = 'PG'
),
actors_s_pg_avenue AS (
    SELECT spg.first_name, spg.last_name, p.amount
    FROM actors_s_pg AS spg
    INNER JOIN inventory AS i ON i.film_id = spg.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
    INNER JOIN payment AS p ON r.rental_id = p.rental_id
)
SELECT spg_rev.first_name, spg_rev.last_name,
       SUM(spg_rev.amount) AS tot_revenue
FROM actors_s_pg_avenue AS spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY tot_revenue DESC;

# Subqueries as Expression Generators

SELECT
(SELECT c.first_name
	FROM customer AS c
	WHERE c.customer_id = p.customer_id
) first_name,
(SELECT c.last_name
	FROM customer AS c
	WHERE c.customer_id = p.customer_id
) last_name,
(SELECT ct.city
	FROM customer AS c
		INNER JOIN address AS a
			ON c.address_id = a.address_id
		INNER JOIN city AS ct
			ON a.city_id = ct.city_id
	WHERE c.customer_id = p.customer_id
)city,
SUM(p.amount) AS tot_payments,
COUNT(*) AS top_rentals
FROM payment AS p
	GROUP BY p.customer_id;

SELECT a.actor_id, a.first_name, a.last_name
	FROM actor AS a
		ORDER BY
        (SELECT COUNT(*)
			FROM film_actor AS fa
				WHERE fa.actor_id = a.actor_id) DESC;

INSERT INTO film_actor (actor_id, film_id, last_update)
VALUES(
(SELECT actor_id
	FROM actor
WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS'),
(SELECT film_id
	FROM film
WHERE title = 'ACE GOLDFINGER'),
NOW()
);




