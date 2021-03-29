DROP TABLE "ASSOCIATED_WITH" CASCADE CONSTRAINTS;
DROP TABLE "DISTRIBUTION_LOCATION" CASCADE CONSTRAINTS;
DROP TABLE "PEOPLE" CASCADE CONSTRAINTS;
DROP TABLE "HEALTHCARE_STAFF" CASCADE CONSTRAINTS;
DROP TABLE "ADMINISTERS" CASCADE CONSTRAINTS;
DROP TABLE "APPOINTMENTS" CASCADE CONSTRAINTS;
DROP TABLE "HEALTH_INSURANCE" CASCADE CONSTRAINTS;
DROP TABLE "DIAGNOSED" CASCADE CONSTRAINTS;
DROP TABLE "DISTRIBUTION_PHASE" CASCADE CONSTRAINTS;
DROP TABLE "VACCINE_TYPE" CASCADE CONSTRAINTS;
DROP TABLE "SIDE_EFFECTS" CASCADE CONSTRAINTS;
DROP TABLE "HAS_SIDE_EFFECT" CASCADE CONSTRAINTS;
DROP TABLE "ADDRESS" CASCADE CONSTRAINTS;
DROP TABLE "SUPPLIES" CASCADE CONSTRAINTS;
DROP TABLE "LOCATED" CASCADE CONSTRAINTS;
DROP TABLE "COMORBIDITIES" CASCADE CONSTRAINTS;
DROP TABLE "VACCINE_COMPANIES" CASCADE CONSTRAINTS;

/*----------------Create Table Vaccine_Type ------------------------*/
CREATE TABLE Vaccine_Type(
Vaccine_ID CHAR(20),
Vaccine_Name CHAR(20),
Number_Of_Doses INT,

PRIMARY KEY(Vaccine_ID),
UNIQUE(Vaccine_Name)
);


INSERT INTO Vaccine_Type VALUES('1','Pfizer','2');
INSERT INTO Vaccine_Type VALUES('2','Moderna','2');
INSERT INTO Vaccine_Type VALUES('3','Johnson','1');

select * from Vaccine_Type;

/*----------------Create Table Side_Effects ------------------------*/
Create Table Side_Effects (
side_effect_id CHAR(10),
side_effect CHAR(50),
PRIMARY KEY (side_effect_id));

INSERT INTO Side_Effects VALUES('1','Headache'); /* Remove proceeding zeroes */
INSERT INTO Side_Effects VALUES('2','Swelling');
INSERT INTO Side_Effects VALUES('3','Fever');
INSERT INTO Side_Effects VALUES('4','Muscle_Pain');
INSERT INTO Side_Effects VALUES('5','Chills');

select * from Side_Effects; /* Remove this */

/*----------------has_side_effect ------------------------*/
Create Table has_side_effect(
side_effect_id CHAR(10),
Vaccine_ID CHAR(20),
PRIMARY KEY (side_effect_id, Vaccine_ID),
Foreign Key (side_effect_id) REFERENCES Side_Effects (side_effect_id),
Foreign Key (Vaccine_ID) REFERENCES Vaccine_Type (Vaccine_ID));

INSERT INTO has_side_effect VALUES('1','1');
INSERT INTO has_side_effect VALUES('2','1');
INSERT INTO has_side_effect VALUES('3','1');
INSERT INTO has_side_effect VALUES('4','1');
INSERT INTO has_side_effect VALUES('5','1');
INSERT INTO has_side_effect VALUES('1','2');
INSERT INTO has_side_effect VALUES('2','2');
INSERT INTO has_side_effect VALUES('3','2');
INSERT INTO has_side_effect VALUES('4','2');
INSERT INTO has_side_effect VALUES('5','2');
INSERT INTO has_side_effect VALUES('1','3');
INSERT INTO has_side_effect VALUES('2','3');
INSERT INTO has_side_effect VALUES('3','3');
INSERT INTO has_side_effect VALUES('4','3');
INSERT INTO has_side_effect VALUES('5','3');

select * from has_side_effect;

/*----------------Create Table Vaccine_Companies ------------------------*/

CREATE TABLE Vaccine_Companies(
Company_ID CHAR(20),
Company_Name CHAR(20),
Contact_Name CHAR(20),
Contact_Email CHAR(20),
Phone CHAR(10),

PRIMARY KEY(Company_ID)
);

