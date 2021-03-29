/*----------------Create Table Vaccine_Type ------------------------*/
CREATE TABLE Vaccine_Type(
Vaccine_ID CHAR(20),
Vaccine_Name CHAR(20),
Number_Of_Doses INT,

PRIMARY KEY(Vaccine_ID),
UNIQUE(Vaccine_Name)
);


INSERT INTO Vaccine_Type VALUES('01','Pfizer','2');
INSERT INTO Vaccine_Type VALUES('02','Moderna','2');
INSERT INTO Vaccine_Type VALUES('03','Johnson','1');

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

INSERT INTO Address VALUES('4', '4', 'Mirick Rd', 'Princeton', 'MA', 'USA', '01541');
INSERT INTO Address VALUES('5', '5', 'N Sturbridge Rd', 'Charlton', 'MA', 'USA', '01507');
INSERT INTO Address VALUES('6', '6', 'Mount Auburn St', 'Watertown', 'MA', 'USA', '02427');
INSERT INTO Address VALUES('7', '7', 'Neilson Rd', 'New Salem', 'MA', 'USA', '03155');
INSERT INTO Address VALUES('8', '88', 'Reservoir Rd', 'Coventry', 'RI', 'USA', '02816');
INSERT INTO Address VALUES('9', '101', 'Gaulin Ave', 'Woonsocket', 'RI', 'USA', '02895');
INSERT INTO Address VALUES('10', '200', 'Aldrich St', 'Wyoming', 'RI', 'USA', '02898');
INSERT INTO Address VALUES('11', '17', 'Morril Ln', 'Providence', 'RI', 'USA', '02904');
INSERT INTO Address VALUES('12', '25', 'Conifer Rd', 'Rindge', 'NH', 'USA', '03461');
INSERT INTO Address VALUES('13', '23', 'Wentworth Ave', 'Plaistow', 'NH', 'USA', '03865');
INSERT INTO Address VALUES('14', '20', 'Varney Point Rd', 'Gilford', 'NH', 'USA', '03249');
INSERT INTO Address VALUES('15', '41', 'Hixville Rd', 'North Dartmouth', 'MA', 'USA', '02747');
INSERT INTO Address VALUES('16', '1000', 'Clark St', 'New Bedford', 'MA', 'USA', '02740');
INSERT INTO Address VALUES('17', '26', 'Main St', 'Acushnet', 'MA', 'USA', '02743');

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

/* NEED to insert the distribution phase number foreign key to each person here */                                                    
                                                          
insert into People Values ('147258369', 'Joe Wild', 'contractor', 'jwild1', 'password13', 'jwild1@gmail.com', 52, '15');
insert into People Values ('741852963', 'Jim Hendrix', 'musician', 'jhendrix1', 'password14', 'jhendrix1@gmail.com', 32, '16');
insert into People Values ('951753825', 'Aubrey West', 'teacher', 'awest1', 'password0', 'awest1@gmail.com', 34, '17');
                                                          
insert into People Values ('123456789', 'Jane Doe', 'nurse', 'jdoe1', 'password1', 'jdoe1@gmail.com', 50, '4');
insert into People Values ('987654321', 'John Doe', 'physician', 'jdoe2', 'password2', 'jdoe2@gmail.com', 55, '5');
insert into People Values ('111111111', 'Ben Johnson', 'volunteer', 'bjohnson1', 'password3', 'bjohnson1@gmail.com', 60, '6');
insert into People Values ('222222222', 'Peter Smith', 'nursing student', 'psmith1', , 'password4', 'psmith1@gmail.com', 25, '6');
insert into People Values ('333333333', 'Jack Black', 'nurse', 'jblack1', 'password5', 'jblack1@gmail.com', 35, '8');
insert into People Values ('444444444', 'Tom Johnston', 'pharmacist', 'tjohnston1', 'password6', 'tjohnston1@gmail.com', 45, '9');
insert into People Values ('555555555', 'Bill Smithers', 'nurse', 'bsmithers1', 'password7', 'bsmithers1@gmail.com', 40, '10');
insert into People Values ('666666666', 'Jan Moon', 'physician', 'jmoon1', 'password8', 'jmoon1@gmail.com', 55, '11');
insert into People Values ('777777777', 'Jeff Frost', 'retired physician', 'jfrost1', 'password9', 'jfrost1@gmail.com', 70, '12');
insert into People Values ('888888888', 'Jim Blake', 'dentist', 'jblake1', 'password10', 'jblake1@gmail.com', 38, '13');
insert into People Values ('999999999', 'Nick Jones', 'nurse', 'njones1', 'password11', 'njones1@gmail.com', 27, '7');
insert into People Values ('135791357', 'Jennifer Trent', 'pharmacist', 'jtrent1', 'password12', 'jtrent1@gmail.com', 40, '14');                                                            

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
                                     
insert into Health_Insurance Values ('12345', '147258369', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('67899', '741852963', 'BCBS', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY');
insert into Health_Insurance Values ('98765', '951753825', 'BCBS', 'T', TO_DATE('01 Jan 2023', 'DD MON YYYY');
insert into Health_Insurance Values ('14785', '123456789', 'BCBS', 'T', TO_DATE('01 Jan 2028', 'DD MON YYYY');
insert into Health_Insurance Values ('11111', '987654321', 'BCBS', 'T', TO_DATE('01 Jan 2025', 'DD MON YYYY');
insert into Health_Insurance Values ('22222', '111111111', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('33333', '222222222', 'BCBS', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('44444', '333333333', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('55555', '444444444', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('66666', '555555555', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('77777', '666666666', 'Tufts', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY');
insert into Health_Insurance Values ('88888', '777777777', 'Tufts', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('99999', '888888888', 'Tufts', 'T', TO_DATE('01 Jan 2022', 'DD MON YYYY');
insert into Health_Insurance Values ('10101', '999999999', 'Harvard Pilgrim', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');
insert into Health_Insurance Values ('20202', '135791357', 'Harvard Pilgrim', 'T', TO_DATE('01 Jan 2024', 'DD MON YYYY');                                     


Create table Diagnosed (
SSN CHAR(9),
Disease_ID CHAR(20),
PRIMARY KEY (SSN, Disease_ID),
Foreign key (SSN) REFERENCES People (SSN),
Foreign key (Disease_ID) REFERENCES Comorbidities (Disease_ID));

