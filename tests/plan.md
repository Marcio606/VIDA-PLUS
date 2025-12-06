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
