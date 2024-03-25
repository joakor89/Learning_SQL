# SQL & Big Data

-- Note: for the task performed here, You must install APACHE DRILL

USE sakila;

# Introduction to Apache Drill

SELECT file_name, is_directory, is_file, permision
	FROM information_schema.`files`
WHERE schema_name = 'dfs.data';

# retrieving column's anme and information:
SELECT *
	FROM dfs.data.`attack-trace.pcap`
WHERE 1=2;

# checking on IP address:
SELECT src_ip, dst_port,
		COUNT(*) AS packet_count
	FROM dfs.data.`attack-trace.pcap`
GROUP BY src_ip, dst_port;

# aggregating packets
-- Note: using backstick on timestamp since it's a reserved word
SELECT TRUNC(EXTRACT(SECOND FROM `timestamp`)) AS packet_time,
		COUNT(*) AS num_packets,
        SUM(packet_length) AS tot_volume
	FROM dfs.data.`attack-trace.pcap`
GROUP BY TRUNC(EXTRACT(SECOND FROM `timestamp`));

# Querying MySQL using Drill

USE mysql.sakila;

SHOW tables;

SELECT a.address_id, a.address, ct.city
	FROM address AS a
		INNER JOIN city AS ct
			ON a.cityd_id = ct.city_id
WHERE a.district = 'California';

# checking with group by and having:
SELECT fa.actor_id, f.rating, 
		COUNT(*) AS num_films
	FROM film_actor AS fa
		INNER JOIN film AS f
        ON fa.film_id = f.film_id
WHERE f.rating IN ('G', 'PG')
GROUP BY fa.actor_id, f.rating
HAVING COUNT(*) > 9;

# checking on ranks as follow:
SELECT customer_id, COUNT(*) AS num_rentals,
		ROW_NUMBER()
			OVER (ORDER BY COUNT(*) DESC)
				AS row_number_rnk,
		RANK() 
			OVER (ORDER BY COUNT(*) DESC) AS rank_rnk,
		DENSE_RANK()
			OVER (ORDER BY COUNT(*) DESC)
				AS desnse_rank_rnk
	FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

# Querying MongoDB using Drill

