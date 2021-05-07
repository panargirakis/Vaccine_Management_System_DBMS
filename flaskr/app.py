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
# test

app = Flask(__name__)


# Display a welcome message on the 'home' page
@app.route('/')
def index():
    return redirect(url_for('auth.login'))


def show_upcoming_appointments(id):
    cursor = DB.get_instance()
    cursor.execute(find_appt_by_person, [id])
    # query_results = cursor.fetchone()
    query_results = cursor.fetchall()

    return query_results


def show_past_appointments(id):
    cursor = DB.get_instance()
    cursor.execute(find_past_appt_by_person, [id])
    query_results = cursor.fetchall()

    return query_results


def show_available_appointments():
    cursor = DB.get_instance()
    cursor.execute(all_available_appointments)
    # use find all available appointments query
    query_results = cursor.fetchall()
    return query_results


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
