# Views 

USE sakila;
# What are Views?

CREATE VIEW customer_vw
	(customer_id,
    first_name, 
    last_name, 
    email
    )
AS 
	SELECT
		customer_id,
		first_name, 
		last_name, 
		CONCAT(substr(email,1,2), '*****', substr(email, -4)) email
	FROM customer;

# retrieving the customer view:
SELECT first_name, last_name, email
	FROM customer_vw;
    
# getting customer's view derscription:
DESCRIBE customer_vw;

SELECT first_name, COUNT(*), MIN(last_name), MAX(last_name)
	FROM customer_vw
WHERE first_name LIKE 'J%' 
	GROUP BY first_name
		HAVING COUNT(*)
ORDER BY 1;

# joining views with other tables
SELECT cv.first_name, cv.last_name, p.amount
	FROM customer_vw AS cv
		INNER JOIN payment AS p
			ON cv.customer_id = p.customer_id
WHERE p.amount >= 11;

# Why Use Views?
# Data Security

CREATE VIEW active_customer_vs
	(customer_id,
    first_name, 
    last_name, 
    email
    )
AS
SELECT
	customer_id,
    first_name, 
    last_name,
    CONCAT(substr(email, 1, 2), '*****', substr(email, -4)) email
	FROM customer
WHERE active = 1;


# Data Aggregation
CREATE VIEW sales_by_film_category
AS 
SELECT
	c.name AS category,
    SUM(p.amount) AS total_sales
    FROM payment AS p
		INNER JOIN rental AS r
			ON p.rental_id = r.rental_id
		INNER JOIN inventory AS i 
			ON r.inventory_id = i.inventory_id
		INNER JOIN film AS f 
			ON i.film_id = f.film_id
		INNER JOIN film_category AS fc
			ON f.film_id = fc.film_id
		INNER JOIN category AS c
			ON fc.category_id = c.category_id
	GROUP BY c.name
ORDER BY total_sales DESC;

# Hiding Complexity

CREATE VIEW film_stats
AS
SELECT f.film_id, f.title, f.description, f.rating,
	(SELECT c.name
		FROM category AS c
			INNER JOIN film_category AS fc
		ON c.category_id = fc.category_id
	WHERE fc.film_id = f.film_id) AS category_name,
    (SELECT COUNT(*)
		FROM film_actor AS fa
	WHERE fa.film_id = f.film_id
    ) AS num_actors,
    (SELECT COUNT(*)
		FROM inventory AS i
	WHERE i.film_id = f.film_id
    ) AS inventory_cnt,
    (SELECT COUNT(*)
		FROM inventory AS i
			INNER JOIN rental AS r
		ON i.inventory_id = r.inventory_id
	WHERE i.film_id = f.film_id
    ) AS num_rentals
FROM film AS f;

# Joining Partitioned Data

CREATE VIEW payment_all
	(payment_id,
    customer_id, 
    staff_id,
    rental_id, 
    amount,
    payment_id,
    last_update
    )
AS
SELECT payment_id, customer_id, staff_id, rental_id
		amount_, payment_date, last_update
	FROM payment_historic
UNION ALL
SELECT payment_id, customer_id, staff_id, rental_id
		amount_, payment_date, last_update
	FROM payment_current;

# Updateable Simple Views

CREATE VIEW customer_vw
	(customer_id,
    first_name,
    last_name,
    email
    )
AS
SELECT
	customer_id,
    first_name,
    last_name,
    CONCAT(substr(email, 1, 2), '*****', substr(email, -4)) email
FROM customer;

UPDATE customer_vw
	SET last_name = 'SMITH-ALLEN'
WHERE customer_id = 1;

SELECT first_name, last_name, email
	FROM customer
WHERE customer_id = 1;

UPDATE customer_vw
	SET email = 'MARY.SMITH@sakilacustomer.org'
WHERE customer_id = 1;

# Updating Complex Views
CREATE VIEW customer_details
AS
SELECT c.customer_id,
		c.store_id,
        c.first_name, 
        c.last_name,
        c.address_id,
        c.active,
        c.create_date,
        a.address,
        ct.city,
        cn.country,
        a.postal_code
	FROM customer AS c
		INNER JOIN address AS a
			ON c.address_id = a.address_id
		INNER JOIN city AS ct
			on a.city_id = ct.city_id
		INNER JOIN country AS cn
			ON ct.country_id = cn.country_id;

UPDATE customer_details
	SET last_name = 'SMITH-ALLEN', active = 0
WHERE customer_id = 1;

UPDATE customer_details
	SET address = '999 Mockingbird Lane'
WHERE customer_id = 1;


UPDATE customer_details
	SET last_name = 'SMITH-ALLEN',
    active = 0,
    address = '999 Mockingbird Lane'
WHERE customer_id = 1;

INSERT INTO customer_details 
		(customer_id, store_id, first_name, last_name,
        address_id, active, create_date, address)
	VALUES (9999, 2, 'THOMAS', 'BISHOP', 7, 1, NOW(),
		'999 Mockingbird Lane');