INSERT INTO Vaccine_Companies VALUES('P11','Pfizer-BioNTech','John','john1111@gmail.com', '2222222222');
INSERT INTO Vaccine_Companies VALUES('M22','ModernaTX','Amy','amy111@gmail.com', '1212121212');
INSERT INTO Vaccine_Companies VALUES('JJ33','Johnson','George', 'george111@gmail.com', '5544554455');

select * from Vaccine_Companies;

/*----------------Create Table Address ------------------------*/

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

INSERT INTO Address VALUES('1','235', 'East 42nd Street', 'New York', 'NY', 'USA', '10017');
INSERT INTO Address VALUES('2','200', 'Technology Square', 'Cambridge', 'MA', 'USA', '02139');
INSERT INTO Address VALUES('3','1', 'Johnson And Johnson Plaza', 'New Brunswick', 'NJ','USA', '08933');

INSERT INTO Address VALUES('4', NULL, '100 Institute Road', 'Worcester', 'MA', 'USA', '01609');
INSERT INTO Address VALUES('5', NULL, '85 East Concord Street', 'Boston', 'MA', 'USA', '02118');
INSERT INTO Address VALUES('6', NULL, '17 Corinth St', 'Roslindale', 'MA', 'USA', '02131');

select * from  Address;


/*----------------Create Table Supplies ------------------------*/

CREATE TABLE Supplies(
Vaccine_ID CHAR(20),
Company_ID CHAR(20),

PRIMARY KEY(Vaccine_ID, Company_ID),

Foreign Key(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID),
Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);

INSERT INTO Supplies VALUES('1','P11');
INSERT INTO Supplies VALUES('2','M22');
INSERT INTO Supplies VALUES('3','JJ33');


select * from Supplies ;

/*----------------Create Table Located ------------------------*/

CREATE TABLE Located(
Address_ID CHAR(20),
Company_ID CHAR(20),

PRIMARY KEY(Address_ID, Company_ID),

Foreign Key(Address_ID) REFERENCES Address(Address_ID),
Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);


INSERT INTO Located VALUES('1','P11');
INSERT INTO Located VALUES('2','M22');
INSERT INTO Located VALUES('3','JJ33');

select * from Located;

/*-------------------------------------------*/

CREATE TABLE Comorbidities(
  Disease_ID CHAR(20),
  Disease_name CHAR(50),
  Severity REAL,
  PRIMARY KEY (Disease_ID)
);

INSERT INTO Comorbidities VALUES('1', 'COPD', '5');
INSERT INTO Comorbidities VALUES('2', 'Asthma', '3');
INSERT INTO Comorbidities VALUES('3', 'Interstitial Lung Disease', '5');
INSERT INTO Comorbidities VALUES('4', 'Cystic Fibrosis', '4');
INSERT INTO Comorbidities VALUES('5', 'Cancer', '3');
INSERT INTO Comorbidities VALUES('6', 'Heart Failure', '3');


CREATE TABLE Distribution_Phase(
  Phase_number CHAR(20),
  Description VARCHAR2(4000),
  Start_date DATE,
  End_date DATE,
  PRIMARY KEY (Phase_number)
);

/* Make sure at least one has more than 3 months of duration */

INSERT INTO Distribution_Phase VALUES('1', 'This phase includes health care personnel (paid and unpaid), long-term care residents, first responders, congregate care settings, home-based health care workers and health care workers doing non-COVID-facing care.', To_DATE ('2020-12-01', 'yyyy-mm-dd'), To_DATE ('2021-02-01', 'yyyy-mm-dd'));

INSERT INTO Distribution_Phase VALUES('2', 'This phase includes people who are 55 or older, people with 2 or more certain medical conditions, people who live or work in low income and affordable senior housing, K-12 educators, K-12 school staff, and child care workers and certain workers.', To_DATE ('2021-2-2', 'yyyy-mm-dd'), To_DATE ('2021-4-18', 'yyyy-mm-dd'));

INSERT INTO Distribution_Phase VALUES('3', 'This phase includes everyone.', To_DATE ('2021-4-18', 'yyyy-mm-dd'), To_DATE('2022-1-1', 'yyyy-mm-dd'));

