# Transactions

USE sakila;

# What is a Transaction?

START TRANSACTION;

-- /*withdraw money 
-- 	FROM first account, making sure balance is sufficient*/
-- 		UPDATE account
-- 			SET avail_balance = avail_balance - 500
-- 		WHERE account_id = 9988
-- 			AND avail_balance > 500

-- IF <exactly one row was updated by the previous statement> THEN
-- 	/*deposit money into second account*/
-- UPDATE account SET avail_balance = avail_balance + 500
-- 	WHERE account_id = 9988;
--     
-- IF <exactly one row was updated by the previous statement> THEN
-- 	/*everything worked, make the changes permanent*/
-- 	COMMIT;
-- ELSE
-- /*something went wrong, undo all changes in this transaction*/
-- 		ROLLBACK;
-- 	END IF;
-- ELSE
-- 	/* insufficient funds, or error encountered during update*/
-- 		ROLLBACK;
-- END IF;

# Starting a Transaction

-- SET IMPLICIT_TRANSACTIONS ON

-- SET AUTOCOMMIT=0

SHOW TABLE STATUS LIKE 'customer';

# only if necessary, then apply:
-- ALTER TABLE customer ENGINE = INNODB;

SAVEPOINT my_savepoint;

-- START TRANSACTION;

-- UPDATE product
-- 	SET date_retired = CURRENT_TIMESTAMP()
-- WHERE product_cd = 'XYZ';

-- SAVEPOINT before_close_accounts;

-- UPDATE account
-- 	SET status = 'CLOSED', close_date = CURRENT_TIMESTAMP(),
-- 		last_activity_date = CURRENT_TIMESTAMP()
-- WHERE product_cd = 'XYZ';

-- ROLLBACK TO SAVEPOINT before_close_accounts;
-- COMMIT;











