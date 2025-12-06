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
   export FLASK_APP=run.py      # Windows PowerShell: $env:FLASK_APP="run.py"
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
