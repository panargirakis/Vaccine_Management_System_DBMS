from flask import Flask
import os
import cx_Oracle
import sys
import db_info
from queries import *
import auth
from db import DB
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
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



# Add a new username
#
# The new user's id is generated by the DB and returned in the OUT bind
# variable 'idbv'.  As before, we leave closing the cursor and connection to
# the end-of-scope cleanup.
# @app.route('/post/<string:username>')
# def post(username):
#     connection = pool.acquire()
#     cursor = connection.cursor()
#     connection.autocommit = True
#     idbv = cursor.var(int)
#     cursor.execute("""
#         insert into demo (username)
#         values (:unbv)
#         returning id into :idbv""", [username, idbv])
#     return 'Inserted {} with id {}'.format(username, idbv.getvalue()[0])


# Show the username for a given id
@app.route('/user/<int:id>')
def show_username(id):
    cursor = DB.get_instance()
    cursor.execute("select username from people where ssn = :req_id", [id])
    r = cursor.fetchone()
    return (r[0] if r else "Unknown user id")


@app.route('/user/<int:id>/appointments')
def show_upcoming_appointments(id):
    cursor = DB.get_instance()
    cursor.execute(find_appt_by_person, [id])
    # query_results = cursor.fetchone()
    query_results = cursor.fetchall()

    # populate form
    # return (str(query_results) if query_results else "User does not have any upcoming appointments")
    return query_results

#@app.route('/user/<string:loc_name>/appointments')
def show_available_appointments():
    cursor = DB.get_instance()
    #cursor.execute(find_appt_by_dist_loc, ['WPI'])
    cursor.execute(all_available_appointments)
    # use find all available appointments query
    query_results = cursor.fetchall()
    return query_results

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