CREATE TABLE associated_with(
  Disease_ID CHAR(20),
  Phase_number CHAR(20),
  PRIMARY KEY (Disease_ID, Phase_number),
  FOREIGN KEY (Disease_ID) REFERENCES Comorbidities(Disease_ID),
  FOREIGN KEY (Phase_number) REFERENCES Distribution_Phase(Phase_number)
);

INSERT INTO associated_with VALUES('1', '1');
INSERT INTO associated_with VALUES('3', '1');
INSERT INTO associated_with VALUES('4', '1');
INSERT INTO associated_with VALUES('2', '2');
INSERT INTO associated_with VALUES('5', '2');
INSERT INTO associated_with VALUES('6', '2');

CREATE TABLE Distribution_Location(
  Location_ID CHAR(20),
  Location_name CHAR(50),
  Capacity REAL,
  Located CHAR(20) NOT NULL,
  PRIMARY KEY (Location_ID),
  FOREIGN KEY (Located) REFERENCES Address(Address_ID)
);

INSERT INTO Distribution_Location VALUES('1', 'WPI', 100, '4');
INSERT INTO Distribution_Location VALUES('2', 'Boston Medical Center', 2000, '5');
INSERT INTO Distribution_Location VALUES('3', 'Roslindale COVID-19 Vaccination Site', 50, '6');


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

Create table Healthcare_Staff(
SSN CHAR(9),
Job_Title CHAR(50),
PRIMARY KEY (SSN),
Foreign key (SSN) REFERENCES People (SSN) ON DELETE CASCADE);


/*----------------Create Table Administers ------------------------*/

CREATE TABLE Administers(
SSN CHAR(9),
Vaccine_ID CHAR(20),

PRIMARY KEY(SSN, Vaccine_ID),

FOREIGN KEY(SSN) REFERENCES Healthcare_Staff(SSN),
FOREIGN KEY(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID)
);


CREATE TABLE Appointments(
  Appt_ID CHAR(20),
  Appt_date DATE,
  Located CHAR(20) NOT NULL,
  is_part_of CHAR(20) NOT NULL,
  SSN CHAR(9),
  Vaccine_ID CHAR(20),
  PRIMARY KEY (Appt_ID),
  FOREIGN KEY (Located) REFERENCES Distribution_Location(Location_ID),
  FOREIGN KEY (is_part_of) REFERENCES Distribution_Phase(Phase_number),
  FOREIGN KEY (SSN) REFERENCES People(SSN),
  FOREIGN KEY (Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID)
);

INSERT INTO Appointments VALUES ('1', To_DATE('2020-12-10', 'yyyy-mm-dd'), '2', '1', NULL, '1');
INSERT INTO Appointments VALUES ('2', To_DATE('2020-12-10', 'yyyy-mm-dd'), '2', '1', NULL, '1');
INSERT INTO Appointments VALUES ('3', To_DATE('2020-12-16', 'yyyy-mm-dd'), '3', '1', NULL, '2');

INSERT INTO Appointments VALUES ('4', To_DATE('2021-03-01', 'yyyy-mm-dd'), '3', '2', NULL, '1');
INSERT INTO Appointments VALUES ('5', To_DATE('2021-03-02', 'yyyy-mm-dd'), '3', '2', NULL, '1');
INSERT INTO Appointments VALUES ('6', To_DATE('2021-03-03', 'yyyy-mm-dd'), '3', '2', NULL, '2');

INSERT INTO Appointments VALUES ('7', To_DATE('2021-05-10', 'yyyy-mm-dd'), '1', '3', NULL, '3');
INSERT INTO Appointments VALUES ('8', To_DATE('2021-05-10', 'yyyy-mm-dd'), '1', '3', NULL, '3');
INSERT INTO Appointments VALUES ('9', To_DATE('2021-07-16', 'yyyy-mm-dd'), '1', '3', NULL, '3');

Create table Health_Insurance (
Insurance_Number CHAR(25),
SSN CHAR(9) NOT NULL,
Insurance_Company CHAR(25),
covid_coverage CHAR(1),
expiration_date DATE,
PRIMARY KEY (Insurance_Number),
Unique (SSN),
Foreign key (SSN) REFERENCES People (SSN));


Create table Diagnosed (
SSN CHAR(9),
Disease_ID CHAR(20),
PRIMARY KEY (SSN, Disease_ID),
Foreign key (SSN) REFERENCES People (SSN),
Foreign key (Disease_ID) REFERENCES Comorbidities (Disease_ID));
