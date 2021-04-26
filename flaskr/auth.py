import functools

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from db import DB
from queries import *
import app

bp = Blueprint('auth', __name__, url_prefix='/auth')


# @bp.route('/register', methods=('GET', 'POST'))
# def register():
#     if request.method == 'POST':
#         username = request.form['username']
#         password = request.form['password']
#         db = get_db()
#         error = None
#
#         if not username:
#             error = 'Username is required.'
#         elif not password:
#             error = 'Password is required.'
#         elif db.execute(
#             'SELECT id FROM user1 WHERE username = ?', (username,)
#         ).fetchone() is not None:
#             error = 'User1 {} is already registered.'.format(username)
#
#         if error is None:
#             db.execute(
#                 'INSERT INTO user1 (username, password) VALUES (?, ?)',
#                 (username, generate_password_hash(password))
#             )
#             db.commit()
#             return redirect(url_for('auth.login'))
#
#         flash(error)
#
#     return render_template('auth/register.html')


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
        # print(user1)

        if user1 is None:
            error = 'Incorrect username.'
            # print(user1)
            # print(username)
        elif not user1[1] == password:
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user1[0]
            print(user1)
            # return redirect(url_for('index'))
            return redirect(url_for('auth.register')) # redirect to y show_appt page here

        flash(error)

    return render_template('auth/login.html')


@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user1 = None
    else:
        g.user1 = DB.get_instance().execute(
            'SELECT * FROM people WHERE ssn = :u_ssn', [user_id]
        ).fetchone()


@bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))


def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user1 is None:
            return redirect(url_for('auth.login'))

        return view(**kwargs)

    return wrapped_view


## MY PROFILE PAGE ##


@bp.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        name = request.form['name']
        address = request.form['address']
        age = request.form['age']
        email_address = request.form['email_address']
        occupation = request.form['occupation']
        ssn = request.form['ssn']
        username = request.form['username']
        password = request.form['password']
        comorbidities = request.form['comorbidities']
        insurance_company = request.form['insurance_company']
        insurance_number = request.form['insurance_number']
        exp_date = request.form['exp_date']
        healthcare_worker = request.form['healthcare_worker']
        job_title = request.form['job_title']
        phase_number = 'idk'
        covid_coverage = request.form['covid_coverage']

        cursor = DB.get_instance()
        error = None

        if not username:
            error = 'Username is required.'
            # print(error)
        elif not password:
            error = 'Password is required.'
            # print(error)
        # elif not name:
        #     error = 'Name is required'
        # elif not age:
        #     error = 'Age is required'
        elif not ssn:
            error = 'SSN is required'
            # print(error)
        elif not address:
            error = 'Address is required'
            print(error)
        elif cursor.execute(
            find_ssn_name_for_cred, [username, password]
        ).fetchone() is not None:
            error = 'User {} is already registered.'.format(ssn)

        if error is None:
            print(username)
            print(ssn)
            print(comorbidities)
            #db.execute('SELECT address_id FROM Address WHERE street = ?', (address,))
            cursor.execute(
                'INSERT INTO People (ssn, name, occupation, username, password, email_address, age, address_id, phase_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                (ssn, name, occupation, username, generate_password_hash(password), email_address, age, address, phase_number))
            cursor.execute('INSERT INTO Health_Insurance (Insurance_Number, ssn, Insurance_Company, covid_coverage, expiration_date) VALUES (?, ?, ?, ?, ?)',
            (insurance_number, ssn, insurance_company, covid_coverage, exp_date))

            if healthcare_worker:
                cursor.execute('INSERT INTO Healthcare_Staff (SSN, Job_Title), VALUES (?, ?)',
                           (ssn, job_title))

            cursor.commit()
            return redirect(url_for('auth.login'))

        flash(error)

    return render_template('auth/register.html')

@bp.route('/show_appt', methods=('GET', 'POST'))
def show_appt():

    user_id = session.get('user_id')
    #print(user_id)
    qres = app.show_upcoming_appointments(user_id)
    #qres = app.show_upcoming_appointments(741852963)
    #print(qres)
    header = ("Appt Id", "Date & Time", "Location", "Street", "Apartment", "City", "State", "Country","Vaccine")
    return render_template('auth/show_appt.html', header=header, data=qres)


@bp.route('/schedule_appt', methods=('GET', 'POST'))
def schedule_appt():
    #qres = app.show_available_appointments("WPI")
    qres = app.show_available_appointments()
    print(qres)
    header = ("Date", "Location", "Phase", "Vaccine_Type","Schedule")
    return render_template('auth/schedule_appt.html', data=qres, header=header)


#------------------------------
# @bp.route('/login', methods=('GET', 'POST'))
# def login():
#     if request.method == 'POST':
#         username = request.form['username']
#         password = request.form['password']
#         db = get_db()
#         error = None
#         user1 = db.execute(
#             'SELECT * FROM user1 WHERE username = ?', (username,)
#         ).fetchone()
#
#         if user1 is None:
#             error = 'Incorrect username.'
#         elif not check_password_hash(user1['password'], password):
#             error = 'Incorrect password.'
#
#         if error is None:
#             session.clear()
#             session['user_id'] = user1['id']
#             return redirect(url_for('index'))
#
#         flash(error)
#
#     return render_template('auth/login.html')
#
#
# @bp.before_app_request
# def load_logged_in_user():
#     user_id = session.get('user_id')
#
#     if user_id is None:
#         g.user1 = None
#     else:
#         g.user1 = get_db().execute(
#             'SELECT * FROM user1 WHERE id = ?', (user_id,)
#         ).fetchone()
#
#
# @bp.route('/logout')
# def logout():
#     session.clear()
#     return redirect(url_for('index'))
#
#
# def login_required(view):
#     @functools.wraps(view)
#     def wrapped_view(**kwargs):
#         if g.user1 is None:
#             return redirect(url_for('auth.login'))
#
#         return view(**kwargs)
#
#     return wrapped_view

# @bp.route('/enter_name', methods=('GET', 'POST'))
# def enter_name():
#     if request.method == 'POST':
#         name = request.form['Name']
#         db = get_db()
#         error = None
#
#         if not name:
#             error = 'Name is required.'
#         elif db.execute(
#             'SELECT  FROM user1 WHERE username = ?', (name,)
#         ).fetchone() is not None:
#             error = 'User1 {} is already registered.'.format(name)
#
#         if error is None:
#             db.execute(
#                 'INSERT INTO People (name) VALUES (?, ?)',
#                 (name)#, generate_password_hash(password))
#             )
#             db.commit()
#             return redirect(url_for('auth.login'))
#
#         flash(error)
#
#     return render_template('auth/register.html')
