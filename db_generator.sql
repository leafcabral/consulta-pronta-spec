CREATE DATABASE IF NOT EXISTS consultapronta;

CREATE TABLE IF NOT EXISTS paciente (
	id_paciente INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(100) NOT NULL,
	telefone VARCHAR(15) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL UNIQUE,
	cpf CHAR(11) NOT NULL UNIQUE,
	senha VARCHAR(255) NOT NULL,
	tipo_sanguineo VARCHAR(3),
	peso NUMERIC(5,2),
	altura SMALLINT,

	CONSTRAINT PK_PACIENTE
		PRIMARY KEY (id_paciente)
);

CREATE TABLE IF NOT EXISTS alergia (
	id_alergia INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	alergia VARCHAR(50) NOT NULL,

	CONSTRAINT PK_ALERGIA
		PRIMARY KEY (id_alergia),
	CONSTRAINT FK_ALERGIA_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS historico_familiar (
	id_historico_familiar INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	parente VARCHAR(50) NOT NULL,
	informacao VARCHAR(100) NOT NULL,

	CONSTRAINT PK_HISTORICO_FAMILIAR
		PRIMARY KEY (id_historico_familiar),
	CONSTRAINT FK_HISTORICO_FAMILIAR_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS profissional (
	id_profissional INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(100) NOT NULL,
	telefone VARCHAR(15) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL UNIQUE,
	cpf CHAR(11) NOT NULL UNIQUE,
	crm VARCHAR(10) NOT NULL UNIQUE,
	senha VARCHAR(255) NOT NULL,
	local_atuacao VARCHAR(100),

	CONSTRAINT PK_PROFISSIONAL
		PRIMARY KEY (id_profissional)
);

CREATE TABLE IF NOT EXISTS especialidade (
	id_especialidade INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(50) NOT NULL,
	descricao VARCHAR(100),

	CONSTRAINT PK_ESPECIALIDADE
		PRIMARY KEY (id_especialidade)
);

CREATE TABLE IF NOT EXISTS formacao (
	rqe INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_especialidade INTEGER NOT NULL,

	CONSTRAINT PK_FORMACAO
		PRIMARY KEY (rqe),
	CONSTRAINT FK_FORMACAO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE,
	CONSTRAINT FK_FORMACAO_id_especialidade
		FOREIGN KEY (id_especialidade)
		REFERENCES especialidade(id_especialidade)
		ON DELETE RESTRICT
);

-- LOG -> LOG_SISTEMA (palavra reservada)
CREATE TABLE IF NOT EXISTS log_sistema (
	id_log INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	conteudo VARCHAR(100) NOT NULL,
	data_hora TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT PK_LOG
		PRIMARY KEY (id_log),
	CONSTRAINT FK_LOG_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE,
	CONSTRAINT FK_LOG_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contato (
	id_contato INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	tipo VARCHAR(25),
	valor VARCHAR(100),

	CONSTRAINT PK_CONTATO
		PRIMARY KEY (id_contato),
	CONSTRAINT FK_CONTATO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE,
	CONSTRAINT FK_CONTATO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS consulta (
	id_consulta INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	id_hospital INTEGER NOT NULL,
	data_hora TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status VARCHAR(50) NOT NULL DEFAULT "pendente",

	CONSTRAINT PK_CONSULTA
		PRIMARY KEY (id_consulta),
	CONSTRAINT FK_CONSULTA_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES PROFISSIONAL(id_profissional)
		ON DELETE SET NULL,
	CONSTRAINT FK_CONSULTA_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE SET NULL,
	CONSTRAINT FK_CONSULTA_id_hospital
		FOREIGN KEY (id_hospital)
		REFERENCES hospital(id_hospital)
		ON DELETE SET NULL
);

-- local -> local_sintoma (aparentemente palavra reservada)
CREATE TABLE IF NOT EXISTS sintoma (
	id_sintoma INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	intensidade SMALLINT NOT NULL,
	data_inicio TIMESTAMPTZ NOT NULL,
	status VARCHAR(15) NOT NULL DEFAULT "presente",
	descricao VARCHAR(300),
	local_sintoma VARCHAR(50)

	CONSTRAINT PK_SINTOMA
		PRIMARY KEY (id_sintoma),
	CONSTRAINT FK_SINTOMA_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sintoma_historico (
	id_sintoma_historico INTEGER GENERATED ALWAYS AS IDENTITY,
	id_sintoma INTEGER NOT NULL,
	data_alteracao DATE NOT NULL,
	motivo VARCHAR(200) NOT NULL,
	valor_antigo JSONB NOT NULL,
	valor_novo JSONB NOT NULL,

	CONSTRAINT PK_SINTOMA_HSITORICO
		PRIMARY KEY (id_sintoma_historico),
	CONSTRAINT FK_SINTOMA_HISTORICO_id_sintoma
		FOREIGN KEY (id_sintoma)
		REFERENCES sintoma(id_sintoma)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS relatorio (
	id_relatorio INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	conteudo VARCHAR(200) NOT NULL,
	titulo VARCHAR(50) NOT NULL,
	data TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT PK_RELATORIO
		PRIMARY KEY (id_relatorio),
	CONSTRAINT FK_RELATORIO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES PACIENTE(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recurso (
	id_recurso INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(100) NOT NULL,
	categoria VARCHAR(100),
	quantidade INT NOT NULL DEFAULT 0,
	unidade_medida VARCHAR(20) NOT NULL,

	CONSTRAINT PK_RECURSO
		PRIMARY KEY (id_recurso)
);

CREATE TABLE IF NOT EXISTS hospital (
	id_hospital INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(50) NOT NULL,
	endereco VARCHAR(150) NOT NULL,
	lotacao SMALLINT,
	avaliacao SMALLINT,

	CONSTRAINT PK_HOSPITAL
		PRIMARY KEY (id_hospital)
);

CREATE TABLE IF NOT EXISTS autorizacao (
	id_autorizacao INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	data_hora_concessao TIMESTAMPTZ NOT NULL,
	data_hora_revogacao TIMESTAMPTZ NOT NULL,
	status VARCHAR(15) NOT NULL DEFAULT "ativo",

	CONSTRAINT PK_AUTORIZACAO
		PRIMARY KEY (id_autorizacao),
	CONSTRAINT FK_AUTORIZACAO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE SET NULL,
	CONSTRAINT FK_AUTORIZACAO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS anexo (
	id_anexo INTEGER GENERATED ALWAYS AS IDENTITY,
	id_sintoma INTEGER NOT NULL,
	id_medicamento INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	caminho VARCHAR(100) NOT NULL,
	data_upload TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT PK_ANEXO
		PRIMARY KEY (id_anexo),
	CONSTRAINT FK_ANEXO_id_sintoma
		FOREIGN KEY (id_sintoma)
		REFERENCES SINTOMA(id_sintoma)
		ON DELETE CASCADE,
	CONSTRAINT FK_ANEXO_id_medicamento
		FOREIGN KEY (id_medicamento)
		REFERENCES MEDICAMENTO(id_medicamento)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS medicamento (
	id_medicamento INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(50) NOT NULL,
	tipo_consumo VARCHAR(30) NOT NULL,
	dosagem_padrao VARCHAR(10) ,
	frequencia_padrao VARCHAR(10),
	indicacao_clinica VARCHAR(100),

	CONSTRAINT PK_MEDICAMENTO
		PRIMARY KEY (id_medicamento)
);

CREATE TABLE IF NOT EXISTS prescricao (
	id_prescricao INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	data DATE DEFAULT CURRENT_DATE,

	CONSTRAINT PK_PRESCRICAO
		PRIMARY KEY (id_prescricao),
	CONSTRAINT FK_PRESCRICAO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE,
	CONSTRAINT FK_PRESCRICAO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS item_prescricao (
	id_item INTEGER GENERATED ALWAYS AS IDENTITY,
	id_prescricao INTEGER NOT NULL,
	id_medicamento INTEGER NOT NULL,
	dosagem VARCHAR(10),
	frequencia VARCHAR(10),
	duracao VARCHAR(10) NOT NULL,
	consumido BOOLEAN NOT NULL,

	CONSTRAINT PK_ITEM_PRESCRICAO
		PRIMARY KEY (id_item),
	CONSTRAINT FK_ITEM_PRESCRICAO_id_prescricao
		FOREIGN KEY (id_prescricao)
		REFERENCES prescricao(id_prescricao)
		ON DELETE CASCADE,
	CONSTRAINT FK_ITEM_PRESCRICAO_id_medicamento
		FOREIGN KEY (id_medicamento)
		REFERENCES medicamento(id_medicamento)
		ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS automedicacao (
	id_automedicacao INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	id_medicamento INTEGER NOT NULL,
	motivacao VARCHAR(100) NOT NULL,
	data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
	consumido BOOLEAN NOT NULL,

	CONSTRAINT PK_AUTOMEDICACAO
		PRIMARY KEY (id_automedicacao),
	CONSTRAINT FK_AUTOMEDICACAO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE,
	CONSTRAINT FK_AUTOMEDICACAO_id_medicamento
		FOREIGN KEY (id_medicamento)
		REFERENCES medicamento(id_medicamento)
		ON DELETE RESTRICT
);

-- Registra -> RECURSO_PROFISSIONAL
CREATE TABLE IF NOT EXISTS recurso_profissional (
	id_profissional INTEGER NOT NULL,
	id_recurso INTEGER NOT NULL,

	CONSTRAINT PK_Registra
		PRIMARY KEY (id_profissional, id_recurso),
	CONSTRAINT FK_Registra_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE SET NULL,
	CONSTRAINT FK_Registra_id_recurso
		FOREIGN KEY (id_recurso)
		REFERENCES recurso(id_recurso)
		ON DELETE SET NULL
);

-- Contem -> SINTOMA_RELATORIO
CREATE TABLE IF NOT EXISTS sintoma_relatorio (
	id_sintoma INTEGER NOT NULL,
	id_relatorio INTEGER NOT NULL,

	CONSTRAINT PK_Contem
		PRIMARY KEY (id_sintoma, id_relatorio),
	CONSTRAINT FK_Contem_id_sintoma
		FOREIGN KEY (id_sintoma)
		REFERENCES sintoma(id_sintoma)
		ON DELETE RESTRICT,
	CONSTRAINT FK_Contem_id_relatorio
		FOREIGN KEY (id_relatorio)
		REFERENCES relatorio(id_relatorio)
		ON DELETE CASCADE
);

-- Pertence -> RECURSO_HOSPITAL
CREATE TABLE IF NOT EXISTS recurso_hospital (
	id_recurso INTEGER NOT NULL,
	id_hospital INTEGER NOT NULL,

	CONSTRAINT PK_Pertence
		PRIMARY KEY (id_recurso, id_hospital),
	CONSTRAINT FK_Pertence_id_recurso
		FOREIGN KEY (id_recurso)
		REFERENCES recurso(id_recurso)
		ON DELETE SET NULL,
	CONSTRAINT FK_Pertence_id_hospital
		FOREIGN KEY (id_hospital)
		REFERENCES hospital(id_hospital)
		ON DELETE CASCADE
);

-- Recebe -> RELATORIO_PROFISSIONAL
CREATE TABLE IF NOT EXISTS relatorio_profissional (
	id_relatorio INTEGER NOT NULL,
	id_profissional INTEGER NOT NULL,

	CONSTRAINT PK_Recebe
		PRIMARY KEY (id_relatorio, id_profissional),
	CONSTRAINT FK_Recebe_id_relatorio
		FOREIGN KEY (id_relatorio)
		REFERENCES relatorio(id_relatorio)
		ON DELETE CASCADE,
	CONSTRAINT FK_Recebe_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS exame (
	id_exame INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_paciente INTEGER NOT NULL,
	local_hospital VARCHAR(100) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	data_hora TIMESTAMPTZ NOT NULL,
	status VARCHAR(50) NOT NULL DEFAULT "pendente",

	CONSTRAINT PK_EXAME
		PRIMARY KEY (id_exame),
	CONSTRAINT FK_EXAME_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional),
	CONSTRAINT FK_EXAME_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
);

CREATE TABLE IF NOT EXISTS prontuario (
	id_prontuario INTEGER GENERATED ALWAYS AS IDENTITY,
	id_paciente INTEGER NOT NULL,
	queixa VARCHAR(100) NOT NULL,
	historico VARCHAR(300) NOT NULL,
	habitos VARCHAR(100),
	interrogatorio VARCHAR(300),
	exames VARCHAR(100),
	plano_terapeutico VARCHAR(100),
	evolucao VARCHAR(100),

	CONSTRAINT PK_PRONTUARIO
		PRIMARY KEY (id_prontuario),
	CONSTRAINT FK_PRONTUARIO_id_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_paciente)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS participa_prontuario (
	id_participacao INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_prontuario INTEGER NOT NULL,
	data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
	data_fim DATE,
	funcao VARCHAR(50) NOT NULL,

	CONSTRAINT PK_PARTICIPA_PRONTUARIO
		PRIMARY KEY (id_participacao),
	CONSTRAINT FK_PARTICIPA_PRONTUARIO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE SET NULL,
	CONSTRAINT FK_PARTICIPA_PRONTUARIO_id_prontuario
		FOREIGN KEY (id_prontuario)
		REFERENCES prontuario(id_prontuario)
		ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS anotacao (
	id_anotacao INTEGER GENERATED ALWAYS AS IDENTITY,
	id_profissional INTEGER NOT NULL,
	id_prontuario INTEGER NOT NULL,
	data_hora TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	conteudo VARCHAR(300) NOT NULL,

	CONSTRAINT PK_ANOTACAO
		PRIMARY KEY (id_anotacao),
	CONSTRAINT FK_ANOTACAO_id_profissional
		FOREIGN KEY (id_profissional)
		REFERENCES profissional(id_profissional)
		ON DELETE CASCADE,
	CONSTRAINT FK_ANOTACAO_id_prontuario
		FOREIGN KEY (id_prontuario)
		REFERENCES prontuario(id_prontuario)
		ON DELETE CASCADE
);
