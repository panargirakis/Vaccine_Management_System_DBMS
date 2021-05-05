import functools
import random
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
import pycountry

from db import DB
from queries import *
import app

from datetime import datetime

bp = Blueprint('auth', __name__, url_prefix='/auth')


@bp.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        cursor = DB.get_instance()
        error = None
        cursor.execute(
            "SELECT ssn, password FROM people WHERE username = :username", [username]
        )
        user1 = cursor.fetchone()
        # ssn = user1[0]

        if user1 is None:
            error = 'Incorrect username.'
            # print(user1)
            # print(username)
        elif not user1[1] == password:
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user1[0]
            # print(ssn)
            # return redirect(url_for('index'))
            return redirect(url_for('auth.register')) # redirect to y show_appt page here

        flash(error)

    return render_template('auth/login.html')


@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        cursor = DB.get_instance()
        g.user = list(cursor.execute(
            'SELECT * FROM PEOPLE P '
            'LEFT JOIN ADDRESS A2 on P.ADDRESS_ID = A2.ADDRESS_ID '
            'LEFT JOIN HEALTH_INSURANCE HI on P.SSN = HI.SSN '
            'LEFT JOIN HEALTHCARE_STAFF HS on P.SSN = HS.SSN '
            'WHERE P.SSN = :u_ssn', [user_id]
        ).fetchone())

        g.user.append([x[0] for x in cursor.execute(
            'SELECT C.DISEASE_NAME FROM COMORBIDITIES C '
            'INNER JOIN DIAGNOSED D on C.DISEASE_ID = D.DISEASE_ID '
            'INNER JOIN PEOPLE P on D.SSN = P.SSN '
            'WHERE P.SSN = :user_id', [user_id]).fetchall()])



@bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('auth.login'))


def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('auth.login'))

        return view(**kwargs)

    return wrapped_view


## MY PROFILE PAGE ##


