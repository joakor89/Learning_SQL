# Querying Multiple Tables

USE sakila;

# What is a JOIN?
DESC customer;

DESC address;

# Cartesian Product
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c JOIN address AS a;

# INNER JOINs
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c JOIN address AS a
		ON c.address_id = a.address_id;
        
# the INNER clause
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c INNER JOIN address AS a
		ON c.address_id = a.address_id;
        
# the USING clause
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c INNER JOIN address AS a
		USING (address_id);
        
# The ANSI JOIN Syntax
# the variation
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c, address AS a
WHERE c.address_id = a.address_id;
        
SELECT c.first_name, c.last_name, a.address
	FROM customer c, address a
WHERE c.address_id = a.address_id
	AND a.postal_code = 52137;
    
# the SQL92 syntax:
SELECT c.first_name, c.last_name, a.address
	FROM customer AS c INNER JOIN address AS a
		ON c.address_id = a.address_id
	WHERE a.postal_code = 52137;
    
# Joining Three or More Tables
DESC address;

DESC city;

SELECT c.first_name, c.last_name, ct.city
	FROM customer AS c
		INNER JOIN address AS a
			ON c.address_id = a.address_id
				INNER JOIN city AS ct
					ON a.city_id = ct.city_id;
                    
# switching on city
SELECT c.first_name, c.last_name, ct.city
	FROM city AS ct
		INNER JOIN address AS a
			ON a.city_id = ct.city_id
				INNER JOIN customer AS c
					ON c.address_id = a.address_id;

#switching on address
SELECT c.first_name, c.last_name, ct.city
	FROM address AS a
		INNER JOIN city AS ct
			ON a.city_id = ct.city_id
				INNER JOIN customer AS c
					ON c.address_id = a.address_id;
                    
# additional 'STRAIGHT_JOIN' keyword:
SELECT 	STRAIGHT_JOIN c.first_name, c.last_name, ct.city
	FROM city AS ct
		INNER JOIN address AS a
			ON a.city_id = ct.city_id
				INNER JOIN customer AS c
					ON c.address_id = a.address_id;
                    
# Using Subqueries as Tables
SELECT c.first_name, c.last_name, addr.address, addr.city
	FROM customer AS c
		INNER JOIN
			(SELECT a.address_id, a.address, ct.city
            FROM address AS a
				INNER JOIN city AS ct
					ON a.city_id = ct.city_id
			WHERE a.district = 'California'
            ) addr
            ON c.address_id = addr.address_id

# a simpleist way:
SELECT a.address_id, a.address, ct.city
	FROM address AS a
		INNER JOIN city AS ct
			ON a.city_id = ct.city_id
	WHERE a.district = 'California';
    
# Using the Same Table Twice
SELECT f.title
	FROM film AS f
		INNER JOIN film_actor AS fa
			ON f.film_id = fa.film_id
				INNER JOIN actor AS a
					ON fa.actor_id = a.actor_id
	WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
		OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));
        
# both actors involved on same filme:
SELECT f.title
	FROM film AS f
		INNER JOIN film_actor AS fa1
			ON f.film_id = fa1.film_id
				INNER JOIN actor AS a1
					ON fa1.actor_id = a1.actor_id
						INNER JOIN film_actor AS fa2
							ON f.film_id = fa2.film_id
								INNER JOIN actor AS a2
									ON fa2.actor_id = a2.actor_id
	WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
		AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH')
        
# Self-Joins
DESC film;

SELECT f.title, f_prnt.title prequel
	FROM film AS f
		INNER JOIN film AS f_prnt
			ON f_prnt.film_id = f.prequel_film_id
	WHERE f.prequel_film_id IS NOT NULL

