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
   export FLASK_APP=run.py
   flask run

   O servidor ficará em http://127.0.0.1:5000 por padrão.

Observações
- O banco SQLite será criado em backend/db/vida_plus.db automaticamente.
- Para resetar o banco, apagar backend/db/vida_plus.db e reiniciar a aplicação.
