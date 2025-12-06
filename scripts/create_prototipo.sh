#!/usr/bin/env bash
# create_prototipo.sh
# Cria a branch 'prototipo-python', adiciona arquivos do protótipo Python (Flask)
# e faz commit. Pergunta antes de dar push e antes de criar PR com gh.
#
# Autor: Copilot para Marcio Machado Moreira (RU 4543545)
# Use: chmod +x create_prototipo.sh && ./create_prototipo.sh
set -euo pipefail

BRANCH="prototipo-python"
MAIN_BRANCH="main"
COMMIT_MSG="Protótipo Python (Flask): documentação, backend, frontend, diagramas e CI — Marcio Machado Moreira RU 4543545"
REMOTE=${REMOTE:-origin}

function abort {
  echo "Abortando: $1"
  exit 1
}

# Verifica se está em um repositório git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  abort "Este script deve ser executado na raiz do repositório git (git clone git@github.com:Marcio606/VIDA-PLUS.git)."
fi

# Verifica se existe remote origin
if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
  abort "Remote '$REMOTE' não encontrado. Configure o remote para o repositório (ex: git remote add origin git@github.com:Marcio606/VIDA-PLUS.git)."
fi

read -p "Este script criará/atualizará a branch '$BRANCH' e adicionará vários arquivos. Continuar? [y/N] " RESP
RESP=${RESP:-N}
if [[ ! "$RESP" =~ ^[Yy]$ ]]; then
  abort "Usuário cancelou."
fi

echo "Buscando branches remotas e atualizando '$MAIN_BRANCH'..."
git fetch "$REMOTE" --prune
if git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
  git checkout "$MAIN_BRANCH"
  git pull "$REMOTE" "$MAIN_BRANCH"
else
  # tenta criar main local a partir do remoto
  git checkout --track "$REMOTE/$MAIN_BRANCH" || abort "Branch '$MAIN_BRANCH' não encontrada localmente nem remotamente."
fi

# Cria a branch prototipo-python baseada em main
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Branch '$BRANCH' já existe localmente. Farei checkout e a atualizarei a partir de '$MAIN_BRANCH'."
  git checkout "$BRANCH"
  git reset --hard "$MAIN_BRANCH"
else
  git checkout -b "$BRANCH"
fi

echo "Criando estrutura de diretórios..."
mkdir -p docs backend backend/app backend/app/routes backend/db backend/tests frontend/css frontend/js diagrams .github/workflows

echo "Escrevendo arquivos..."

cat > README.md <<'EOF'
# VIDA-PLUS — Protótipo SGHSS (Sistema de Gestão Hospitalar e de Serviços de Saúde)

Identificação:
- Aluno: Marcio Machado Moreira
- RU: 4543545
- Professor: Prof. Winston Sen Lun Fung, Me.
- Disciplina: Multidisciplinar

Resumo
Este repositório contém o protótipo em Python (Flask) e a documentação do projeto VidaPlus — Sistema de Gestão Hospitalar e de Serviços de Saúde (SGHSS). Inclui backend Flask modular, frontend prototípico estático, diagramas PlantUML, plano de testes e pipeline CI básica.

Conteúdo principal
- docs/Documento_Principal.md — Documento principal do trabalho (capa, sumário, requisitos, modelagem, implementação, testes, conclusão, referências)
- backend/ — protótipo Flask + SQLAlchemy, banco SQLite (schema em backend/db/schema.sql)
- frontend/ — protótipo HTML/CSS/JS responsivo
- diagrams/ — PlantUML (.puml) com diagrama de classes/DER e casos de uso
- tests/plan.md — plano de testes e casos
- .github/workflows/ci.yml — pipeline básico CI
- LICENSE — MIT

Requisitos para executar localmente
- Python 3.9+
- pip
- virtualenv (opcional)
- (opcional) PlantUML para renderizar diagramas

