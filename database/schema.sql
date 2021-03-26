/*----------------Create Table Vaccine_Type ------------------------*/
CREATE TABLE Vaccine_Type(
  Vaccine_ID CHAR(20),
  Vaccine_Name CHAR(20),
  Number_Of_Doses INT,
  Quantity REAL,
  Side_Effects CHAR(20),
  Allergies CHAR(20),

  PRIMARY KEY(Vaccine_ID),
  UNIQUE(Vaccine_Name)
);

/*----------------Create Table Vaccine_Companies ------------------------*/

CREATE TABLE Vaccine_Companies(
  Company_ID CHAR(20),
  Company_Name CHAR(20),
  Contact_Name CHAR(20),
  Contact_Email CHAR(20),
  Phone CHAR(10),

  PRIMARY KEY(Company_ID)
);

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

  /*----------------Create Table Supplies ------------------------*/

  CREATE TABLE Supplies(
  Vaccine_ID CHAR(20),
  Company_ID CHAR(20),

  PRIMARY KEY(Vaccine_ID, Company_ID),

  Foreign Key(Vaccine_ID) REFERENCES Vaccine_Type(Vaccine_ID),
  Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);


/*----------------Create Table Located ------------------------*/

CREATE TABLE Located(
  Address_ID CHAR(20),
  Company_ID CHAR(20),

  PRIMARY KEY(Address_ID, Company_ID),

  Foreign Key(Address_ID) REFERENCES Address(Address_ID),
  Foreign Key(Company_ID) REFERENCES Vaccine_Companies(Company_ID)
);


/*---------------------------------------*/


CREATE TABLE Comorbidities(
  Disease_ID CHAR(20),
  Disease_name CHAR(50),
  Severity REAL,
  PRIMARY KEY (Disease_ID)
);

CREATE TABLE Distribution_Phase(
  Phase_number CHAR(20),
  Description VARCHAR(3000),
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
  address_id CHAR(15) NOT NULL,
  phase_number CHAR(15) NOT NULL,
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

Create table Health_Insurance (
  Insurance_Number CHAR(25),
  SSN CHAR(9) NOT NULL,
  Insurance_Company CHAR(25),
  covid_coverage BOOLEAN,
  expiration_date DATE,
  PRIMARY KEY (Insurance_Number),
  Unique (SSN),
  Foreign key (SSN) REFERENCES People (SSN)
);

Create table Diagnosed (
  SSN CHAR(9),
  Disease_ID CHAR(25),
  PRIMARY KEY (SSN, Disease_ID),
  Foreign key (SSN) REFERENCES People (SSN),
  Foreign key (Disease_ID) REFERENCES Comorbidities (Disease_ID)
);
