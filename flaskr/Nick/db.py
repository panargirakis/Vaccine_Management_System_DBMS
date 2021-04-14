import sqlite3
import cx_Oracle

import click
from flask import current_app, g
from flask.cli import with_appcontext



def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )

        # dsn_tns = cx_Oracle.makedsn('dbms-project.cdme8c3vmiwt.us-east-1.rds.amazonaws.com', '1521',
        #                             service_name='SYS$USERS')  # if needed, place an 'r' before any parameter in order to address special characters such as '\'.
        # g.db = cx_Oracle.connect(user=r'admin', password='PH19MpScBCeccKJmS2Zy',
        #                          dsn=dsn_tns)  # if needed, place an 'r' before any parameter in order to address special characters such as '\'. For example, if your user name contains '\', you'll need to place 'r' before the user name: user=r'User Name'

        g.db.row_factory = sqlite3.Row

    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

def init_db():
    db = get_db()

    with current_app.open_resource('Untitled.sql') as f:
        db.executescript(f.read().decode('utf8'))


@click.command('init-db')
@with_appcontext
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')

def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)


###########

