import sqlite3

from flask import Flask
import os
import cx_Oracle
import sys
from . import db_info
# from queries import *

import click
from flask import current_app, g
from flask.cli import with_appcontext

if sys.platform.startswith("darwin"):
    try:
        cx_Oracle.init_oracle_client(lib_dir=os.environ.get("HOME") + "/instantclient_19_3")
    except Exception:
        cx_Oracle.init_oracle_client(lib_dir=os.environ.get("HOME") + "/Downloads" + "/instantclient_19_8")
elif sys.platform.startswith("win32"):
    cx_Oracle.init_oracle_client(lib_dir=r"c:\oracle\instantclient_19_10")

def init_session(connection, requestedTag_ignored):
    cursor = connection.cursor()
    cursor.execute("""
        ALTER SESSION SET
          TIME_ZONE = 'UTC'
          NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI'""")
    # return cursor


# start_pool(): starts the connection pool
def start_pool():
    # Generally a fixed-size pool is recommended, i.e. pool_min=pool_max.
    # Here the pool contains 4 connections, which is fine for 4 concurrent
    # users.
    #
    # The "get mode" is chosen so that if all connections are already in use, any
    # subsequent acquire() will wait for one to become available.

    pool_min = 4
    pool_max = 4
    pool_inc = 0
    pool_gmd = cx_Oracle.SPOOL_ATTRVAL_WAIT

    print("Connecting to", db_info.db_endpoint)

    dsn_str = cx_Oracle.makedsn(db_info.db_endpoint, db_info.db_port, "ORCL")
    print(dsn_str)

    pool = cx_Oracle.SessionPool(user=db_info.db_username,
                                 password=db_info.db_pw,
                                 dsn=dsn_str,
                                 min=pool_min,
                                 max=pool_max,
                                 increment=pool_inc,
                                 threaded=True,
                                 getmode=pool_gmd,
                                 sessionCallback=init_session)

    return pool


# def get_db():
#     return pool.acquire().cursor()

    # return pool


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

# def init_db():
#     db = get_db()
#
#     with current_app.open_resource('Untitled.sql') as f:
#         db.executescript(f.read().decode('utf8'))


@click.command('init-db')
@with_appcontext
def init_db_command():
    """Clear the existing data and create new tables."""
    # init_db()
    start_pool()
    click.echo('Initialized the database.')
#
def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)


###########

