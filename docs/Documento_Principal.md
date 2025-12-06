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
