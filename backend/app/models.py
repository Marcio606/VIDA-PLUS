# backend/app/models.py
# Modelos SQLAlchemy para VidaPlus
from datetime import datetime
from sqlalchemy.orm import relationship
from app import db


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
