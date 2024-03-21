# Joins Revisited

USE sakila;

#Outer Joins

SELECT f.film_id, f.title, COUNT(*) AS num_copies
	FROM film AS f
		INNER JOIN inventory AS i
			ON f.film_id = i.film_id
	GROUP BY f.film_id, f.title;
    
SELECT f.film_id, f.title, COUNT(i.inventory_id) AS num_copies
	FROM film AS f
		LEFT OUTER JOIN inventory AS i
			ON f.film_id = i.film_id
	GROUP BY f.film_id, f.title;

# zooming clause in detail:
SELECT f.film_id, f.title, i.inventory_id
	FROM film AS f
		INNER JOIN inventory AS i
			ON f.film_id = i.film_id
	WHERE f.film_id BETWEEN 13 AND 15;

# same query but on "left outer join" approach:
SELECT f.film_id, f.title, i.inventory_id
	FROM film AS f
		LEFT OUTER JOIN inventory AS i
			ON f.film_id = i.film_id
	WHERE f.film_id BETWEEN 13 AND 15;

# Left vs. Right Outer Joins

SELECT f.film_id, f.title, i.inventory_id
	FROM film AS f
		RIGHT OUTER JOIN inventory AS i
			ON f.film_id = i.film_id
	WHERE f.film_id BETWEEN 13 AND 15;

# Three-Way Outer Joins

SELECT f.film_id, f.title, i.inventory_id, r.rental_date
	FROM film AS f
		LEFT OUTER JOIN inventory AS i
			ON f.film_id = i.film_id
		LEFT OUTER JOIN rental AS r
			ON i.inventory_id = r.inventory_id
	WHERE f.film_id BETWEEN 13 AND 15;

# Cross Joins
SELECT c.name AS category_name, l.name AS language_name
	FROM category AS c
		CROSS JOIN language AS l;
        
# Instead of:

SELECT 'Small Fry' AS name, 0 AS low_limit, 74.99 AS high_limit
	UNION ALL
		SELECT 'Average Joes' AS name, 75 AS low_limit, 149.99 AS high_limit
			UNION ALL
				SELECT 'Heavy Hitters' AS name, 150 AS low_limit, 9999999.99 AS high_limit;

# if any table existe, it can be possible to create a table as follow, nevertheless, it'd be tedious and not as efficient as it could've been, then:

-- SELECT '2020-01-01' AS dt
-- UNION ALL
-- SELECT '2020-01-01' AS dt
-- UNION ALL
-- SELECT '2020-01-01' AS dt
-- UNION ALL
-- SELECT '2020-01-01' AS dt
-- UNION ALL

# and so on. A different and more efficient strategy can be applied on:
SELECT ones.num + tens.num + hundreds.num
	FROM
    (SELECT 0  num UNION ALL
    SELECT 1 num UNION ALL
    SELECT 2 num UNION ALL
    SELECT 3 num UNION ALL
    SELECT 4 num UNION ALL
    SELECT 5 num UNION ALL
    SELECT 6 num UNION ALL
    SELECT 7 num UNION ALL
    SELECT 8 num UNION ALL
    SELECT 9 num) AS ones
CROSS JOIN
	(SELECT 0 num UNION ALL
    SELECT 10 num UNION ALL
    SELECT 20 num UNION ALL
    SELECT 30 num UNION ALL
    SELECT 40 num UNION ALL
    SELECT 50 num UNION ALL
    SELECT 60 num UNION ALL
    SELECT 70 num UNION ALL
    SELECT 80 num UNION ALL
    SELECT 90 num) AS tens
CROSS JOIN
	(SELECT 0 num UNION ALL
    SELECT 100 num UNION ALL
    SELECT 200 num UNION ALL
    SELECT 300 num) AS hundreds;

# net step: switching number set into date set
SELECT DATE_ADD('2020-01-01',
		INTERVAL(ones.num, + tens.num + hundreds.num) DAY) AS dt
	FROM(SELECT 0  num UNION ALL
    SELECT 1 num UNION ALL
    SELECT 2 num UNION ALL
    SELECT 3 num UNION ALL
    SELECT 4 num UNION ALL
    SELECT 5 num UNION ALL
    SELECT 6 num UNION ALL
    SELECT 7 num UNION ALL
    SELECT 8 num UNION ALL
    SELECT 9 num) AS ones
CROSS JOIN
	(SELECT 0 num UNION ALL
    SELECT 10 num UNION ALL
    SELECT 20 num UNION ALL
    SELECT 30 num UNION ALL
    SELECT 40 num UNION ALL
    SELECT 50 num UNION ALL
    SELECT 60 num UNION ALL
    SELECT 70 num UNION ALL
    SELECT 80 num UNION ALL
    SELECT 90 num) AS tens
CROSS JOIN
	(SELECT 0 num UNION ALL
    SELECT 100 num UNION ALL
    SELECT 200 num UNION ALL
    SELECT 300 num) AS hundreds
WHERE DATE_ADD('2020-01-01',
	INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY 1;

# Not too elegant bu addressed the problem as follow:
SELECT days.dt, COUNT(r.rental_id) AS num_rentals
    FROM rental AS r
    RIGHT OUTER JOIN
        (SELECT DATE_ADD('2005-01-01',
            INTERVAL (ones.num + tens.num + hundreds.num) DAY) AS dt
        FROM
            (SELECT 0 AS num UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9) AS ones
        CROSS JOIN
            (SELECT 0 AS num UNION ALL
            SELECT 10 UNION ALL
            SELECT 20 UNION ALL
            SELECT 30 UNION ALL
            SELECT 40 UNION ALL
            SELECT 50 UNION ALL
            SELECT 60 UNION ALL
            SELECT 70 UNION ALL
            SELECT 80 UNION ALL
            SELECT 90) AS tens
        CROSS JOIN
            (SELECT 0 AS num UNION ALL
            SELECT 100 UNION ALL
            SELECT 200 UNION ALL
            SELECT 300) AS hundreds
        WHERE DATE_ADD('2005-01-01',
            INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2006-01-01'
        ) AS days
    ON days.dt = DATE(r.rental_date)
GROUP BY days.dt
ORDER BY 1;

# Natural Joins

SELECT c.first_name, c.last_name, date(r.rental_date)
	FROM customer AS c
		NATURAL JOIN rental AS r;

# or...
SELECT cust.first_name, cust.last_name, date(r.rental_date)
	FROM
		(SELECT customer_id, first_name, last_name
			FROM customer) AS cust
		NATURAL JOIN rental AS r;


# It's strongly suggest to avoid this type of join