@bp.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':

        name = request.form['name']

        street = request.form['street']
        city = request.form['city']
        state = request.form['state']
        country = request.form['country']
        zip_code = request.form['zip_code']
        apartment = request.form['apartment']

        age = request.form['age']
        email_address = request.form['email_address']
        occupation = request.form['occupation']
        ssn = request.form['ssn']
        username = request.form['username']
        password = request.form['password']
        comorbidities = request.form.getlist('comorbidities')
        insurance_company = request.form['insurance_company']
        insurance_number = request.form['insurance_number']
        exp_date = request.form['exp_date']
        healthcare_worker = request.form.get('healthcare_worker')
        job_title = request.form['job_title']
        covid_coverage = request.form.get('covid_coverage')

        # print(covid_coverage)
        # print(exp_date)
        # print(job_title)
        # print(ssn)
        # print(comorbidities)
        # print(comorbidities[0])
        # print(country)
        # print()

        cursor = DB.get_instance()
        error = None

        if not username:
            error = 'Username is required.'
            # print(error)
        elif not password:
            error = 'Password is required.'
            # print(error)
        elif not name:
            error = 'Name is required'
        elif not insurance_company:
            error = 'Insurance company is required'
        elif not insurance_number:
            error = 'Insurance number is required'
        elif not exp_date:
            error = 'Expiration Date of insurance is required'
        elif not ssn:
            error = 'SSN is required'
            # print(error)
        elif not street:
            error = 'Street is required'
        elif not city:
            error = 'City is required'
        elif not state:
            error = 'State is required'
        elif not country:
            error = 'Country is required'
        elif not zip_code:
            error = 'Zip Code is required'

        elif cursor.execute(
            find_ssn_name_for_cred, [username, password]
        ).fetchone() is not None:
            error = 'User {} is already registered.'.format(username)

        if error is None:
            dt = datetime.strptime(exp_date, "%Y-%m-%d") #, %H:%M:%S")
            dtt = dt.strftime('%d %b %Y')

            # generate address id
            cursor.execute("SELECT DISTINCT A.Address_ID FROM Address A")
            address_ids = cursor.fetchall()
            address_ids_list = []
            for i in range(0,len(address_ids)):
                address_ids_list.append(int(address_ids[i][0]))
            max_add_id = max(address_ids_list)

            address_id = str(max_add_id + 1)

            # get appropriate phase number for new user
            if healthcare_worker == 'on':
                phase_number = '1'
            elif float(age) > 55 or len(comorbidities) >= 2 or occupation == 'teacher':
                phase_number = '2'
            else:
                phase_number = '3'

            if covid_coverage == 'on':
                covid_coverage = 'T'
            else:
                covid_coverage = 'F'


            cursor.execute('INSERT INTO Address (Address_ID, Apartment, Street, City, State, Country, Zip_Code) VALUES (:Address_ID, :Apartment, :Street, :City, :State, :Country, :Zip_Code)', (address_id, apartment, street, city, state, country, zip_code))

            cursor.execute(
                'INSERT INTO People (ssn, name, occupation, username, password, email_address, age, address_id, phase_number) VALUES (:ssn, :name, :occupation, :username, :password, :email_address, :age, :address_id, :phase_number)',
                (ssn, name, occupation, username, password, email_address, float(age), address_id, phase_number))

            cursor.execute("INSERT INTO Health_Insurance (Insurance_Number, ssn, Insurance_Company, covid_coverage, expiration_date) VALUES (:insurance_number, :ssn, :insurance_company, :covid_coverage, TO_DATE(:exp_date, 'DD MON YYYY'))",
            (insurance_number, ssn, insurance_company, covid_coverage, dtt))

            # cursor.execute('INSERT INTO Diagnosed (SSN, Disease_ID) VALUES (:ssn, :disease_id)', [ssn, did])

            # did_list = []
            for i in range(0, len(comorbidities)):
                cursor.execute("SELECT DISTINCT C.Disease_ID FROM Comorbidities C WHERE C.Disease_name= :disease_name",
                               [comorbidities[i]])
                did = cursor.fetchall()
                # did_list.append(did)
                # print(did)
                did = did[0][0]
                # print(did)
                cursor.execute('INSERT INTO Diagnosed (SSN, Disease_ID) VALUES (:ssn, :disease_id)', [ssn, did])

            if healthcare_worker == 'on' and job_title != '':
                # randomly pick a vaccine they administer
                vaccine_id = random.randint(1, 3)
                cursor.execute('INSERT INTO Healthcare_Staff (ssn, job_title) VALUES (:ssn, :job_title)',
                           (ssn, job_title))
                cursor.execute('INSERT INTO Administers (SSN, Vaccine_ID) VALUES (:ssn, :vaccine_id)', [ssn, vaccine_id])
            else:
                pass

            # DB.__instance.acquire().commit()

            return redirect(url_for('auth.login'))

        flash(error)

    cursor = DB.get_instance()
    all_comorbidities = cursor.execute(find_all_comorbidities).fetchall()

    states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
              "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
              "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
              "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
              "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

    return render_template('auth/register.html', all_comorbidities=all_comorbidities,
                           countries=[c.name for c in list(pycountry.countries)], states=states)
#

