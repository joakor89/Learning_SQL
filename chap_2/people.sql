CREATE TABLE person
(
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    eye_color ENUM('BR', 'BL', 'GR'),
    birth_date DATE,
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

CREATE TABLE favorite_food
(
	person_id SMALLINT UNSIGNED,
	food VARCHAR(20),
	CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
	CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
	REFERENCES person (person_id)
);

# Populating & Modifying Tables
# Generating numeric key data

ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;

SET foreign_key_checks=0;
ALTER TABLE person
	MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;
SET foreign_key_checks=1;

# Insert statement

INSERT INTO person
(person_id, fname, lname, eye_color, birth_date)
VALUES (null, 'Willian', 'Turner', 'BR', '1972-05-27');

SELECT person_id, fname, lname, birth_date
FROM person;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE person_id = 1;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE lname = 'Turner';

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'nachos');

SELECT food
FROM favorite_food
WHERE person_id = 1
ORDER BY food;

INSERT INTO person
(person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES (null, 'Susan', 'Smith', 'BL', '1975-11-02', '23 Maple st', 'Arlington', 'VA', 'USA', '20220');

SELECT person_id, fname, lname, birth_date
FROM person;

# Updating Data

UPDATE person
SET street = '1225 Tremont St.',
	city = 'Boston',
    state = 'MA',
    country = 'USA',
    postal_code='02138'
WHERE person_id = 1

# Deleting Data

DELETE FROM person
WHERE person_id = 2;

INSERT INTO person
(person_id, fname, lname, eye_color, birth_date)
VALUES (1, 'Charles', 'Fulton', 'GR', '1968-01-15');

# Nonexistent Foreign Key

INSERT INTO favorite_food (person_id, food)
VALUES (999, 'lasagna')

# Column Violations

UPDATE person
	SET eye_color = 'ZZ'
    WHERE person_id =1;

# Invalid Date Conversions

UPDATE person
	SET birth_date = 'DEC-21-1980'
    WHERE person_id = 1;

UPDATE person
	SET birth_date = str_to_date('DEC-21-1980', '%b-%d-%Y')
    WHERE person_id = 1;






