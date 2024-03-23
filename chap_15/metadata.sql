# Metadata

USE sakila;

# Information Schema (information_schema)
SELECT table_name, table_type
	FROM information_schema.tables
WHERE table_schema = 'sakila'
	ORDER BY 1;

# excluding views
SELECT table_name, table_type
	FROM information_schema.tables
WHERE table_schema = 'sakila'
		AND table_type = 'BASE TABLE'
	ORDER BY 1;

# querying on views
SELECT table_name, is_updatable
	FROM information_schema.views
WHERE table_schema = 'sakila'
	ORDER BY 1;

SELECT column_name, data_type,
		character_maximum_length AS char_max_len,
		numeric_precision AS num_prcsn, numeric_scale AS num_scale
	FROM information_schema.columns
WHERE table_schema = 'sakila' AND table_name = 'film'
ORDER BY ordinal_position;

# retrieving statistics
SELECT index_name, non_unique, seq_in_index, column_name
	FROM information_schema.statistics
WHERE table_schema = 'sakila' AND table_name = 'rental'
ORDER BY 1, 3;

SELECT constraint_name, table_name, constraint_type
	FROM information_schema.table_constraints
WHERE table_schema = 'sakila'
ORDER BY 3, 1;

# Working with Metadata
# Schema Generation Scripts

# example
-- CREATE TABLE category (
-- 	category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
--     name VARCHAR(25) NOT NULL,
--     last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
-- 		ON UPDATE CURRENT_TIMESTAMP,
-- 	PRIMARY KEY (category_id)
--     )ENGINE=InnoDB DEFAULT CHARSET=utf8;
    
SELECT 'CREATE TABLE category (' create_table_statement
	UNION ALL
    SELECT cols.txt
		FROM
			(SELECT CONCAT(' ', column_name, ' ', column_type,
				CASE
					WHEN is_nullable= 'NO' THEN ' not null'
                    ELSE ''
				END, 
                CASE
					WHEN extra IS NOT NULL AND extra LIKE 'DEFAULT_GENERATED%'
						THEN CONCAT('DEFAULT ', column_default,substr(extra,18))
					WHEN extra IS NOT NULL THEN CONCAT(' ', extra)
					ELSE ''
				END,
                ',') txt
                FROM information_schema.columns
                WHERE table_schema = 'sakila' AND table_name = 'category'
                ORDER BY ordinal_position
			) cols
            UNION ALL
            SELECT')';

# Second attempt:
SELECT 'CREATE TABLE category (' create_table_statement
	UNION ALL
    SELECT cols.txt
		FROM
			(SELECT CONCAT(' ', column_name, ' ', column_type,
				CASE
					WHEN is_nullable= 'NO' THEN ' not null'
                    ELSE ''
				END, 
                CASE
					WHEN extra IS NOT NULL AND extra LIKE 'DEFAULT_GENERATED%'
						THEN CONCAT('DEFAULT ', column_default,substr(extra,18))
					WHEN extra IS NOT NULL THEN CONCAT(' ', extra)
					ELSE ''
				END,
                ',') txt
                FROM information_schema.columns
                WHERE table_schema = 'sakila' AND table_name = 'category'
                ORDER BY ordinal_position
			) cols
            UNION ALL
            SELECT CONCAT('	constrain primary key (')
				FROM information_schema.table_constraints
			WHERE table_schema = 'sakila' AND table_name = 'category'
				AND constraint_type = 'PRIMARY KEY'
			UNION ALL
            SELECT cols.txt
            FROM
				(SELECT CONCAT(CASE WHEN ordinal_position > 1 THEN'	,'
					ELSE'	'END, column_name)txt
				FROM information_schema.key_column_usage
                WHERE table_schema = 'sakila' AND table_name = 'category'
					AND constraint_name = 'PRIMARY'
				ORDER BY ordinal_position
                ) cols
			UNION ALL
		SELECT '	)'
	UNION ALL
SELECT ')';

CREATE TABLE category2 (
	category_id TINYINT(3) UNSIGNED NOT NULL auto_increment,
    name VARCHAR(25) NOT NULL ,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
		ON update CURRENT_TIMESTAMP,
	CONSTRAINT PRIMARY KEY (
	category_id
	)
);

# Deployment Verification
SELECT tbl.table_name,
	(SELECT COUNT(*)
		FROM information_schema.columns AS clm
	WHERE clm.table_schema = tbl.table_schema
		AND clm.table_name = tbl.table_name) AS num_columns,
	(SELECT COUNT(*)
		FROM information_schema.statistics AS sta
	WHERE sta.table_schema = tbl.table_schema
		AND sta.table_name = tbl.table_name) AS num_indexes,
	(SELECT COUNT(*)
		FROM information_schema.table_constraints AS tc
	WHERE tc.table_schema = tbl.table_schema
		AND tc.table_name = tbl.table_name
        AND tc.constraint_type = 'PRIMARY KEY') AS num_primary_keys
	FROM information_schema.tables AS tbl
WHERE tbl.table_schema = 'sakila' AND tbl.table_type = 'BASE TABLE'
ORDER BY 1;

# Dynamic SQL Generation
set @qry = 'SELECT customer_id, first_name, last_name FROM customer';
        
PREPARE dynsql1 FROM @qry;
        
EXECUTE dynsql1;

DEALLOCATE PREPARE dysql1;


SET @qry = 'SELECT customer_id, first_name, last_name FROM customer WHERE customer_id = ?';
            
PREPARE dynsql2 
	FROM@qry;

SET @custid = 9;

EXECUTE dynsql2 USING @custid;

SET @custid = 145;

EXECUTE dynsql2 USING @custid;

DEALLOCATE PREPARE dynsql2;

SELECT CONCAT('SELECT ',
	concat_ws(',', cols.col1, cols.col2, cols.col3, cols.col4,
    cols.col5, cols.col6, cols.col7, cols.col8, cols.col9),
    'FROM customer
	WHERE customer_id = ?')
INTO @qry
	FROM
    (SELECT
		MAX(CASE WHEN ordinal_position = 1 THEN column_name
			ELSE NULL END) col1,
		MAX(CASE WHEN ordinal_position = 2 THEN column_name
			ELSE NULL END) col2,
		MAX(CASE WHEN ordinal_position = 3 THEN column_name
			ELSE NULL END) col3,
		MAX(CASE WHEN ordinal_position = 4 THEN column_name
			ELSE NULL END) col4,
		MAX(CASE WHEN ordinal_position = 5 THEN column_name
			ELSE NULL END) col5,
		MAX(CASE WHEN ordinal_position = 6 THEN column_name
			ELSE NULL END) col6,
		MAX(CASE WHEN ordinal_position = 7 THEN column_name
			ELSE NULL END) col7,
		MAX(CASE WHEN ordinal_position = 8 THEN column_name
			ELSE NULL END) col8,
		MAX(CASE WHEN ordinal_position = 9 THEN column_name
			ELSE NULL END) col9
	FROM information_schema.columns
WHERE table_schema = 'sakila' AND table_name = 'customer'
GROUP BY table_name
) cols;

SELECT @qry;

PREPARE dynsql3 
	FROM @qry;

SET @custid = 45;

DEALLOCATE PREPARE dynsql3;