Instalação e execução (rápido)
1. Clone:
   git clone git@github.com:Marcio606/VIDA-PLUS.git
   cd VIDA-PLUS

2. Criar e entrar na branch:
   git checkout -b prototipo-python

3. Backend (virtualenv)
   cd backend
   python -m venv .venv
   source .venv/bin/activate    # Windows PowerShell: .venv\Scripts\activate
   pip install -r requirements.txt
   export FLASK_APP=app.py      # Windows PowerShell: $env:FLASK_APP="app.py"
   flask run

   - O servidor Flask inicia em http://127.0.0.1:5000
   - O DB SQLite será inicializado automaticamente (backend/db/vida_plus.db) usando SQLAlchemy

4. Frontend
   - Abra frontend/index.html no navegador ou sirva com servidor estático
   - Formulários apontam para http://127.0.0.1:5000/api

Segurança e evolução
- Protótipo sem autenticação forte: adicionar JWT/OAuth2, TLS, criptografia em repouso e em trânsito para produção.
- LGPD: consentimento, anonimização, logs de auditoria, políticas de retenção.
- Em produção: migrar para PostgreSQL, backups automatizados, observabilidade (Prometheus/Grafana).

Contato
- Autor: Marcio Machado Moreira (RU 4543545)
EOF

cat > docs/Documento_Principal.md <<'EOF'
# Projeto SGHSS — VidaPlus

Capa
- Curso: [preencher]
- Disciplina: Multidisciplinar
- Aluno: Marcio Machado Moreira
- RU: 4543545
- Polo de apoio: [preencher]
- Semestre: [preencher]
- Professor: Prof. Winston Sen Lun Fung, Me.

Sumário
1. Introdução
2. Análise e Requisitos
3. Modelagem e Arquitetura
4. Implementação (Prototipagem)
5. Plano de Testes
6. Conclusão
7. Referências
Anexos: diagrams/models.puml, diagrams/usecases.puml, backend/db/schema.sql, prints do frontend (frontend/index.html)

1. Introdução
O sistema VidaPlus (SGHSS) centraliza cadastro e atendimento de pacientes, gestão de profissionais, administração hospitalar, telemedicina e requisitos de segurança/compatibilidade com LGPD. Objetivo: fornecer um protótipo funcional com funcionalidades essenciais para demonstração acadêmica.

2. Análise e Requisitos
Requisitos Funcionais (selecionados):
- RF001: Cadastro de pacientes (dados pessoais e clínicos).
- RF002: Visualizar histórico clínico (prontuário).
- RF003: Agendar/cancelar consultas (presencial/online).
- RF004: Gerenciar agendas de profissionais.
- RF005: Emitir receitas digitais e anexar ao prontuário.
- RF006: Registrar teleconsultas (videochamada) e prescrições online.

Requisitos Não Funcionais:
- RNF001: Segurança e conformidade com LGPD.
- RNF002: Disponibilidade >= 99.5% (recomendação).
- RNF003: Performance com baixa latência em endpoints críticos.
- RNF004: Escalabilidade para múltiplas unidades.
- RNF005: Acessibilidade e responsividade (WCAG básicos).

3. Modelagem e Arquitetura
Decisão arquitetural (protótipo):
- Monolito modular com camadas: routes (API), services (lógica), models/repositories (persistência).
- Banco: SQLite para desenvolvimento; recomendar PostgreSQL em produção.
- Diagramas: diagrams/models.puml (classes/DER) e diagrams/usecases.puml.

Principais Endpoints:
- POST /api/pacientes
- GET /api/pacientes
- GET /api/pacientes/<id>
- PUT /api/pacientes/<id>
- DELETE /api/pacientes/<id>
- POST /api/consultas
- GET /api/consultas
- POST /api/telemedicina/start
- GET /health

