# Analytic Functions

USE sakila;

# Data Window

SELECT QUARTER(payment_date) AS quarter,
		MONTHNAME(payment_date) AS month_nm,
        SUM(amount) AS month_sales
	FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

# Additional calculations as:
SELECT QUARTER(payment_date) AS quarter,
		MONTHNAME(payment_date) AS month_nm,
        SUM(amount) AS month_sales,
        MAX(SUM(amount))
			OVER() AS max_overall_sales,
		MAX(SUM(amount))
			OVER (PARTITION BY QUARTER(payment_date)) AS max_qrtr_sales
	FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

# Localized Sorting

SELECT QUARTER(payment_date) AS quarter,
		MONTHNAME(payment_date) AS month_nm,
        SUM(amount) AS month_sales,
        RANK() OVER (ORDER BY SUM(amount) desc) AS sales_rank
	FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, 2;

# adding partition within rank() function as follow:
# Note: this approach is restricted by the database, then below this snippet a ran out a new one in order
# to avoid DB external changes and keep working as usual. You can check documentarym if need so:
SELECT QUARTER(payment_date) AS quarter,
		MONTHNAME(payment_date) AS month_nm,
        SUM(amount) AS month_sales,
        RANK() OVER (PARTITION BY QUARTER(payment_date)
			ORDER BY SUM(amount) desc) AS qrt_sales_rank
	FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, MONTH(payment_date);

# eventual approach
SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) AS month_sales,
       RANK() OVER (PARTITION BY QUARTER(payment_date)
                    ORDER BY SUM(amount) DESC) AS qrt_sales_rank,
       MONTH(payment_date) AS month_num
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date), MONTH(payment_date) 
ORDER BY quarter, month_num; 

# Rankings
# Ranking Fucntions

SELECT customer_id, COUNT(*) AS num_rentals
	FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

SELECT customer_id, COUNT(*) AS num_rentals,
		ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS row_number_rnk,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_rnk,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS dense_rank_rnk
	FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

# Generating Multiple Rankings

SELECT customer_id,
		MONTHNAME(rental_date) AS rental_month,
		COUNT(*) AS num_rentals
	FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

# adding ranks
SELECT customer_id,
		MONTHNAME(rental_date) AS rental_month,
		COUNT(*) AS num_rentals,
        RANK() OVER (PARTITION BY MONTHNAME(rental_date)
			ORDER BY COUNT(*) DESC) AS rank_rnk
	FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

# wrapping within a subquery as follow:
SELECT customer_id, rental_month, num_rentals,
		rank_rnk AS ranking
	FROM
		(SELECT customer_id,
		MONTHNAME(rental_date) AS rental_month,
		COUNT(*) AS num_rentals,
        RANK() OVER (PARTITION BY MONTHNAME(rental_date)
			ORDER BY COUNT(*) DESC) AS rank_rnk
	FROM rental
		GROUP BY customer_id, MONTHNAME(rental_date)
		) AS cust_rankings
WHERE rank_rnk <= 5
ORDER BY 2, 3 DESC;

# Reporting Functions

SELECT MONTHNAME(payment_date) AS payment_month,
		amount,
		SUM(amount)
			OVER (PARTITION BY MONTHNAME(payment_date)) AS monthly_total,
		SUM(amount) OVER () AS grand_total
	FROM payment
WHERE amount >= 10
ORDER BY 1;

#
SELECT MONTHNAME(payment_date) AS payment_month, 
		SUM(amount) AS month_total,
        ROUND(SUM(amount) / SUM(SUM(amount)) OVER ()
			* 100, 2) AS pct_of_total
	FROM payment
GROUP BY MONTHNAME(payment_date);

SELECT MONTHNAME(payment_date) AS payment_month, 
		SUM(amount) AS month_total,
        CASE SUM(amount)
			WHEN MAX(SUM(amount)) OVER () THEN 'Highest'
            WHEN MAX(SUM(amount)) OVER () THEN 'Lowest'
            ELSE 'Middle'
		END AS descriptor
	FROM payment
GROUP BY MONTHNAME(payment_date);

# Window Frames

# calculating rolling sum
SELECT YEARWEEK(payment_date) AS payment_week,
		SUM(amount) AS week_total,
        SUM(SUM(amount))
			OVER (ORDER BY YEARWEEK(payment_date)
				ROWS UNBOUNDED PRECEDING) AS rolling_sum
	FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

# calculating rolling average
SELECT YEARWEEK(payment_date) AS payment_week,
		SUM(amount) AS week_total,
        AVG(SUM(amount))
			OVER (ORDER BY YEARWEEK(payment_date)
				ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_3wk_avg
	FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

# specifying window range:
SELECT DATE(payment_date), SUM(amount), 
		AVG(SUM(amount)) OVER (ORDER BY DATE(payment_date)
			RANGE BETWEEN INTERVAL 3 DAY PRECEDING
				AND INTERVAL 3 DAY FOLLOWING) 7_day_avg
	FROM payment
WHERE payment_date BETWEEN '2005-07-01' AND '2005-09-01'
GROUP BY DATE(payment_date)
ORDER BY 1;

# Lag & Lead

SELECT YEARWEEK(payment_date) AS payment_week,
		SUM(amount) AS week_total,
        LAG(SUM(amount), 1)
			OVER (ORDER BY YEARWEEK(payment_date)) AS prev_wk_tot,
		LEAD(SUM(amount), 1)
			OVER (ORDER BY YEARWEEK(payment_date)) as next_wk_tot
	FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

SELECT YEARWEEK(payment_date) AS payment_week,
		SUM(amount) AS week_total,
        ROUND((SUM(amount) - LAG(SUM(amount), 1)
			OVER (ORDER BY YEARWEEK(payment_date)))
            / LAG(sum(amount), 1)
            OVER (ORDER BY YEARWEEK(payment_date))
            * 100, 1) AS pct_diff
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1; 

# Column Value Concatenation

SELECT f.title,
		group_concat(a.last_name ORDER BY a.last_name 
			SEPARATOR ', ') AS actors
	FROM actor AS a
		INNER JOIN film_actor AS fa
			ON a.actor_id = fa.actor_id
		INNER JOIN film AS f
			ON fa.film_id = f.film_id
GROUP BY f.title
HAVING COUNT(*) = 3;




