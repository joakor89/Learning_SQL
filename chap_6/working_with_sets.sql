# Working with Sets

USE sakila;

# Set Theory Primer & Practice

DESC customer;

DESC city;

SELECT 1 num, 'abc' str 
	UNION
		SELECT 9 num, 'xyz' str;
        
# Set Operators

# The Union Operator

# coumpound query
SELECT 'CUST' typ, c.first_name, c.last_name
	FROM customer AS c
		UNION ALL
	SELECT 'ACTR' typ, a.first_name, a.last_name
		FROM actor AS a;

# duplicated compound query (a)
SELECT 'ACTR' typ, a.first_name, a.last_name
	FROM actor AS a
		UNION ALL
	SELECT 'ACTR' typ, a.first_name, a.last_name
		FROM actor AS a;

# duplicated compound query (b)
SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
			UNION ALL
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

# with UNION
SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
			UNION 
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

# The Intersect Operator

SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE c.first_name LIKE 'D%' AND c.last_name LIKE 'T%'
			INTERSECT
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'D%' AND a.last_name LIKE 'T%';
            

SELECT c.first_name, c.last_name
	FROM customer AS c
		WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
			INTERSECT
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

# The EXCEPT Operator

SELECT a.first_name, a.last_name
	FROM actor AS a
		WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
				EXCEPT
	SELECT c.first_name, c.last_name
		FROM customer AS c
			WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';
            
# Set Operation Rules

# Sorting Compound Query Results

SELECT a.first_name AS fname, a.last_name AS lname
	FROM actor AS a
		WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'd%'
			UNION ALL
	SELECT c.first_name, c.last_name
		FROM customer AS c
			WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'd%'
				ORDER BY lname, fname;
                
# Set Operation Precedence

SELECT a.first_name, a.last_name
	FROM actor AS a
		WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
			UNION ALL
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
				UNION
		SELECT c.first_name, c.last_name
			FROM customer AS c
				WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';
                
# the same compound reversed:
SELECT a.first_name, a.last_name
	FROM actor AS a
		WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
			UNION 
	SELECT a.first_name, a.last_name
		FROM actor AS a
			WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
				UNION ALL
		SELECT c.first_name, c.last_name
			FROM customer AS c
				WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';
                
# MySQL does not yet allow parentheses in compound queries, but if you are using a different database server
# you can wrap adjoining queries in parenthesis to override it.alter
