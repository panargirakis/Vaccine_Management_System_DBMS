DROP TABLE if exists post;
DROP TABLE if exists user1;
DROP TABLE if exists People;
DROP TABLE if exists Address;
DROP TABLE if exists Distribution_Phase;
DROP TABLE if exists Healthcare_Staff;


CREATE TABLE user1 (
  id INTEGER,
  username CHAR(100) UNIQUE NOT NULL,
  password CHAR(100) NOT NULL,
  primary key (id)
);

CREATE TABLE post (
  id INTEGER,
  author_id INTEGER NOT NULL,
  created TIMESTAMP NOT NULL,
  title CHAR(100) NOT NULL,
  body CHAR(100) NOT NULL,
  primary key (id),
  FOREIGN KEY (author_id) REFERENCES user1 (id)
);








CREATE TABLE Distribution_Phase(
  Phase_number CHAR(20),
  Description VARCHAR2(4000),
  Start_date DATE,
  End_date DATE,
  PRIMARY KEY (Phase_number)
);

/* INSERT INTO Distribution_Phase VALUES('3', 'This phase includes everyone.', To_DATE ('2021-4-18', 'yyyy-mm-dd'), To_DATE('2022-1-1', 'yyyy-mm-dd')); */




CREATE TABLE Address(
Address_ID CHAR(20),
Apartment CHAR(50),
Street CHAR(50),
City CHAR(50),
State CHAR(50),
Country CHAR(50),
Zip_Code CHAR(50),


PRIMARY KEY(Address_ID)
);

/* INSERT INTO Address VALUES('1','235', 'East 42nd Street', 'New York', 'NY', 'USA', '10017'); */

Create table People(
SSN CHAR(9),
name CHAR(50),
occupation CHAR(50),
username CHAR(15),
password CHAR(15),
email_address CHAR(25),
age REAL,
address_id CHAR(20) NOT NULL,
phase_number CHAR(20) NOT NULL,
PRIMARY KEY (SSN),
Unique(username),
Unique (password),
Unique (email_address),
Foreign key (address_id) REFERENCES Address (address_id),
Foreign key (phase_number) REFERENCES Distribution_Phase (phase_number));

/* insert into People Values ('147258369', 'Joe Wild', 'contractor', 'jwild1', 'password13', 'jwild1@gmail.com', 52, '1', '3'); */

Create table Healthcare_Staff(
SSN CHAR(9),
Job_Title CHAR(50),
PRIMARY KEY (SSN),
Foreign key (SSN) REFERENCES People (SSN) ON DELETE CASCADE);

