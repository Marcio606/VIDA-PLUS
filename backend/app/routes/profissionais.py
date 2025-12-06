from flask import Blueprint, request, jsonify
import app
from app.models import Profissional

bp = Blueprint('profissionais', __name__)

@bp.route('/', methods=['GET'])
def listar_profissionais():
    pros = Profissional.query.all()
    data = [{"id": p.id, "nome": p.nome, "especialidade": p.especialidade} for p in pros]
    return jsonify(data), 200

@bp.route('/', methods=['POST'])
def criar_profissional():
    data = request.get_json() or {}
    nome = data.get('nome')
    if not nome:
        return jsonify({"error": "nome é obrigatório"}), 400
    p = Profissional(nome=nome, crm=data.get('crm'), especialidade=data.get('especialidade'), email=data.get('email'), telefone=data.get('telefone'))
    app.db.session.add(p)
    app.db.session.commit()
    return jsonify({"id": p.id, "nome": p.nome}), 201
