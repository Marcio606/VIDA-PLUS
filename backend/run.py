# backend/run.py
# Protótipo Flask — VidaPlus SGHSS
# Autor: Marcio Machado Moreira — RU 4543545

from flask import Flask, jsonify
from flask_cors import CORS
import os


def create_app():
    app = Flask(__name__, static_folder=None)
    CORS(app)

    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    DB_DIR = os.path.join(BASE_DIR, 'db')
    DB_PATH = os.path.join(DB_DIR, 'vida_plus.db')
    SQL_URI = 'sqlite:///' + DB_PATH

    app.config['SQLALCHEMY_DATABASE_URI'] = SQL_URI
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # Initialize db with app
    from app import db as database
    database.init_app(app)

    # Import models and blueprints after db initialization
    with app.app_context():
        from app.models import Paciente, Profissional, Consulta, Prontuario, Receita  # noqa: E402, F401
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
                database.create_all()
            print("Banco criado em:", DB_PATH)

    ensure_db()
    return app


app = create_app()


if __name__ == '__main__':
    # Note: Debug mode is disabled for security. Use a production WSGI server for deployment.
    app.run(host='0.0.0.0', port=5000, debug=False)
