import sqlite3

from flask import Flask
import os
import cx_Oracle
import sys
import db_info
# from queries import *

import click
from flask.cli import with_appcontext

if sys.platform.startswith("darwin"):
    try:
        cx_Oracle.init_oracle_client(lib_dir=os.environ.get("HOME") + "/instantclient_19_3")
    except Exception:
        cx_Oracle.init_oracle_client(lib_dir=os.environ.get("HOME") + "/Downloads" + "/instantclient_19_8")
elif sys.platform.startswith("win32"):
    # cx_Oracle.init_oracle_client(lib_dir=r"c:\oracle\instantclient_19_10")
    cx_Oracle.init_oracle_client(lib_dir=r"C:\Users\sanik\Downloads\oracle\instantclient_19_10")


class DB:
    __instance = None

    @staticmethod
    def get_instance():
        """ Static access method. """
        if DB.__instance == None:
            DB()

        connection = DB.__instance.acquire()
        connection.autocommit = True
        return connection.cursor()

    def __init__(self):
        """ Virtually private constructor. """
        if DB.__instance is not None:
            raise Exception("This class is a singleton!")
        else:
            DB.__instance = DB.start_pool()
            click.echo('Initialized the database.')

    @staticmethod
    def init_session(connection, requestedTag_ignored):
        cursor = connection.cursor()
        cursor.execute("""
            ALTER SESSION SET
              TIME_ZONE = 'UTC'
              NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI'""")
        # return cursor

    # start_pool(): starts the connection pool
    @staticmethod
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
                                     sessionCallback=DB.init_session)

        return pool
###########
