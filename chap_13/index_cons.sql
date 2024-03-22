# Indexes & Constraints

USE sakila;

# Indexes
SELECT first_name, last_name
	FROM customer
WHERE last_name LIKE 'Y%';

# Index Creation
ALTER TABLE customer
	ADD INDEX idx_email (email);

# let's look up the table:
SHOW INDEX
	FROM customer;

-- CREATE TABLE customer(
-- 	customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
--     store_id TINYINT UNSIGNED NOT NULL,
--     first_name VARCHAR(45) NOT NULL,
--     last_name VARCHAR(45) NOT NULL,
--     email VARCHAR(50) DEFAULT NULL,
--     address_id SMALLINT UNSIGNED NOT NULL,
--     active BOOLEAN NOT NULL DEFAULT TRUE, 
--     create_date DATETIME NOT NULL,
--     last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
--     PRIMARY KEY (customer_id),
--     KEY idx_fk_store_id (store_id),
--     KEY idx_fk_address_id (address_id),
--     KEY idx_last_name (last_name),
--     ...

ALTER TABLE customer
	DROP INDEX idx_email;
    
# Unique indexes

ALTER TABLE customer
	ADD UNIQUE idx_email (email);

-- INSERT INTO customer
-- 	(store_id, first_name, last_name, email, address_id, active)
-- 		VALUES
-- 	(1, 'ALAN', 'KAHN', 'ALAN.KAHN@sakilacustomer.org', 394, 1);

# Multicolumn indexes

ALTER TABLE customer
	ADD INDEX idx_full_name (last_name, first_name);
    
# Type of Indexes
# B-tree indexes

# Bitmap indexes
# oracle approach as follow:
-- CREATE BITMAP INDEX idx_active
-- 	ON CUSTOMER (active);

# How Indexes are Used

SELECT customer_id, first_name, last_name
	FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

EXPLAIN 
SELECT customer_id, first_name, last_name
	FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

# Constraint Creation

-- CREATE TABLE customer (
-- customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
-- store_id TINYINT UNSIGNED NOT NULL,
-- first_name VARCHAR(45) NOT NULL,
-- last_name VARCHAR(45) NOT NULL,
-- email VARCHAR(50) DEFAULT NULL,
-- address_id SMALLINT UNSIGNED NOT NULL,
-- active BOOLEAN NOT NULL DEFAULT TRUE,
-- create_date DATETIME NOT NULL,
-- last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- 	ON UPDATE CURRENT_TIMESTAMP,
-- PRIMARY KEY (customer_id),
-- 	KEY idx_fk_store_id (store_id),
--     KEY idx_fk_address_id (address_id),
--     KEY idx_last_name (last_name),
-- CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
-- 	REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
-- CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
-- 	REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
--     )ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Altering tables as follow:

-- ALTER TABLE customer
-- 	ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
-- REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- ALTER TABLE customer
-- 	ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
-- REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE;

SELECT c.first_name, c.last_name, c.address_id, a.address
	FROM customer AS c
		INNER JOIN address AS a
			ON c.address_id = a.address_id
	WHERE a.address = 123;

-- DELETE FROM address WHERE address_id = 123;

UPDATE address
	SET address_id = 9999
WHERE address_id = 123;

SELECT c.first_name, c.last_name, c.address_id, a.address
	FROM customer AS c
		INNER JOIN address AS a
			ON c.address_id = a.address_id
	WHERE a.address = 9999;
