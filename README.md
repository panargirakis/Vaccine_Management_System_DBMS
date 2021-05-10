# Vaccine_Management_System_DBMS
A vaccine distribution management system created for the WPI Database Management Systems class

## How to run the application

Requirements: Python 3.7, `cx_oracle` installation, dependencies listed in requirements.txt

Create a `venv` with Python 3.7 and install requirements.txt.

Also install `cx_oracle` at path c:\oracle\instantclient_19_10.

The application is configured to connect to a database hosted on AWS. If the database is down the application will not work. Alternatively, configure a new database in `flaskr/db_info.py`.
