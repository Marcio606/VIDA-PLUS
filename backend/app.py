# backend/app.py
# Protótipo Flask — VidaPlus SGHSS
# Autor: Marcio Machado Moreira — RU 4543545

from flask import Flask, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os
import sys

# Ensure backend directory is in path for app package imports
sys.path.insert(0, os.path.dirname(__file__))

app = Flask(__name__, static_folder=None)
CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DB_DIR = os.path.join(BASE_DIR, 'db')
DB_PATH = os.path.join(DB_DIR, 'vida_plus.db')
SQL_URI = 'sqlite:///' + DB_PATH

app.config['SQLALCHEMY_DATABASE_URI'] = SQL_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Import models and blueprints - use late imports after db is created
# Import into app namespace so models can find db
import app as app_module
app_module.db = db

from app.models import Paciente, Profissional, Consulta, Prontuario, Receita  # noqa: E402
from app.routes.pacientes import bp as pacientes_bp  # noqa: E402
from app.routes.profissionais import bp as profissionais_bp  # noqa: E402
from app.routes.consultas import bp as consultas_bp  # noqa: E402

app.register_blueprint(pacientes_bp, url_prefix='/api/pacientes')
app.register_blueprint(profissionais_bp, url_prefix='/api/profissionais')
app.register_blueprint(consultas_bp, url_prefix='/api/consultas')

@app.route('/api/telemedicina/start', methods=['POST'])
def telemedicina_start():
    # Placeholder de teleconsulta — em produção integrar WebRTC
    return jsonify({"message": "Teleconsulta iniciada (placeholder)"}), 200

@app.route('/health')
def health():
    return jsonify({"status": "ok"}), 200

def ensure_db():
    if not os.path.exists(DB_DIR):
        os.makedirs(DB_DIR)
    if not os.path.exists(DB_PATH):
        with app.app_context():
            db.create_all()
            print("Banco criado em:", DB_PATH)

if __name__ == '__main__':
    ensure_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