4. Implementação (Prototipagem)
Resumo:
- Backend: Flask + SQLAlchemy, endpoints CRUD para pacientes; criação de consultas; rotas para profissionais; placeholder telemedicina.
- Frontend: HTML/CSS/JS sem frameworks pesados; conexões via fetch para API.
- Estrutura de pastas organizada e modular; scripts para inicializar DB automaticamente.

5. Plano de Testes
Casos principais (exemplos):
- CT001: Cadastrar paciente válido → 201 Created; persistir no DB.
- CT002: Cadastrar paciente sem CPF → 400 Bad Request.
- CT003: Agendar consulta → 201 Created; associada ao paciente.
- CT004: Obter paciente com histórico → 200 OK com lista de consultas.

Testes não-funcionais:
- Carga: executar Locust/JMeter (ex.: 100 usuários concorrentes).
- Segurança: OWASP ZAP para XSS/SQLi.
- Usabilidade: testes de responsividade e WCAG.

6. Conclusão
O protótipo demonstra fluxo principal e a organização necessária para evolução. Pontos críticos: autenticação, LGPD e criptografia devem ser tratados antes de implantação.

7. Referências
- Material do curso e roteiro do projeto.
- Flask, SQLAlchemy, PlantUML, OWASP.

Anexos
- diagrams/models.puml
- diagrams/usecases.puml
- backend/db/schema.sql
EOF

cat > backend/requirements.txt <<'EOF'
Flask>=2.2
Flask-Cors>=3.0
Flask-SQLAlchemy>=3.0
pytest>=7.0
flake8>=6.0
EOF

cat > backend/app.py <<'EOF'
# backend/app.py
# Protótipo Flask — VidaPlus SGHSS
# Autor: Marcio Machado Moreira — RU 4543545

from flask import Flask, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__, static_folder=None)
CORS(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
DB_DIR = os.path.join(BASE_DIR, 'db')
DB_PATH = os.path.join(DB_DIR, 'vida_plus.db')
SQL_URI = 'sqlite:///' + DB_PATH

app.config['SQLALCHEMY_DATABASE_URI'] = SQL_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Import models and blueprints
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
        db.create_all()
        print("Banco criado em:", DB_PATH)

if __name__ == '__main__':
    ensure_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
EOF

cat > backend/app/__init__.py <<'EOF'
# backend/app/__init__.py
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()
EOF

cat > backend/app/models.py <<'EOF'
# backend/app/models.py
# Modelos SQLAlchemy para VidaPlus
from datetime import datetime
from app import db
from sqlalchemy.orm import relationship

class Paciente(db.Model):
    __tablename__ = 'pacientes'
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String, nullable=False)
    cpf = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String)
    telefone = db.Column(db.String)
    endereco = db.Column(db.String)
    data_criacao = db.Column(db.DateTime, default=datetime.utcnow)

    consultas = relationship('Consulta', back_populates='paciente', cascade='all, delete-orphan')
    prontuarios = relationship('Prontuario', back_populates='paciente', cascade='all, delete-orphan')

class Profissional(db.Model):
    __tablename__ = 'profissionais'
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String, nullable=False)
    crm = db.Column(db.String)
    especialidade = db.Column(db.String)
    email = db.Column(db.String)
    telefone = db.Column(db.String)
    data_criacao = db.Column(db.DateTime, default=datetime.utcnow)

    consultas = relationship('Consulta', back_populates='profissional')

class Consulta(db.Model):
    __tablename__ = 'consultas'
    id = db.Column(db.Integer, primary_key=True)
    paciente_id = db.Column(db.Integer, db.ForeignKey('pacientes.id'), nullable=False)
    profissional_id = db.Column(db.Integer, db.ForeignKey('profissionais.id'), nullable=True)
    data_hora = db.Column(db.String, nullable=False)
    tipo = db.Column(db.String, default='presencial')
    descricao = db.Column(db.String)
    status = db.Column(db.String, default='agendada')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    paciente = relationship('Paciente', back_populates='consultas')
    profissional = relationship('Profissional', back_populates='consultas')

