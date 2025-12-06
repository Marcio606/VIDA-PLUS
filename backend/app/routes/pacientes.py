from flask import Blueprint, request, jsonify
import app
from app.models import Paciente

bp = Blueprint('pacientes', __name__)

@bp.route('/', methods=['GET'])
def listar_pacientes():
    pacientes = Paciente.query.all()
    data = [{"id": p.id, "nome": p.nome, "cpf": p.cpf, "email": p.email} for p in pacientes]
    return jsonify(data), 200

@bp.route('/<int:pid>', methods=['GET'])
def obter_paciente(pid):
    p = Paciente.query.get(pid)
    if not p:
        return jsonify({"error": "Paciente não encontrado"}), 404
    consultas = [{"id": c.id, "data_hora": c.data_hora, "descricao": c.descricao} for c in p.consultas]
    return jsonify({
        "id": p.id,
        "nome": p.nome,
        "cpf": p.cpf,
        "email": p.email,
        "telefone": p.telefone,
        "endereco": p.endereco,
        "consultas": consultas
    }), 200

@bp.route('/', methods=['POST'])
def criar_paciente():
    data = request.get_json() or {}
    nome = data.get('nome')
    cpf = data.get('cpf')
    if not nome or not cpf:
        return jsonify({"error": "nome e cpf são obrigatórios"}), 400
    existe = Paciente.query.filter_by(cpf=cpf).first()
    if existe:
        return jsonify({"error": "CPF já cadastrado"}), 400
    p = Paciente(nome=nome, cpf=cpf, email=data.get('email'), telefone=data.get('telefone'), endereco=data.get('endereco'))
    app.db.session.add(p)
    app.db.session.commit()
    return jsonify({"id": p.id, "nome": p.nome, "cpf": p.cpf}), 201

@bp.route('/<int:pid>', methods=['PUT'])
def atualizar_paciente(pid):
    p = Paciente.query.get(pid)
    if not p:
        return jsonify({"error": "Paciente não encontrado"}), 404
    data = request.get_json() or {}
    p.nome = data.get('nome', p.nome)
    p.cpf = data.get('cpf', p.cpf)
    p.email = data.get('email', p.email)
    p.telefone = data.get('telefone', p.telefone)
    p.endereco = data.get('endereco', p.endereco)
    app.db.session.commit()
    return jsonify({"id": p.id, "nome": p.nome, "cpf": p.cpf}), 200

@bp.route('/<int:pid>', methods=['DELETE'])
def deletar_paciente(pid):
    p = Paciente.query.get(pid)
    if not p:
        return jsonify({"error": "Paciente não encontrado"}), 404
    app.db.session.delete(p)
    app.db.session.commit()
    return jsonify({"message": "Paciente removido"}), 200
