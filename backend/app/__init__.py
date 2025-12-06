# backend/app/__init__.py
# Flask application factory and database initialization
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__, static_folder=None)
CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
BACKEND_DIR = os.path.dirname(BASE_DIR)
DB_DIR = os.path.join(BACKEND_DIR, 'db')
DB_PATH = os.path.join(DB_DIR, 'vida_plus.db')
SQL_URI = 'sqlite:///' + DB_PATH

app.config['SQLALCHEMY_DATABASE_URI'] = SQL_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