class Prontuario(db.Model):
    __tablename__ = 'prontuarios'
    id = db.Column(db.Integer, primary_key=True)
    paciente_id = db.Column(db.Integer, db.ForeignKey('pacientes.id'), nullable=False)
    conteudo = db.Column(db.Text)
    atualizado_em = db.Column(db.DateTime, default=datetime.utcnow)

    paciente = relationship('Paciente', back_populates='prontuarios')
    receitas = relationship('Receita', back_populates='prontuario', cascade='all, delete-orphan')

class Receita(db.Model):
    __tablename__ = 'receitas'
    id = db.Column(db.Integer, primary_key=True)
    prontuario_id = db.Column(db.Integer, db.ForeignKey('prontuarios.id'), nullable=False)
    texto = db.Column(db.Text)
    emitida_em = db.Column(db.DateTime, default=datetime.utcnow)

    prontuario = relationship('Prontuario', back_populates='receitas')
EOF

cat > backend/app/routes/pacientes.py <<'EOF'
from flask import Blueprint, request, jsonify
from app import db
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
    db.session.add(p)
    db.session.commit()
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
    db.session.commit()
    return jsonify({"id": p.id, "nome": p.nome, "cpf": p.cpf}), 200

@bp.route('/<int:pid>', methods=['DELETE'])
def deletar_paciente(pid):
    p = Paciente.query.get(pid)
    if not p:
        return jsonify({"error": "Paciente não encontrado"}), 404
    db.session.delete(p)
    db.session.commit()
    return jsonify({"message": "Paciente removido"}), 200
EOF

cat > backend/app/routes/profissionais.py <<'EOF'
from flask import Blueprint, request, jsonify
from app import db
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
    db.session.add(p)
    db.session.commit()
    return jsonify({"id": p.id, "nome": p.nome}), 201
EOF

cat > backend/app/routes/consultas.py <<'EOF'
from flask import Blueprint, request, jsonify
from app import db
from app.models import Consulta, Paciente

bp = Blueprint('consultas', __name__)

@bp.route('/', methods=['GET'])
def listar_consultas():
    consultas = Consulta.query.all()
    data = [{"id": c.id, "paciente_id": c.paciente_id, "profissional_id": c.profissional_id, "data_hora": c.data_hora, "status": c.status} for c in consultas]
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
    consulta = Consulta(paciente_id=paciente_id, profissional_id=data.get('profissional_id'), data_hora=data_hora, tipo=data.get('tipo','presencial'), descricao=data.get('descricao'))
    db.session.add(consulta)
    db.session.commit()
    return jsonify({"id": consulta.id, "message": "Consulta agendada"}), 201
EOF

