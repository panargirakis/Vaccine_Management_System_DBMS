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
Vaccine_ID VARCHAR(20),
Vaccine_Name VARCHAR(20),
Number_Of_Doses INT,

PRIMARY KEY(Vaccine_ID),
UNIQUE(Vaccine_Name)
);


INSERT INTO Vaccine_Type VALUES('1','Pfizer','2');
INSERT INTO Vaccine_Type VALUES('2','Moderna','2');
INSERT INTO Vaccine_Type VALUES('3','Johnson','1');


/*----------------Create Table Side_Effects ------------------------*/
Create Table Side_Effects (
side_effect_id VARCHAR(10),
side_effect VARCHAR(50),
PRIMARY KEY (side_effect_id));

INSERT INTO Side_Effects VALUES('1','Headache'); /* Remove proceeding zeroes */
INSERT INTO Side_Effects VALUES('2','Swelling');
INSERT INTO Side_Effects VALUES('3','Fever');
INSERT INTO Side_Effects VALUES('4','Muscle_Pain');
INSERT INTO Side_Effects VALUES('5','Chills');


/*----------------has_side_effect ------------------------*/
Create Table has_side_effect(
side_effect_id VARCHAR(10),
Vaccine_ID VARCHAR(20),
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


/*----------------Create Table Vaccine_Companies ------------------------*/

CREATE TABLE Vaccine_Companies(
Company_ID VARCHAR(20),
Company_Name VARCHAR(20),
Contact_Name VARCHAR(20),
Contact_Email VARCHAR(20),
Phone VARCHAR(10),

PRIMARY KEY(Company_ID)
);

INSERT INTO Vaccine_Companies VALUES('P11','Pfizer-BioNTech','John','john1111@gmail.com', '2222222222');
INSERT INTO Vaccine_Companies VALUES('M22','ModernaTX','Amy','amy111@gmail.com', '1212121212');
INSERT INTO Vaccine_Companies VALUES('JJ33','Johnson','George', 'george111@gmail.com', '5544554455');


/*----------------Create Table Address ------------------------*/

CREATE TABLE Address(
Address_ID VARCHAR(20),
Apartment VARCHAR(50),
Street VARCHAR(50),
City VARCHAR(50),
State VARCHAR(50),
Country VARCHAR(50),
Zip_Code VARCHAR(50),


PRIMARY KEY(Address_ID)
);

INSERT INTO Address VALUES('1','235', 'East 42nd Street', 'New York', 'NY', 'USA', '10017');
INSERT INTO Address VALUES('2','200', 'Technology Square', 'Cambridge', 'MA', 'USA', '02139');
INSERT INTO Address VALUES('3','1', 'Johnson And Johnson Plaza', 'New Brunswick', 'NJ','USA', '08933');
INSERT INTO Address VALUES('4', NULL, '4 Mirick Rd', 'Princeton', 'MA', 'USA', '01541');
INSERT INTO Address VALUES('5', NULL, '5 N Sturbridge Rd', 'Charlton', 'MA', 'USA', '01507');
INSERT INTO Address VALUES('6', NULL, '6 Mount Auburn St', 'Watertown', 'MA', 'USA', '02427');
INSERT INTO Address VALUES('7', NULL, '7 Neilson Rd', 'New Salem', 'MA', 'USA', '03155');
INSERT INTO Address VALUES('8', NULL, '88 Reservoir Rd', 'Coventry', 'RI', 'USA', '02816');
INSERT INTO Address VALUES('9', NULL, '101 Gaulin Ave', 'Woonsocket', 'RI', 'USA', '02895');
INSERT INTO Address VALUES('10', NULL, '200 Aldrich St', 'Wyoming', 'RI', 'USA', '02898');
INSERT INTO Address VALUES('11', NULL, '17 Morril Ln', 'Providence', 'RI', 'USA', '02904');
INSERT INTO Address VALUES('12', NULL, '25 Conifer Rd', 'Rindge', 'NH', 'USA', '03461');
INSERT INTO Address VALUES('13', NULL, '23 Wentworth Ave', 'Plaistow', 'NH', 'USA', '03865');
INSERT INTO Address VALUES('14', NULL, '20 Varney Point Rd', 'Gilford', 'NH', 'USA', '03249');
INSERT INTO Address VALUES('15', NULL, '41 Hixville Rd', 'North Dartmouth', 'MA', 'USA', '02747');
INSERT INTO Address VALUES('16', NULL, '1000 Clark St', 'New Bedford', 'MA', 'USA', '02740');
INSERT INTO Address VALUES('17', NULL, '26 Main St', 'Acushnet', 'MA', 'USA', '02743');

INSERT INTO Address VALUES('18', NULL, '100 Institute Road', 'Worcester', 'MA', 'USA', '01609');
INSERT INTO Address VALUES('19', NULL, '85 East Concord Street', 'Boston', 'MA', 'USA', '02118');
INSERT INTO Address VALUES('20', NULL, '17 Corinth St', 'Roslindale', 'MA', 'USA', '02131');



/*----------------Create Table Supplies ------------------------*/

CREATE TABLE Supplies(
Vaccine_ID VARCHAR(20),
Company_ID VARCHAR(20),

PRIMARY KEY(Vaccine_ID, Company_ID),

Foreign Key(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID),
Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);

INSERT INTO Supplies VALUES('1','P11');
INSERT INTO Supplies VALUES('2','M22');
INSERT INTO Supplies VALUES('3','JJ33');


/*----------------Create Table Located ------------------------*/

CREATE TABLE Located(
Address_ID VARCHAR(20),
Company_ID VARCHAR(20),

PRIMARY KEY(Address_ID, Company_ID),

Foreign Key(Address_ID) REFERENCES Address(Address_ID),
Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);


INSERT INTO Located VALUES('1','P11');
INSERT INTO Located VALUES('2','M22');
INSERT INTO Located VALUES('3','JJ33');



/*-------------------------------------------*/

CREATE TABLE Comorbidities(
  Disease_ID VARCHAR(20),
  Disease_name VARCHAR(50),
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
  Phase_number VARCHAR(20),
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
  Disease_ID VARCHAR(20),
  Phase_number VARCHAR(20),
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
  Location_ID VARCHAR(20),
  Location_name VARCHAR(50),
  Capacity REAL,
  Located VARCHAR(20) NOT NULL,
  PRIMARY KEY (Location_ID),
  FOREIGN KEY (Located) REFERENCES Address(Address_ID)
);

INSERT INTO Distribution_Location VALUES('1', 'WPI', 100, '18');
INSERT INTO Distribution_Location VALUES('2', 'Boston Medical Center', 2000, '19');
INSERT INTO Distribution_Location VALUES('3', 'Roslindale COVID-19 Vaccination Site', 50, '20');


Create table People(
SSN VARCHAR(9),
name VARCHAR(50),
occupation VARCHAR(50),
username VARCHAR(15),
password VARCHAR(15),
email_address VARCHAR(25),
age REAL,
address_id VARCHAR(20) NOT NULL,
phase_number VARCHAR(20) NOT NULL,
PRIMARY KEY (SSN),
Unique(username),
Unique (password),
Unique (email_address),
Foreign key (address_id) REFERENCES Address (address_id),
Foreign key (phase_number) REFERENCES Distribution_Phase (phase_number));

insert into People Values ('147258369', 'Joe Wild', 'contractor', 'jwild1', 'password13', 'jwild1@gmail.com', 52, '15', '3');
insert into People Values ('741852963', 'Jim Hendrix', 'musician', 'jhendrix1', 'password14', 'jhendrix1@gmail.com', 32, '16', '3');
insert into People Values ('951753825', 'Aubrey West', 'teacher', 'awest1', 'password0', 'awest1@gmail.com', 34, '17', '2');

insert into People Values ('123456789', 'Jane Doe', 'nurse', 'jdoe1', 'password1', 'jdoe1@gmail.com', 50, '4', '1');
insert into People Values ('987654321', 'John Doe', 'physician', 'jdoe2', 'password2', 'jdoe2@gmail.com', 55, '5', '1');
insert into People Values ('111111111', 'Ben Johnson', 'volunteer', 'bjohnson1', 'password3', 'bjohnson1@gmail.com', 60, '6', '1');
insert into People Values ('222222222', 'Peter Smith', 'nursing student', 'psmith1', 'password4', 'psmith1@gmail.com', 25, '6', '1');
insert into People Values ('333333333', 'Jack Black', 'nurse', 'jblack1', 'password5', 'jblack1@gmail.com', 35, '8', '1');
insert into People Values ('444444444', 'Tom Johnston', 'pharmacist', 'tjohnston1', 'password6', 'tjohnston1@gmail.com', 45, '9', '1');
insert into People Values ('555555555', 'Bill Smithers', 'nurse', 'bsmithers1', 'password7', 'bsmithers1@gmail.com', 40, '10', '1');
insert into People Values ('666666666', 'Jan Moon', 'physician', 'jmoon1', 'password8', 'jmoon1@gmail.com', 55, '11', '1');
insert into People Values ('777777777', 'Jeff Frost', 'retired physician', 'jfrost1', 'password9', 'jfrost1@gmail.com', 70, '12', '1');
insert into People Values ('888888888', 'Jim Blake', 'dentist', 'jblake1', 'password10', 'jblake1@gmail.com', 38, '13', '1');
insert into People Values ('999999999', 'Nick Jones', 'nurse', 'njones1', 'password11', 'njones1@gmail.com', 27, '7', '1');
insert into People Values ('135791357', 'Jennifer Trent', 'pharmacist', 'jtrent1', 'password12', 'jtrent1@gmail.com', 40, '14', '1');



Create table Healthcare_Staff(
SSN VARCHAR(9),
Job_Title VARCHAR(50),
PRIMARY KEY (SSN),
Foreign key (SSN) REFERENCES People (SSN) ON DELETE CASCADE);

insert into Healthcare_Staff Values ('123456789', 'nurse');
insert into Healthcare_Staff Values ('987654321', 'physician');
insert into Healthcare_Staff Values ('111111111', 'volunteer');
insert into Healthcare_Staff Values ('222222222', 'nursing student');
insert into Healthcare_Staff Values ('333333333', 'nurse');
insert into Healthcare_Staff Values ('444444444', 'pharmacist');
insert into Healthcare_Staff Values ('555555555', 'nurse');
insert into Healthcare_Staff Values ('666666666', 'physician');
insert into Healthcare_Staff Values ('777777777', 'retired physician');
insert into Healthcare_Staff Values ('888888888', 'dentist');
insert into Healthcare_Staff Values ('999999999', 'nurse');
insert into Healthcare_Staff Values ('135791357', 'pharmacist');


/*----------------Create Table Administers ------------------------*/

CREATE TABLE Administers(
SSN VARCHAR(9),
Vaccine_ID VARCHAR(20),

PRIMARY KEY(SSN, Vaccine_ID),

FOREIGN KEY(SSN) REFERENCES Healthcare_Staff(SSN),
FOREIGN KEY(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID)
);

insert into Administers Values ('123456789', '1');
insert into Administers Values ('987654321', '1');
insert into Administers Values ('111111111', '2');
insert into Administers Values ('222222222', '2');
insert into Administers Values ('333333333', '3');
insert into Administers Values ('444444444', '3');
insert into Administers Values ('555555555', '3');
insert into Administers Values ('666666666', '1');
insert into Administers Values ('777777777', '2');
insert into Administers Values ('888888888', '1');
insert into Administers Values ('999999999', '2');
insert into Administers Values ('135791357', '3');

CREATE TABLE Appointments(
  Appt_ID VARCHAR(20),
  Appt_date DATE,
  Located VARCHAR(20) NOT NULL,
  is_part_of VARCHAR(20) NOT NULL,
  SSN VARCHAR(9),
  Vaccine_ID VARCHAR(20),
  PRIMARY KEY (Appt_ID),
  FOREIGN KEY (Located) REFERENCES Distribution_Location(Location_ID),
  FOREIGN KEY (is_part_of) REFERENCES Distribution_Phase(Phase_number),
  FOREIGN KEY (SSN) REFERENCES People(SSN),
  FOREIGN KEY (Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID)
);

INSERT INTO Appointments VALUES ('1', To_DATE('2020-12-10 10:00:00', 'yyyy-mm-dd HH24:MI:SS'), '2', '1', 123456789, '1');
INSERT INTO Appointments VALUES ('2', To_DATE('2020-12-10 11:00:00', 'yyyy-mm-dd HH24:MI:SS'), '2', '1', 555555555, '1');
INSERT INTO Appointments VALUES ('3', To_DATE('2020-12-16 12:00:00', 'yyyy-mm-dd HH24:MI:SS'), '3', '1', 999999999, '2');

INSERT INTO Appointments VALUES ('4', To_DATE('2021-03-01 13:00:00', 'yyyy-mm-dd HH24:MI:SS'), '3', '2', NULL, '1');
INSERT INTO Appointments VALUES ('5', To_DATE('2021-03-02 14:00:00', 'yyyy-mm-dd HH24:MI:SS'), '3', '2', 777777777, '1');
INSERT INTO Appointments VALUES ('6', To_DATE('2021-03-03 15:00:00', 'yyyy-mm-dd HH24:MI:SS'), '3', '2', NULL, '2');

INSERT INTO Appointments VALUES ('7', To_DATE('2021-05-10 16:00:00', 'yyyy-mm-dd HH24:MI:SS'), '1', '3', 741852963, '3');
INSERT INTO Appointments VALUES ('8', To_DATE('2021-05-10 09:00:00', 'yyyy-mm-dd HH24:MI:SS'), '1', '3', NULL, '3');
INSERT INTO Appointments VALUES ('9', To_DATE('2021-07-16 12:00:00', 'yyyy-mm-dd HH24:MI:SS'), '1', '3', NULL, '3');



Create table Health_Insurance (
Insurance_Number VARCHAR(25),
SSN VARCHAR(9) NOT NULL,
Insurance_Company VARCHAR(25),
covid_coverage VARCHAR(1),
expiration_date DATE,
PRIMARY KEY (Insurance_Number),
Unique (SSN),
Foreign key (SSN) REFERENCES People (SSN));

insert into Health_Insurance Values ('12345', '147258369', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('67899', '741852963', 'BCBS', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY'));
insert into Health_Insurance Values ('98765', '951753825', 'BCBS', 'T', TO_DATE('01 Jan 2023', 'DD MON YYYY'));
insert into Health_Insurance Values ('14785', '123456789', 'BCBS', 'T', TO_DATE('01 Jan 2028', 'DD MON YYYY'));
insert into Health_Insurance Values ('11111', '987654321', 'BCBS', 'T', TO_DATE('01 Jan 2025', 'DD MON YYYY'));
insert into Health_Insurance Values ('22222', '111111111', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('33333', '222222222', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('44444', '333333333', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('55555', '444444444', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('66666', '555555555', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('77777', '666666666', 'Tufts', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY'));
insert into Health_Insurance Values ('88888', '777777777', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('99999', '888888888', 'Tufts', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY'));
insert into Health_Insurance Values ('10101', '999999999', 'Harvard Pilgrim', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));
insert into Health_Insurance Values ('20202', '135791357', 'Harvard Pilgrim', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY'));


Create table Diagnosed (
SSN VARCHAR(9),
Disease_ID VARCHAR(20),
PRIMARY KEY (SSN, Disease_ID),
Foreign key (SSN) REFERENCES People (SSN),
Foreign key (Disease_ID) REFERENCES Comorbidities (Disease_ID));

insert into Diagnosed Values ('111111111', '1');
insert into Diagnosed Values ('111111111', '2');
insert into Diagnosed Values ('111111111', '3');
insert into Diagnosed Values ('222222222', '4');
insert into Diagnosed Values ('222222222', '5');
insert into Diagnosed Values ('222222222', '6');
insert into Diagnosed Values ('333333333', '4');
insert into Diagnosed Values ('444444444', '5');
insert into Diagnosed Values ('555555555', '6');