# setting JSON file structure as follow:
{"id":1,
"Actors":[
{"First name":"PENELOPE", "Last name": "GUINESS", "actorID":1},
{"First name":"CHRISTIAN", "Last name": "GABLE", "actorID":10},
{"First name":"LUCILLE", "Last name": "TRACY", "actorID":20},
{"First name":"SANDRA", "Last name": "PECK", "actorID":30},
{"First name":"JOHNNY", "Last name": "CAGE", "actorID":40},
{"First name":"MENA", "Last name": "TEMPLE", "actorID":53},
{"First name":"WARREN", "Last name": "NOLTE", "actorID":108},
{"First name":"OPRAH", "Last name": "KILMER", "actorID":162},
{"First name":"ROCK", "Last name": "DUKAKIS", "actorID":188},
{"First name":"MARY", "Last name": "KEITEL", "actorID":198},
"Category": "Documentary",
"Description":"A Epic drama of a feminist and a mad scientist
	who must battle a teacher in the canadian rockies",
"Length": "86",
"Rating":"PG",
"Rental Duration":"6",
"Replacement Cost": "20.99",
"Special Features":"Deleted scenes, behind the scenes",
"Title":"ACADEMY DINOSAUR"},

{"id":2,
"Actors":[
{"First name":"Bob", "Last name": "FAWCETT", "actorID":19},
{"First name":"MINNIE", "Last name": "ZELLWEGER", "actorID":10},
{"First name":"SEAN", "Last name": "GUINESS", "actorID":1},
{"First name":"CHRIS", "Last name": "DEPP", "actorID":1},
"Category": "Horror",
"Description":"A astounding epistle of a database administrator
	and a explorer who must find a car in ancient china",
"Length": "48",
"Rating":"G",
"Rental Duration":"3",
"Replacement Cost": "12.99",
"Special Features":"Trailers, deleted scenes",
"Title":"ACE GOLDFINGER"},

{"id":999,
"Actors":[
{"First name":"CARMER", "Last name": "HUNT", "actorID":52},
{"First name":"MARY", "Last name": "TANDY", "actorID":66},
{"First name":"PENELOPE", "Last name": "CRONYN", "actorID":104},
{"First name":"WHOOPI", "Last name": "HURT", "actorID":140},
{"First name":"JADA", "Last name": "RYDER", "actorID":142},
"Category": "Children",
"Description":"A fateful reflection of a waitress and a boat
	who must discover a sumo wrestler in ancient china",
"Length": "101",
"Rating":"R",
"Rental Duration":"5",
"Replacement Cost": "28.99",
"Special Features":"Trailers, deleted scenes",
"Title":"ZOOLANDER FICTION"},

{"id":1000,
"Actors":[
{"First name":"IAN", "Last name": "TANDY", "actorID":155},
{"First name":"NICK", "Last name": "DEGENERES", "actorID":166},
{"First name":"LISA", "Last name": "MONROE", "actorID":1178},

"Category": "Comedy",
"Description":"A intrepid panorama of a mad scientist and a boy
	who must redeem a boy in a monastery",
"Length": "50",
"Rating":"NC-17",
"Rental Duration":"3",
"Replacement Cost": "18.99",
"Special Features":"Trailers, Commentaries, Behind the Scenes",
"Title":"ZORRO ARK"}


{"_id":1,
"Address":"1912 Hanoi Way",
"City":"Sasebo",
"Country":"Japan",
"District":"Nagasaki",
"First Name":"Mary",
"Last Name":"SMITH",
"Phone":"28303384290",
"Rentals":[
{"rentalID"1185,
"filmID":611,
"staffId":2,
"Film Ttile":"MUSKETEERS WAIT",
"Payments":[
{"Payment Id":3, "Amount":5.99, "Payment Date":"2005-06-15 00:54:12"}],
"Return Date":"2005-06-15 00:54:12.0",
"Return Date":"2005-06-23 02:42:12.0"},

{"rentalId":1476,
"filmId":308,
"staffId":1,
"Film Title": "FERRIS MOTHER",
"Payments":[
{"Payment Id":5, "Amount":9.99, "Payment Date": "2005-06-15 21:08:46"}],
"Rental Date":"2005-06-15 21:08:46.0",
"Return Date": 2005-06-25 02:26:46.0},
...
{"rentalId":14825,
"filmId":317,
"staffId":2,
"Film Titlte": "FIREBALL PHILADELPHIA",
"Payments":[
	{"Payment Id":30, "Amount":1.99, "Payment Date":"2005-08-22 01:27:57"}],
    "Rental Date":"2005-08-22 01:27:57.0",
    "Return Date":"2005-08-27 07:01:57.0"}
	]
}

SELECT rating, Actors
	FROM films
WHERE Rating IN ('G', 'PG');


SELECT f.Rating, flatten(Actors) AS actor_list
	FROM films AS f
WHERE f.Rating IN ('G', 'PG');


SELECT g_pg_films.Rating,
	g_pg_films.actor_list.`First name` first_name,
	g_pg_films.actor_list.`Last namer` last_name,
    COUNT(*) AS num_films
	FROM
		(SELECT f.Rating, flatten(Actors) AS actor_list
			FROM films AS f
            WHERE f.Rating IN ('G', 'PG')
            ) AS g_pg_films
GROUP BY g_pg_films.Rating,
		g_pg_films.actor_list.`First name` first_name,
		g_pg_films.actor_list.`Last namer` last_name,

HAVING COUNT(*) > 9;

# Querying on MongoDB:
SELECT first_name, last_name,
		SUM(CAST(cust_payments.payment_data.Amount
			AS DECIMAL(4, 2))) AS tot_payments
	FROM
		(SELECT cust_data.first_name,
			cust_data.last_name,
            f.Rating,
            flatten(cust_data.rental_data.Payments)
				AS payment_data
			FROM film AS f
				INNER JOIN
                (SELECT c.`First Name` first name,
                c.`Last name` last_name,
                flatten(c.Rentals) rental_data
					FROM customer AS c
				) AS cust_data
				ON  f._id = cust_data.rental_data.filmID
				WHERE f.Rating IN ('G', 'PG')
                ) AS cust_payments
	GROUP BY first_name, last_name
HAVING
	SUM(CAST(cust_payments.payment_data.Amount
			AS decimal(4,2))) > 80;
            


