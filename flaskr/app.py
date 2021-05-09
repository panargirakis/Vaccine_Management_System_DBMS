from flask import Flask
import os
from queries import *
import auth
from db import DB
from flask import (
    redirect, render_template, request, session, url_for
)
"""
Before running, set these environment variables:

    PORT                  - port the web server will listen on.  The default in 8080

"""


app = Flask(__name__)


# Display a welcome message on the 'home' page
@app.route('/')
def index():
    return redirect(url_for('auth.login'))


@app.route('/phase_eligibility')
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

    return render_template('phase_eligibility.html', output=[output, output1, output2, output3, output4, output5, output6])


@app.route('/show_appt', methods=('GET', 'POST'))
def show_appt():
    cursor = DB.get_instance()

    if request.method == "POST":
        cursor.execute("update APPOINTMENTS set ssn=null where APPT_ID = :ap_id", [request.form['cancel']])

    # Get past and upcoming appointments
    user_id = session.get('user_id')
    #print(user_id)

    qres = cursor.execute(find_appt_by_person, [user_id]).fetchall()
    qres_past = cursor.execute(find_past_appt_by_person, [user_id]).fetchall()

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
        return render_template('show_appt.html', header=header, data=qres_past)

    return render_template('show_appt.html', header=header, data=qres, output=vacc_out,
                           just_cancelled=request.method == "POST")


@app.route('/schedule_appt', methods=('GET', 'POST'))
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

    return render_template('schedule_appt.html', data=available_appointments, header=header, avail_loc=avail_loc,
                           vacc_types=vacc_types, just_scheduled=request.method == "POST")


# Will disable browser cache for quicker development:

# @app.context_processor
# def override_url_for():
#     return dict(url_for=dated_url_for)
#
#
# def dated_url_for(endpoint, **values):
#     if endpoint == 'static':
#         filename = values.get('filename', None)
#         if filename:
#             file_path = os.path.join(app.root_path,
#                                  endpoint, filename)
#             values['q'] = int(os.stat(file_path).st_mtime)
#     return url_for(endpoint, **values)


################################################################################
#
# Initialization is done once at startup time
#
if __name__ == '__main__':
    app.register_blueprint(auth.bp)

    app.config.from_mapping(SECRET_KEY='dev')

    DB.get_instance()

    # Start a webserver
    app.run(port=int(os.environ.get('PORT', '8080')))
