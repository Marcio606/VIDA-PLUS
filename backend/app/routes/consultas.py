from flask import Blueprint, request, jsonify
from app import db
from app.models import Consulta, Paciente


bp = Blueprint('consultas', __name__)


@bp.route('/', methods=['GET'])
def listar_consultas():
    consultas = Consulta.query.all()
    data = [
        {
            "id": c.id, "paciente_id": c.paciente_id,
            "profissional_id": c.profissional_id,
            "data_hora": c.data_hora, "status": c.status
        } for c in consultas
    ]
    return jsonify(data), 200


@bp.route('/', methods=['POST'])
def agendar_consulta():
    data = request.get_json() or {}
    paciente_id = data.get('paciente_id')
    data_hora = data.get('data_hora')
    if not paciente_id or not data_hora:
        return jsonify({"error": "paciente_id e data_hora são obrigatórios"}), 400
    paciente = Paciente.query.get(paciente_id)
    if not paciente:
        return jsonify({"error": "Paciente não encontrado"}), 404
    consulta = Consulta(
        paciente_id=paciente_id,
        profissional_id=data.get('profissional_id'),
        data_hora=data_hora,
        tipo=data.get('tipo', 'presencial'),
        descricao=data.get('descricao')
    )
    db.session.add(consulta)
    db.session.commit()
    return jsonify({"id": consulta.id, "message": "Consulta agendada"}), 201
