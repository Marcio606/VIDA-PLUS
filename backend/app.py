# backend/app.py
# Protótipo Flask — VidaPlus SGHSS
# Autor: Marcio Machado Moreira — RU 4543545

from flask import jsonify
import os

# Import app and db from the app package
from app import app, db

# Import models and blueprints (these will use db from app package)
from app.models import Paciente, Profissional, Consulta, Prontuario, Receita  # noqa: F401
from app.routes.pacientes import bp as pacientes_bp
from app.routes.profissionais import bp as profissionais_bp
from app.routes.consultas import bp as consultas_bp

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
    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    DB_DIR = os.path.join(BASE_DIR, 'db')
    DB_PATH = os.path.join(DB_DIR, 'vida_plus.db')
    if not os.path.exists(DB_DIR):
        os.makedirs(DB_DIR)
    if not os.path.exists(DB_PATH):
        with app.app_context():
            db.create_all()
        print("Banco criado em:", DB_PATH)

if __name__ == '__main__':
    ensure_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