@bp.route('/phase_eligibility')#, methods=('GET', 'POST'))
def phase_eligibility():
    user_id = session.get('user_id')
    cursor = DB.get_instance()
    cursor.execute("SELECT DISTINCT P.phase_number FROM People P " \
                        "WHERE P.ssn= :ssn", [user_id])
    phase = cursor.fetchall()

    cursor.execute("SELECT DISTINCT DP.Start_date FROM Distribution_Phase DP " \
                        "WHERE DP.Phase_number= :phase_number", [str(phase[0][0])])
    phase_start = cursor.fetchall()
    phase_start = phase_start[0][0].strftime("%m/%d/%Y, %H:%M:%S")

    output = "You are eligible for phase: " + phase[0][0]
    output1 = "Phase starts on: " + phase_start
    output2 = "Factors influencing your eligibility: "

    cursor.execute("SELECT DISTINCT DP.Description FROM Distribution_Phase DP " \
                   "WHERE DP.Phase_number= :phase_number", [str(phase[0][0])])
    description = cursor.fetchall()

    if str(phase[0][0]) == '1':
        cursor.execute("SELECT DISTINCT P.occupation FROM People P " \
                       "WHERE P.ssn= :ssn", [user_id])
        occupation = cursor.fetchone()
        output3 = 'Occupation: ' + str(occupation[0])
        output4 = 'Age: ' + 'N/A'
        output5 = 'Comorbidities: ' + 'N/A'
    elif str(phase[0][0]) == '2':
        cursor.execute("SELECT DISTINCT P.occupation FROM People P " \
                       "WHERE P.ssn= :ssn", [user_id])
        occupation = cursor.fetchone()
        output3 = 'Occupation: ' + str(occupation[0])

        cursor.execute("SELECT DISTINCT P.age FROM People P " \
                       "WHERE P.ssn= :ssn", [user_id])
        age = cursor.fetchone()
        output4 = 'Age: ' + str(age[0])

        try:
            cursor.execute("SELECT DISTINCT D.Disease_ID FROM Diagnosed D WHERE D.ssn= :ssn", [user_id])
            did = cursor.fetchall()
            # did = did
            # print(did)
            # print(len(did))
            # print(did[1][0])
            # cursor.execute("SELECT DISTINCT C.Disease_name FROM Comorbidities C WHERE C.Disease_ID= :Disease_ID", [did])
            com_list = []
            for i in range(0, len(did)):
                cursor.execute("SELECT DISTINCT C.Disease_name FROM Comorbidities C WHERE C.Disease_ID= :Disease_ID", [did[i][0]])
                # cursor.execute("SELECT DISTINCT C.Disease_ID FROM Comorbidities C WHERE C.Disease_name= :disease_name", [comorbidities[i]])
                com = cursor.fetchall()
                com_list.append(com[0][0])
                # print(did)
                # did = did[0][0]
                # print(did)
                # cursor.execute("SELECT DISTINCT C.Disease_name FROM Comorbidities C WHERE C.Disease_ID= :Disease_ID", [did])

            # comorbidities = cursor.fetchall()
            listToStr = ', '.join([str(elem) for elem in com_list])
            output5 = 'Comorbidities: ' + listToStr # str(comorbidities[0][0])
        except Exception:
            print("exception")
            output5 = 'No comorbidities'
    elif str(phase[0][0]) == '3':
        output3 = ''
        output4 = ''
        output5 = ''

    output6 = 'Description: ' + description[0][0]

    return render_template('auth/phase_eligibility.html', output=[output, output1, output2, output3, output4, output5, output6])



@bp.route('/show_appt', methods=('GET', 'POST'))
def show_appt():

    if request.method == "POST":
        cursor = DB.get_instance()
        cursor.execute("update APPOINTMENTS set ssn=null where APPT_ID = :ap_id", [request.form['cancel']])

    # Get past and upcoming appointments
    user_id = session.get('user_id')
    #print(user_id)
    qres = app.show_upcoming_appointments(user_id)
    qres_past = app.show_past_appointments(user_id)
    # print(qres[0])
    # print(qres_past[0])

    # Prompt for vaccination shots.
    vacc_out = ""
    try:
        if str(qres[0][8]) == 'Johnson':
            vacc_out = "No further appointments needed!"
        elif (str(qres[0][8]) == 'Moderna' or str(qres[0][8]) == 'Pfizer') and len(qres) < 2:
            vacc_out = "Be sure to schedule your second appointment!"
        elif (str(qres[0][8]) == 'Moderna' or str(qres[0][8]) == 'Pfizer') and len(qres) == 2:
            vacc_out = "All appointments scheduled."

    except Exception:

        vacc_out = "Please schedule your first vaccine appointment."

    # Header for appointment table
    header = ("Appt Id", "Date & Time", "Location", "Street", "Apartment", "City", "State", "Country","Vaccine")

    # Get past appointments: Past appointment button
    if request.method == 'GET' and request.args.get('Show Past Appointments') == "True":
        return render_template('auth/show_appt.html', header=header, data=qres_past)

    return render_template('auth/show_appt.html', header=header, data=qres, output=vacc_out,
                           just_cancelled=request.method == "POST")


@bp.route('/schedule_appt', methods=('GET', 'POST'))
def schedule_appt():
    # get user's ssn
    user_id = session.get('user_id')

    cursor = DB.get_instance()

    if request.method == "POST":
        cursor.execute("update APPOINTMENTS set ssn=:u_ssn where APPT_ID = :ap_id", [user_id, request.form['schedule']])

    cursor.execute(available_appointments_by_user_eligibility, [user_id])
    available_appointments = cursor.fetchall()

    avail_loc = [x[2] for x in available_appointments]  # get all available locations
    avail_loc = list(set(avail_loc))  # remove duplicates

    vacc_types = [x[4] for x in available_appointments]
    vacc_types = list(set(vacc_types))

    # print(qres)
    header = ("Appt_Id", "Date", "Location", "Phase", "Vaccine_Type", "Schedule")

    return render_template('auth/schedule_appt.html', data=available_appointments, header=header, avail_loc=avail_loc,
                           vacc_types=vacc_types, just_scheduled=request.method == "POST")
