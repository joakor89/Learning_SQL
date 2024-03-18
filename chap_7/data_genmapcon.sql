# Data Generation, Manipulation & Conversion

USE sakila

# Working with 'String' Data

CREATE TABLE string_tbl
	(char_fld CHAR(255),
    vchar_fld VARCHAR(255),
    text_fld TEXT
    );
    
# String Generation
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
	VALUES ('This is a char data',
		'This is a varchar data',
        'This is a text data');
    
# 'vchar_fld' update modification: this will thorown an "Error code". 
# "'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'"

UPDATE string_tbl
	SET vchar_fld = 'This is a piece of extremely long varchar data';

# checking mode:    
SELECT @@session.sql_mode

# setting ANSI 
SET sql_mode='ansi';

#
SELECT @@session.sql_mode

SHOW WARNINGS;

SELECT vchar_fld
	FROM string_tbl;
    
UPDATE string_tbl
	SET text_fld = "This string didn't work, but it does now";    
    
ALTER TABLE string_tbl
MODIFY text_fld VARCHAR(255);    

# Including single quotes
UPDATE string_tbl
	SET text_fld = 'This string didn''t work, but it does now';    


SELECT text_fld
	FROM string_tbl;

# also, applying quote() function
SELECT quote(text_fld)
	FROM string_tbl

# Including special characters
SELECT 'abcdefg', CHAR(97, 98, 99, 100, 101, 102, 103);

SELECT CHAR(128, 129, 130, 131, 132, 133, 134, 135, 136, 137);

SELECT CHAR(138, 139, 140, 141, 142, 143, 144, 145, 146, 147);

SELECT CHAR(148, 149, 150, 151, 152, 153, 154, 155, 156, 157);

SELECT CHAR(158, 159, 160, 161, 162, 163, 164, 165);

# using concat() function
SELECT CONCAT('danke sch', CHAR(148), 'n');

-- SELECT 'danke sch' || CHAR(148 || 'n' 
-- FROM dual;
    
# String Manipulation

DELETE FROM string_tbl;
    
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)	
	VALUES ('This string is 28 characters',
		'This string is 28 characters',
        'This string is 28 characters');

# string functions that return numbers
SELECT LENGTH(char_fld) char_fld,
	LENGTH(vchar_fld) varchar_length,
    LENGTH(text_fld) text_length
    FROM string_tbl;

# position function
SELECT POSITION('characters' IN vchar_fld)
	FROM string_tbl;

# locate function
SELECT LOCATE('is', vchar_fld, 5)
	from string_tbl;

DELETE FROM string_tbl;

INSERT INTO string_tbl(vchar_fld)
	VALUES ('abcd'),
		('xyz'),
        ('QRSTUV'),
        ('qrstuv'),
        ('12345');

SELECT vchar_fld
	FROM string_tbl
    ORDER BY vchar_fld;

SELECT STRCMP('12345', '12345') 12345_12345,
	STRCMP('abcd', 'xyz') abcd_xyz,
    STRCMP('abcd', 'QRSTUV') abcd_QRSTUV,
    STRCMP('qrstv', 'QRSTUV') qrstv_QRSTUV,
    STRCMP('12345', 'xyz') 12345_xyz,
    STRCMP('xyz', 'qrstv') xyz_qrstv;

SELECT name, name LIKE '%y' ends_in_y
	FROM category;

# REGEXP operator
SELECT name, name REGEXP 'y$' ends_in_y
	FROM category;

# String functions that retur strings

DELETE FROM string_tbl;

INSERT INTO string_tbl (text_fld)
	VALUES ('This string was 29 characters');

UPDATE string_tbl
	SET text_fld = CONCAT(text_fld, ', but now it is longer');

SELECT text_fld
	FROM string_tbl

# string for individual pieces
SELECT CONCAT(first_name, ' ', last_name,
' has been a customer since ', date(create_date)) cust_narrative
FROM customer;

# at ORACLE DB will be:
SELECT first_name || ' ' ||
	' has been a customer since ' || date(create_date) cust_narrative
    FROM customer;

# INSERT() function
SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;

SELECT INSERT('goodbye world', 1, 7, 'hello') string;

SELECT REPLACE('goodbye world', 'goodbye', 'hello')
FROM dual;

SELECT SUBSTRING('goodbye cruel world', 9, 5);

# Working with Numeric Data

SELECT (37 * 59) / ( 78 - (8 * 6));

# Performing Arithmetic Functions

# Modulo operator
SELECT MOD(10,4);

SELECT MOD(22.75, 5);

# Power function
SELECT POW(2, 8);

SELECT POW(2, 10) kilobyte, POW(2, 20) megabyte,
	POW(2, 30) gigabyte, POW(2, 40) terabyte;

# Controlling Number Precision

SELECT CEIL(72.445), FLOOR(72.445);

SELECT CEIL(72.000000001), FLOOR(72.99999999);

SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001)

SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);

SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2), TRUNCATE(72.0909, 3);

SELECT ROUND(17, -1), TRUNCATE(17, -1);

# Working with Temporal Data
# Dealing with Time Zones

SELECT @@global.time_zone, @@session.time_zone;

SET time_zone = 'Europe/Zurich';

SELECT @@global.time_zone, @@session.time_zone;

# Generating Temporal Data
# strings representations of temporal data

UPDATE rental
	SET return_date = '2019-09-17 15:30:00'
    WHERE rental_id = 99999;

# String-to-date conversions

# cast() function
SELECT CAST('2019-09-17 15:30:00' AS DATETIME);

SELECT CAST('2019-09-17 15:30:00' AS DATE) date_field,
	CAST('108:17:57' AS TIME) time_field;

# Functions for generating dates

UPDATE rental
	SET return_date = STR_TO_DATE('September 17, 2019', '%M %d, %Y')
		WHERE rental_id = 9999;

SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

# Manipulating Temporal Data
# Temporal functions that return dates
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

# date_add() function
UPDATE rental
	SET return_date = DATE_ADD(return_date, INTERVAL '3:27:11' HOUR_SECOND)
		WHERE rental_id = 9999;

-- UPDATE employee
-- 	SET birht_date = DATE_ADD(birht_date, INTERVAL '9-11' YEAR_MONTH)
-- 		WHERE emp_id = 4789;

# last_day() function
SELECT LAST_DAY('2019-09-17');

# dayname() function
# Temporal functions that return strings
SELECT DAYNAME('2019-09-18');

# extract() function
SELECT EXTRACT(YEAR FROM '2019-09-18 22:19:05')

# Temporal functions that return numbers
# datediff() function

SELECT DATEDIFF('2019-09-03', '2019-06-21');

SELECT DATEDIFF('2019-06-21', '2019-09-03');

# Conversion Functions
# cast() function
SELECT CAST('1456328' AS SIGNED INTEGER);

SELECT CAST('999ABC111' AS UNSIGNED INTEGER);

SHOW WARNINGS;