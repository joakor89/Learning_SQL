# Working with Large Databases

USE sakila;

# Index Partitioning

-- SELECT SUM(amount)
-- 	FROM sales
-- WHERE geo_region_cd = 'US'

# Partitioning Methods

DROP TABLE sales;

# Range partitioning
CREATE TABLE sales (
    sale_id INT NOT NULL,
    cust_id INT NOT NULL,
    store_id INT NOT NULL,
    sale_date DATE NOT NULL,
    amount DECIMAL(9, 2)
)
PARTITION BY RANGE (YEARWEEK(sale_date)) (
    PARTITION s1 VALUES LESS THAN (202002), 
    PARTITION s2 VALUES LESS THAN (202003),
    PARTITION s3 VALUES LESS THAN (202004),
    PARTITION s4 VALUES LESS THAN (202005),
    PARTITION s5 VALUES LESS THAN (202006),
    PARTITION s999 VALUES LESS THAN (MAXVALUE)
);
    
SELECT partition_name, partition_method, partition_expression
	FROM information_schema.partitions
WHERE table_name = 'sales'
ORDER BY partition_ordinal_position;

# reorganizing partitions
ALTER TABLE sales REORGANIZE PARTITION s999 INTO
    (PARTITION s6 VALUES LESS THAN (202007),
     PARTITION s7 VALUES LESS THAN (202008),
     PARTITION s999 VALUES LESS THAN MAXVALUE);

# re-checking metadata:
SELECT partition_name, partition_method, partition_expression
	FROM information_schema.partitions
WHERE table_name = 'sales'
ORDER BY partition_ordinal_position;

# adding rows:
INSERT INTO sales
	VALUES 
		(1, 1, 1, '2020-01-18', 2765.15),
        (2, 3, 4, '2020-02-07', 5322.08);

# applying subclause partition as follow:
SELECT CONCAT('# of rows in S1 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s1) UNION ALL
SELECT CONCAT('# of rows in S2 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s2) UNION ALL
SELECT CONCAT('# of rows in S3 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s3) UNION ALL
SELECT CONCAT('# of rows in S4 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s4) UNION ALL
SELECT CONCAT('# of rows in S5 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s5) UNION ALL
SELECT CONCAT('# of rows in S6 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s6) UNION ALL
SELECT CONCAT('# of rows in S7 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s7) UNION ALL
SELECT CONCAT('# of rows in S999 = ', COUNT(*)) PARTITION_ROWCOUNT
	FROM sales PARTITION (s999);

# List partitioning

# grouping values geographically as follow:
CREATE TABLE sales
	(sale_id INT NOT NULL,
     cust_id INT NOT NULL,
     store_id INT NOT NULL,
     sale_date DATE NOT NULL,
     geo_region_cd VARCHAR(6) NOT NULL,
     amount DECIMAL(9, 2)
     )
     
PARTITION BY LIST COLUMNS (geo_region_cd)
	(PARTITION NORTHAMERICA VALUES IN ('US_NE', 'US_SE', 'US_MW',
										'US_NW', 'US_SW', 'CAN', 'MEX'),
	PARTITION EUROPE VALUES IN ('EUR_E', 'EUR_W'),
    PARTITION ASIA VALUES IN ('CHN', 'JPN', 'IND')
    );

INSERT INTO sales 
	VALUES
    (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
    (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
    (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

ALTER TABLE sales REORGANIZE PARTITION ASIA INTO
	(PARTITION ASIA VALUES IN ('CHN', 'JPN', 'IND', 'KOR'));

SELECT partition_name, partition_method, partition_expression, partition_description
	FROM information_schema.partitions
WHERE table_name = 'sales'
ORDER BY partition_ordinal_position;

INSERT INTO sales 
	VALUES
    (1, 1, 1, '2020-01-18', 'US_NE', 2765.15),
    (2, 3, 4, '2020-02-07', 'CAN', 5322.08),
    (3, 6, 27, '2020-03-11', 'KOR', 4267.12);

# Hash partitioning
CREATE TABLE sales
	(sale_id INT NOT NULL,
     cust_id INT NOT NULL,
     store_id INT NOT NULL,
     sale_date DATE NOT NULL,
     geo_region_cd VARCHAR(6) NOT NULL,
     amount DECIMAL(9, 2)
     )

PARTITION BY HASH (cust_id)
PARTITIONS 4
		(PARTITION H1,
		 PARTITION H2,
         PARTITION H3,
         PARTITION H4
         );

INSERT INTO sales 
	VALUES
    (1, 1, 1, '2020-01-18', 1.1), (2, 3, 4, '2020-02-07', 1.2),
    (3, 17, 5, '2020-01-19', 1.3), (4, 23, 2, '2020-02-08', 1.4),
    (5, 56, 1, '2020-01-20', 1.6), (6, 77, 5, '2020-02-09', 1.7),
    (7, 122, 4, '2020-01-21', 1.8), (8, 153, 1, '2020-02-10', 1.9),
    (9, 179, 5, '2020-01-22', 2.0), (10, 244, 2, '2020-02-11', 2.1),
    (11, 263, 1, '2020-01-23', 2.2), (12, 312, 4, '2020-02-12', 2.3),
    (13, 346, 2, '2020-01-24', 2.4), (14, 389, 3, '2020-02-13', 2.5),
    (15, 472, 1, '2020-01-25', 2.6), (16, 502, 1, '2020-02-14', 2.7);
    
SELECT CONCAT('# of rows in H1 = ', count(*)) partition_rowcount
	FROM sales PARTITION (h1) UNION ALL
SELECT CONCAT('# of rows in H2 = ', count(*)) partition_rowcount
	FROM sales PARTITION (h2) UNION ALL
SELECT CONCAT('# of rows in H3 = ', count(*)) partition_rowcount
	FROM sales PARTITION (h3) UNION ALL
SELECT CONCAT('# of rows in H4 = ', count(*)) partition_rowcount
	FROM sales PARTITION (h4) UNION ALL

# cOMPOSITE partitioning













