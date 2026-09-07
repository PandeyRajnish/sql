--DDL


-- Create Table
CREATE TABLE users (
	id INT NOT NULL,
	user_name VARCHAR(50),
	birth_date DATE,
	mob_no VARCHAR (15)
	CONSTRAINT pk_users PRIMARY KEY (id)
)

-- Alter Table ( add column, remove column)
ALTER TABLE users 
ADD email VARCHAR (50)

-- Remove Column
ALTER TABLE users
DROP COLUMN email

SELECT * FROM users;

-- Change the datatype of a column
ALTER TABLE users
ALTER COLUMN mob_no INT NOT NULL



ALTER TABLE persons
ADD email VARCHAR (50) NOT NULL

ALTER TABLE persons
DROP COLUMN phone

SELECT * FROM persons;

-- DROP 
DROP TABLE users;