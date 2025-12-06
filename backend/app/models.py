# backend/app/models.py
# Modelos SQLAlchemy para VidaPlus
from datetime import datetime
from sqlalchemy.orm import relationship

# Import app package - db will be set before models are imported in app.py
import app

# Create classes using app.db which will be set before import
class Paciente(app.db.Model):
    __tablename__ = 'pacientes'
    id = app.db.Column(app.db.Integer, primary_key=True)
    nome = app.db.Column(app.db.String, nullable=False)
    cpf = app.db.Column(app.db.String, unique=True, nullable=False)
    email = app.db.Column(app.db.String)
    telefone = app.db.Column(app.db.String)
    endereco = app.db.Column(app.db.String)
    data_criacao = app.db.Column(app.db.DateTime, default=datetime.utcnow)

    consultas = relationship('Consulta', back_populates='paciente', cascade='all, delete-orphan')
    prontuarios = relationship('Prontuario', back_populates='paciente', cascade='all, delete-orphan')

class Profissional(app.db.Model):
    __tablename__ = 'profissionais'
    id = app.db.Column(app.db.Integer, primary_key=True)
    nome = app.db.Column(app.db.String, nullable=False)
    crm = app.db.Column(app.db.String)
    especialidade = app.db.Column(app.db.String)
    email = app.db.Column(app.db.String)
    telefone = app.db.Column(app.db.String)
    data_criacao = app.db.Column(app.db.DateTime, default=datetime.utcnow)

    consultas = relationship('Consulta', back_populates='profissional')

class Consulta(app.db.Model):
    __tablename__ = 'consultas'
    id = app.db.Column(app.db.Integer, primary_key=True)
    paciente_id = app.db.Column(app.db.Integer, app.db.ForeignKey('pacientes.id'), nullable=False)
    profissional_id = app.db.Column(app.db.Integer, app.db.ForeignKey('profissionais.id'), nullable=True)
    data_hora = app.db.Column(app.db.String, nullable=False)
    tipo = app.db.Column(app.db.String, default='presencial')
    descricao = app.db.Column(app.db.String)
    status = app.db.Column(app.db.String, default='agendada')
    created_at = app.db.Column(app.db.DateTime, default=datetime.utcnow)

    paciente = relationship('Paciente', back_populates='consultas')
    profissional = relationship('Profissional', back_populates='consultas')

class Prontuario(app.db.Model):
    __tablename__ = 'prontuarios'
    id = app.db.Column(app.db.Integer, primary_key=True)
    paciente_id = app.db.Column(app.db.Integer, app.db.ForeignKey('pacientes.id'), nullable=False)
    conteudo = app.db.Column(app.db.Text)
    atualizado_em = app.db.Column(app.db.DateTime, default=datetime.utcnow)

    paciente = relationship('Paciente', back_populates='prontuarios')
    receitas = relationship('Receita', back_populates='prontuario', cascade='all, delete-orphan')

class Receita(app.db.Model):
    __tablename__ = 'receitas'
    id = app.db.Column(app.db.Integer, primary_key=True)
    prontuario_id = app.db.Column(app.db.Integer, app.db.ForeignKey('prontuarios.id'), nullable=False)
    texto = app.db.Column(app.db.Text)
    emitida_em = app.db.Column(app.db.DateTime, default=datetime.utcnow)

    prontuario = relationship('Prontuario', back_populates='receitas')
