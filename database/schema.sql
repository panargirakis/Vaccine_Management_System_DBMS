/*----------------Create Table Vaccine_Type ------------------------*/
CREATE TABLE Vaccine_Type(
Vaccine_ID CHAR(20),
Vaccine_Name CHAR(20),
Number_Of_Doses INT,
Quantity REAL,
Allergies CHAR(20),

PRIMARY KEY(Vaccine_ID),
UNIQUE(Vaccine_Name)
);


INSERT INTO Vaccine_Type VALUES('01','Pfizer','2','0.3','anaphylaxis');
INSERT INTO Vaccine_Type VALUES('02','Moderna','2','0.5','A1');
INSERT INTO Vaccine_Type VALUES('03','Johnson','1','0.5','A2');

select * from Vaccine_Type;

/*----------------Create Table Side_Effects ------------------------*/
Create Table Side_Effects (
side_effect_id CHAR(10),
side_effect CHAR(50),
PRIMARY KEY (side_effect_id));

INSERT INTO Side_Effects VALUES('01','Headache');
INSERT INTO Side_Effects VALUES('02','Swelling');
INSERT INTO Side_Effects VALUES('03','Fever');
INSERT INTO Side_Effects VALUES('04','Muscle_Pain');
INSERT INTO Side_Effects VALUES('05','Chills');

select * from Side_Effects;

/*----------------has_side_effect ------------------------*/
Create Table has_side_effect(
side_effect_id CHAR(10),
Vaccine_ID CHAR(20),
PRIMARY KEY (side_effect_id, Vaccine_ID),
Foreign Key (side_effect_id) REFERENCES Side_Effects (side_effect_id),
Foreign Key (Vaccine_ID) REFERENCES Vaccine_Type (Vaccine_ID));

INSERT INTO has_side_effect VALUES('01','01');
INSERT INTO has_side_effect VALUES('02','01');
INSERT INTO has_side_effect VALUES('03','01');
INSERT INTO has_side_effect VALUES('04','01');
INSERT INTO has_side_effect VALUES('05','01');
INSERT INTO has_side_effect VALUES('01','02');
INSERT INTO has_side_effect VALUES('02','02');
INSERT INTO has_side_effect VALUES('03','02');
INSERT INTO has_side_effect VALUES('04','02');
INSERT INTO has_side_effect VALUES('05','02');
INSERT INTO has_side_effect VALUES('01','03');
INSERT INTO has_side_effect VALUES('02','03');
INSERT INTO has_side_effect VALUES('03','03');
INSERT INTO has_side_effect VALUES('04','03');
INSERT INTO has_side_effect VALUES('05','03');

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

select * from  Address;


/*----------------Create Table Supplies ------------------------*/

CREATE TABLE Supplies(
Vaccine_ID CHAR(20),
Company_ID CHAR(20),

PRIMARY KEY(Vaccine_ID, Company_ID),

Foreign Key(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID),
Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);

INSERT INTO Supplies VALUES('01','P11');
INSERT INTO Supplies VALUES('02','M22');
INSERT INTO Supplies VALUES('03','JJ33');


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

CREATE TABLE Distribution_Phase(
  Phase_number CHAR(20),
  Description VARCHAR2(4000),
  Start_date DATE,
  End_date DATE,
  PRIMARY KEY (Phase_number)
);

CREATE TABLE associated_with(
  Disease_ID CHAR(20),
  Phase_number CHAR(20),
  PRIMARY KEY (Disease_ID, Phase_number),
  FOREIGN KEY (Disease_ID) REFERENCES Comorbidities(Disease_ID),
  FOREIGN KEY (Phase_number) REFERENCES Distribution_Phase(Phase_number)
);

CREATE TABLE Distribution_Location(
  Location_ID CHAR(20),
  Location_name CHAR(50),
  Capacity REAL,
  Located CHAR(20) NOT NULL,
  PRIMARY KEY (Location_ID),
  FOREIGN KEY (Located) REFERENCES Address(Address_ID)
);



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

/* NICK: need to insert more people, and more attributes for each person still */                                                    
                                                          
insert into People Values ('123456789', 'Jane Doe', 'nurse', 'jdoe1');
insert into People Values ('987654321', 'John Doe', 'physician', 'jdoe2');
insert into People Values ('111111111', 'Ben Johnson', 'volunteer', 'bjohnson1');
insert into People Values ('222222222', 'Peter Smith', 'nursing student', 'psmith1');
insert into People Values ('333333333', 'Jack Black', 'nurse', 'jblack1');
insert into People Values ('444444444', 'Tom Johnston', 'pharmacist', 'tjohnston1');
insert into People Values ('555555555', 'Bill Smithers', 'nurse', 'bsmithers1');
insert into People Values ('666666666', 'Jan Moon', 'physician', 'jmoon1')
insert into People Values ('777777777', 'Jeff Frost', 'retired physician', 'jfrost1');
insert into People Values ('888888888', 'Jim Blake', 'dentist', jblake1');
insert into People Values ('999999999', 'Nick Jones', 'nurse', 'njones1');
insert into People Values ('135791357', 'Jennifer Trent', 'pharmacist', 'jtrent1');                                                          

Create table Healthcare_Staff(
SSN CHAR(9),
Job_Title CHAR(50),
PRIMARY KEY (SSN),
Foreign key (SSN) REFERENCES People (SSN) ON DELETE CASCADE);
                                                          
insert into Healthcare_Staff Values ('123456789', 'nurse');
insert into Healthcare_Staff Values ('987654321', 'physician');
insert into Healthcare_Staff Values ('111111111', 'volunteer');
insert into Healthcare_Staff Values ('222222222', 'nursing student');
insert into Healthcare_Staff Values ('333333333', 'nurse');
insert into Healthcare_Staff Values ('444444444', 'pharmacist');
insert into Healthcare_Staff Values ('555555555', 'nurse');
insert into Healthcare_Staff Values ('666666666', 'physician')
insert into Healthcare_Staff Values ('777777777', 'retired physician');
insert into Healthcare_Staff Values ('888888888', 'dentist');
insert into Healthcare_Staff Values ('999999999', 'nurse');
insert into Healthcare_Staff Values ('135791357', 'pharmacist');                                                          


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