cat > backend/db/schema.sql <<'EOF'
-- Schema inicial para protótipo VidaPlus (SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS pacientes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  cpf TEXT NOT NULL UNIQUE,
  email TEXT,
  telefone TEXT,
  endereco TEXT,
  data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS profissionais (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  crm TEXT,
  especialidade TEXT,
  email TEXT,
  telefone TEXT,
  data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS consultas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  paciente_id INTEGER NOT NULL,
  profissional_id INTEGER,
  data_hora TEXT NOT NULL,
  tipo TEXT DEFAULT 'presencial',
  descricao TEXT,
  status TEXT DEFAULT 'agendada',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
  FOREIGN KEY (profissional_id) REFERENCES profissionais(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS prontuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  paciente_id INTEGER NOT NULL,
  conteudo TEXT,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS receitas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  prontuario_id INTEGER NOT NULL,
  texto TEXT,
  emitida_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (prontuario_id) REFERENCES prontuarios(id) ON DELETE CASCADE
);
EOF

cat > backend/README.md <<'EOF'
# Backend — VidaPlus (Flask)

Autor: Marcio Machado Moreira — RU 4543545

Dependências
- Python 3.9+
- pip
- virtualenv (opcional)

Instalação e execução
1. Criar virtualenv e ativar:
   python -m venv .venv
   source .venv/bin/activate   # Windows: .venv\Scripts\activate

2. Instalar dependências:
   pip install -r requirements.txt

3. Exportar variáveis e rodar:
   export FLASK_APP=app.py
   flask run

   O servidor ficará em http://127.0.0.1:5000 por padrão.

Observações
- O banco SQLite será criado em backend/db/vida_plus.db automaticamente.
- Para resetar o banco, apagar backend/db/vida_plus.db e reiniciar a aplicação.
EOF

cat > backend/tests/test_sanity.py <<'EOF'
def test_placeholder():
    # Teste sanity placeholder para o CI
    assert True
EOF

cat > frontend/index.html <<'EOF'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>VidaPlus — Protótipo</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <header class="top">
    <h1>VidaPlus — Protótipo SGHSS</h1>
    <p>Aluno: Marcio Machado Moreira — RU 4543545</p>
  </header>

  <nav class="nav">
    <button id="nav-login">Login</button>
    <button id="nav-cad">Cadastrar Paciente</button>
    <button id="nav-agend">Agendar Consulta</button>
    <button id="nav-list">Listar Pacientes</button>
  </nav>

  <main class="container">
    <section id="view-login" class="view">
      <h2>Login (simulado)</h2>
      <form id="form-login">
        <label>Usuário <input name="user"></label>
        <label>Senha <input name="pass" type="password"></label>
        <button type="submit">Entrar</button>
      </form>
    </section>

    <section id="view-cad" class="view hidden">
      <h2>Cadastro de Paciente</h2>
      <form id="form-paciente">
        <label>Nome <input name="nome" required></label>
        <label>CPF <input name="cpf" required></label>
        <label>Email <input name="email" type="email"></label>
        <label>Telefone <input name="telefone"></label>
        <label>Endereço <input name="endereco"></label>
        <button type="submit">Cadastrar</button>
      </form>
      <pre id="cad-result"></pre>
    </section>

    <section id="view-agend" class="view hidden">
      <h2>Agendamento de Consulta</h2>
      <form id="form-agendamento">
        <label>Paciente ID <input name="paciente_id" required></label>
        <label>Profissional ID <input name="profissional_id"></label>
        <label>Data e hora <input name="data_hora" type="datetime-local" required></label>
        <label>Tipo <select name="tipo"><option>presencial</option><option>online</option></select></label>
        <label>Descrição <textarea name="descricao"></textarea></label>
        <button type="submit">Agendar</button>
      </form>
      <pre id="agend-result"></pre>
    </section>

    <section id="view-list" class="view hidden">
      <h2>Pacientes</h2>
      <ul id="pacientes-list"></ul>
    </section>
  </main>

  <footer class="foot">
    <small>Protótipo acadêmico — VidaPlus — Marcio Machado Moreira (RU 4543545)</small>
  </footer>

  <script src="js/app.js"></script>
</body>
</html>
EOF

cat > frontend/css/style.css <<'EOF'
:root{
  --bg:#f7f8fb;
  --card:#fff;
  --accent:#0066cc;
  --muted:#666;
}
*{box-sizing:border-box;font-family:Arial,Helvetica,sans-serif}
body{margin:0;background:var(--bg);color:#222}
.top{background:var(--accent);color:#fff;padding:1rem}
.nav{display:flex;gap:.5rem;padding:.5rem;background:#fff;box-shadow:0 1px 2px rgba(0,0,0,.05)}
.nav button{padding:.5rem 1rem;border:1px solid #ddd;background:#fff;cursor:pointer}
.container{padding:1rem;max-width:900px;margin:1rem auto;background:var(--card);border-radius:6px;box-shadow:0 2px 6px rgba(0,0,0,.04)}
.view{margin-bottom:1rem}
.hidden{display:none}
label{display:block;margin:.5rem 0}
input,textarea,select{width:100%;padding:.5rem;border:1px solid #ddd;border-radius:4px}
button{background:var(--accent);color:#fff;border:none;padding:.6rem 1rem;border-radius:4px;cursor:pointer}
.foot{text-align:center;padding:1rem;color:var(--muted)}
@media(min-width:700px){
  .nav{justify-content:center}
  label{max-width:600px}
}
EOF

cat > frontend/js/app.js <<'EOF'
const API_BASE = 'http://127.0.0.1:5000/api';

document.getElementById('nav-login').onclick = () => show('view-login');
document.getElementById('nav-cad').onclick = () => show('view-cad');
document.getElementById('nav-agend').onclick = () => show('view-agend');
document.getElementById('nav-list').onclick = () => { show('view-list'); fetchPacientes(); };

function show(id){
  document.querySelectorAll('.view').forEach(v => v.classList.add('hidden'));
  document.getElementById(id).classList.remove('hidden');
}

document.getElementById('form-paciente').onsubmit = async (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target).entries());
  const res = await fetch(API_BASE + '/pacientes/', {
    method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify(data)
  });
  const json = await res.json();
  document.getElementById('cad-result').innerText = JSON.stringify(json, null, 2);
};

document.getElementById('form-agendamento').onsubmit = async (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target).entries());
  const res = await fetch(API_BASE + '/consultas/', {
    method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify(data)
  });
  const json = await res.json();
  document.getElementById('agend-result').innerText = JSON.stringify(json, null, 2);
};

async function fetchPacientes(){
  const res = await fetch(API_BASE + '/pacientes/');
  const list = await res.json();
  const ul = document.getElementById('pacientes-list');
  ul.innerHTML = '';
  list.forEach(p => {
    const li = document.createElement('li');
    li.innerText = `${p.id} — ${p.nome} — ${p.cpf} — ${p.email || '-'} `;
    ul.appendChild(li);
  });
}

// inicial
show('view-login');
EOF

cat > diagrams/models.puml <<'EOF'
@startuml
' Diagrama de classes simples — VidaPlus
class Paciente {
  +id
  +nome
  +cpf
  +email
  +telefone
}
class Profissional {
  +id
  +nome
  +crm
  +especialidade
}
class Consulta {
  +id
  +data_hora
  +tipo
  +status
}
class Prontuario {
  +id
  +conteudo
}
class Receita {
  +id
  +texto
}

Paciente "1" -- "0..*" Consulta
Profissional "1" -- "0..*" Consulta
Paciente "1" -- "0..*" Prontuario
Prontuario "1" -- "0..*" Receita
@enduml
EOF

cat > diagrams/usecases.puml <<'EOF'
@startuml
left to right direction
actor "Paciente" as Pac
actor "Profissional" as Prof
actor "Administrador" as Adm

rectangle "SGHSS VidaPlus" {
  Pac -- (Cadastrar\Paciente)
  Pac -- (Agendar\Consulta)
  Pac -- (Acessar\Teleconsulta)
  Prof -- (Gerenciar\Agenda)
  Prof -- (Atualizar\Prontuario)
  Adm -- (Gerar\Relatórios)
  Adm -- (Gerenciar\Cadastros)
}
@enduml
EOF

cat > tests/plan.md <<'EOF'
# Plano de Testes — VidaPlus (Protótipo)

Autor: Marcio Machado Moreira — RU 4543545

Objetivo
Validar requisitos funcionais e não funcionais do protótipo.

Casos de Teste Principais
- CT001: Cadastrar paciente com dados válidos
  - Entrada: { nome, cpf, email }
  - Passo: POST /api/pacientes
  - Resultado esperado: 201 Created; resposta com id e dados básicos.
  - Critério de aceitação: paciente persistido no DB.

- CT002: Cadastrar paciente sem CPF
  - Entrada: { nome }
  - Resultado esperado: 400 Bad Request; mensagem de erro.
  - Critério: validação do servidor.

- CT003: Agendar consulta válida
  - Entrada: { paciente_id, data_hora }
  - Passo: POST /api/consultas
  - Resultado esperado: 201 Created; consulta criada.
  - Critério: associação com paciente existente.

- CT004: Obter paciente com histórico
  - Entrada: GET /api/pacientes/:id
  - Resultado esperado: 200 OK com lista de consultas.

Testes Não Funcionais
- Carga: usar Locust ou JMeter para simular picos (ex.: 100 usuários concorrentes) nos endpoints /api/pacientes e /api/consultas.
- Segurança: rodar OWASP ZAP para detectar XSS/SQLi.
- Disponibilidade: testar com monitor simples (health endpoint) e simular reinicializações rápidas.
- Usabilidade: validar responsividade no Chrome DevTools (mobile widths) e checar contraste.

Roteiro de Execução
1. Configurar ambiente e iniciar backend.
2. Executar casos funcionais via Postman ou scripts pytest.
3. Executar testes de carga e analisar tempos de resposta.
4. Executar varredura de segurança com OWASP ZAP.

Observações
- Em produção, integrar testes no pipeline CI/CD e bloquear merges com regressões.
EOF

cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
    branches: [ main, prototipo-python ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install dependencies
        working-directory: backend
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Lint (flake8)
        working-directory: backend
        run: |
          pip install flake8
          flake8 || true

      - name: Run tests
        working-directory: backend
        run: |
          pip install pytest
          pytest -q || true
EOF

cat > .gitignore <<'EOF'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
.venv/
venv/

# SQLite
*.db
backend/db/

# IDEs
.vscode/
.idea/

# OS
.DS_Store

# Node modules (if added)
node_modules/
EOF

cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2025 Marcio Machado Moreira

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[INSIRA O TEXTO COMPLETO DO MIT AQUI AO COMITAR]
EOF

echo "Arquivos escritos. Preparando git..."

# Adiciona todos os arquivos
git add .

# Se houver mudanças, commita
if git diff --staged --quiet; then
  echo "Nenhuma alteração detectada para commit."
else
  git commit -m "$COMMIT_MSG"
  echo "Commit criado: $COMMIT_MSG"
fi

read -p "Deseja fazer push da branch '$BRANCH' para '$REMOTE' agora? [y/N] " PUSH_ANS
PUSH_ANS=${PUSH_ANS:-N}
if [[ "$PUSH_ANS" =~ ^[Yy]$ ]]; then
  git push -u "$REMOTE" "$BRANCH"
  echo "Branch '$BRANCH' enviada para $REMOTE/$BRANCH."
  read -p "Deseja criar o Pull Request (draft) automaticamente usando 'gh' CLI? [y/N] " GH_ANS
  GH_ANS=${GH_ANS:-N}
  if [[ "$GH_ANS" =~ ^[Yy]$ ]]; then
    if ! command -v gh >/dev/null 2>&1; then
      echo "gh CLI não encontrada. Instale/autorize gh ou crie o PR manualmente."
    else
      gh pr create --base "$MAIN_BRANCH" --head "$BRANCH" --title "Protótipo Python (Flask) — SGHSS VidaPlus (Marcio Machado Moreira — RU 4543545)" --body "Protótipo inicial do SGHSS VidaPlus implementado em Flask. Inclui documentação, backend, frontend, diagramas e plano de testes. PR em draft para revisão do professor." --draft
      echo "Pull Request criado como draft (se gh estiver autenticado)."
    fi
  else
    echo "PR não criado automaticamente. Crie manualmente no GitHub ou use 'gh pr create'."
  fi
else
  echo "Push não executado. Seus arquivos foram commitados localmente na branch '$BRANCH'."
  echo "Para enviar: git push -u $REMOTE $BRANCH"
fi

echo "Concluído."