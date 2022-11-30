/* Criação do usuário grupo2 */

psql -U postgres
computacao@raiz 

CREATE USER grupo2
    WITH SUPERUSER 
        CREATEDB 
        CREATEROLE
        INHERIT
        LOGIN
        ENCRYPTED PASSWORD 'sisbanco';

/* Criação do banco de dados sistema_bancario */

CREATE DATABASE sistema_bancario 
    WITH 
OWNER = grupo2 
TEMPLATE = template0 
ENCODING = 'UTF8' 
LC_COLLATE = 'pt_BR.UTF-8' 
LC_CTYPE = 'pt_BR.UTF-8' 
ALLOW_CONNECTIONS = true;

/* Comentando o banco de dados sistema_bancario */

COMMENT ON DATABASE sistema_bancario 
    IS 'Banco de dados para a implementação do projeto lógico criado no SQL Power Architect';

/* Conectando o usuário grupo2 ao banco de dados sistema_bancario */

\c sistema_bancario grupo2;
sisbanco 

/* Criação do esquema sisbanco */

CREATE SCHEMA sisbanco AUTHORIZATION grupo2;

/* Alterando o search_path do usuário eloisa para o schema hr */

ALTER USER grupo2 
    SET SEARCH_PATH TO sisbanco, grupo2, public;


CREATE TABLE sisbanco.clientes (
                id_cliente INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                data_nascimento DATE,
                sexo CHAR(1) NOT NULL,
                estado_civil VARCHAR(10) DEFAULT 'SOLTEIRO', 'CASADO', 'VIÚVO',
                CONSTRAINT id_cliente_pk PRIMARY KEY (id_cliente)
);
COMMENT ON TABLE sisbanco.clientes IS 'A tabela clientes armazena dados referentes aos clientes cadastrados no banco.';
COMMENT ON COLUMN sisbanco.clientes.id_cliente IS 'Primary Key da tabela clientes.';
COMMENT ON COLUMN sisbanco.clientes.nome IS 'Nome completo do cliente.';
COMMENT ON COLUMN sisbanco.clientes.data_nascimento IS 'Data de nascimento do cliente.';
COMMENT ON COLUMN sisbanco.clientes.sexo IS 'Sexo do cliente. Pode ser F ou M';
COMMENT ON COLUMN sisbanco.clientes.estado_civil IS 'Estado civil do cliente.';


CREATE TABLE sisbanco.enderecos_clientes (
                id_cliente INTEGER NOT NULL,
                logradouro VARCHAR(50) NOT NULL,
                numero CHAR(5),
                complemento VARCHAR(50),
                bairro VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep CHAR(8) NOT NULL,
                CONSTRAINT enderecos_clientes_pk PRIMARY KEY (id_cliente)
);
COMMENT ON TABLE sisbanco.enderecos_clientes IS 'A tabela enderecos_clientes armazena os endereços dos clientes.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.id_cliente IS 'Primary Key da tabela enderecos_clientes, recebe também o título de Foreign Key pois faz referência a tabela clientes.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.logradouro IS 'Espaço público comum que pode ser utilizado por toda a população e é reconhecido pela administração do município.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.numero IS 'Número da casa, edifício ou condomínio.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.complemento IS 'Informações adicionais referentes ao endereço. Exemplo: Apt 403, Bloco C...';
COMMENT ON COLUMN sisbanco.enderecos_clientes.bairro IS 'Conjunto de ruas, praças e residências que compõe um pedaço da cidade com características em comum.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.cidade IS 'Nome da cidade.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.uf IS 'Abreviação de Unidade Federal - Corresponde ao estado do Brasil o qual se encontram as demais informações do endereço.';
COMMENT ON COLUMN sisbanco.enderecos_clientes.cep IS 'Abreviação de Código de Endereçamento Postal.';


CREATE TABLE sisbanco.servicos (
                id_servico INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                descricao VARCHAR(250),
                valor_minimo NUMERIC(10,2) NOT NULL,
                data_inicio DATE NOT NULL,
                data_final DATE NOT NULL,
                CONSTRAINT servicos_pk PRIMARY KEY (id_servico)
);
COMMENT ON TABLE sisbanco.servicos IS 'A tabela serviços armazena dados referentes aos serviços e tipo de serviços prestados por cada agência.';
COMMENT ON COLUMN sisbanco.servicos.id_servico IS 'Primary Key da tabela servicos.';
COMMENT ON COLUMN sisbanco.servicos.nome IS 'Nome do serviço prestado.';
COMMENT ON COLUMN sisbanco.servicos.descricao IS 'Breve descrição do serviço prestado.';
COMMENT ON COLUMN sisbanco.servicos.valor_minimo IS 'Valor mínimo do serviço.';
COMMENT ON COLUMN sisbanco.servicos.data_inicio IS 'Data de início do serviço.';
COMMENT ON COLUMN sisbanco.servicos.data_final IS 'Data final do serviço.';


CREATE TABLE sisbanco.requerimento (
                id_cliente INTEGER NOT NULL,
                id_servico INTEGER NOT NULL,
                CONSTRAINT requerimento_pk PRIMARY KEY (id_cliente, id_servico)
);
COMMENT ON TABLE sisbanco.requerimento IS 'A tabela requerimento funciona como uma representação do relacionamento entre as tabelas clientes e servicos.';
COMMENT ON COLUMN sisbanco.requerimento.id_cliente IS 'Primary Key da tabela requerimento, é também uma Foreign Key pois tem como referência a tabela clientes.';
COMMENT ON COLUMN sisbanco.requerimento.id_servico IS 'Primary Key da tabela requerimento, é também uma Foreign Key, pois tem como referência a tabela servicos. Compõe a superchave da tabela em conjunto com a id_cliente.';


CREATE TABLE sisbanco.emprestimos (
                id_emprestimo INTEGER NOT NULL,
                data_aquisicao DATE NOT NULL,
                valor NUMERIC(10,2) NOT NULL,
                id_cliente INTEGER NOT NULL,
                CONSTRAINT emprestimos_id PRIMARY KEY (id_emprestimo)
);
COMMENT ON TABLE sisbanco.emprestimos IS 'A tabela emprestimos armazena dados referentes aos empréstimos realizados pelo clientes e suas respectivas informações.';
COMMENT ON COLUMN sisbanco.emprestimos.id_emprestimo IS 'Primary Key da tabela emprestimos.';
COMMENT ON COLUMN sisbanco.emprestimos.data_aquisicao IS 'Data de realização do empréstimo.';
COMMENT ON COLUMN sisbanco.emprestimos.valor IS 'Valor do empréstimo.';
COMMENT ON COLUMN sisbanco.emprestimos.id_cliente IS 'Id do cliente solicitante do empréstimo. É também uma Foreign Key pois tem como referência a tabela clientes.';


CREATE TABLE sisbanco.parcelas (
                id_emprestimo INTEGER NOT NULL,
                numero_parcela INTEGER NOT NULL,
                valor NUMERIC(10,2) NOT NULL,
                valor_juros NUMERIC(10,2) NOT NULL,
                valor_multa NUMERIC(10,2) NOT NULL,
                data_vencimento DATE NOT NULL,
                data_pagamento DATE NOT NULL,
                CONSTRAINT parcelas_pk PRIMARY KEY (id_emprestimo, numero_parcela)
);
COMMENT ON TABLE sisbanco.parcelas IS 'A tabela parcelas armazena dados referentes as parcelas dos empréstimo realizados pelos clientes.';
COMMENT ON COLUMN sisbanco.parcelas.id_emprestimo IS 'Primary Key da tabela parcelas. É também uma Foreign Key pois tem como referência dados da tabela emprestimos.';
COMMENT ON COLUMN sisbanco.parcelas.numero_parcela IS 'Primary Key da tabela parcelas. Compõe a superchave da tabela em conjunto com id_emprestimo.';
COMMENT ON COLUMN sisbanco.parcelas.valor IS 'Valor das parcelas.';
COMMENT ON COLUMN sisbanco.parcelas.valor_juros IS 'Valor dos juros cobrados em cima das parcelas.';
COMMENT ON COLUMN sisbanco.parcelas.valor_multa IS 'Valor da multa, em caso de multas ou quebras contratuais.';
COMMENT ON COLUMN sisbanco.parcelas.data_vencimento IS 'Data de vencimento da parcela.';
COMMENT ON COLUMN sisbanco.parcelas.data_pagamento IS 'Data de pagamento da parcela.';


CREATE TABLE sisbanco.contrato (
                id_servico INTEGER NOT NULL,
                data_assinatura DATE NOT NULL,
                desc_contratante VARCHAR(250) NOT NULL,
                desc_contratado VARCHAR(250) NOT NULL,
                CONSTRAINT contrato_pk PRIMARY KEY (id_servico)
);
COMMENT ON TABLE sisbanco.contrato IS 'A tabela contratos armazena dados referentes aos contratos dos serviços prestados pelas agências.';
COMMENT ON COLUMN sisbanco.contrato.id_servico IS 'Primary Key da tabela contrato, é também uma Foreign Key pois tem como referência a tabela servicos.';
COMMENT ON COLUMN sisbanco.contrato.data_assinatura IS 'Data de assinatura do contrato.';
COMMENT ON COLUMN sisbanco.contrato.desc_contratante IS 'Descrição do contratante.';
COMMENT ON COLUMN sisbanco.contrato.desc_contratado IS 'Descrição do contratado.';


CREATE TABLE sisbanco.contas (
                id_conta INTEGER NOT NULL,
                senha VARCHAR(20) NOT NULL,
                data_abertura DATE,
                saldo NUMERIC(12,2),
                id_cliente INTEGER NOT NULL,
                CONSTRAINT contas_pk PRIMARY KEY (id_conta)
);
COMMENT ON TABLE sisbanco.contas IS 'A tabela contas armazena dados referentes ao cadastro de contas dos clientes.';
COMMENT ON COLUMN sisbanco.contas.id_conta IS 'Primary Key da tabela contas.';
COMMENT ON COLUMN sisbanco.contas.senha IS 'Senha da conta cadastrada pelo cliente.';
COMMENT ON COLUMN sisbanco.contas.data_abertura IS 'Data de abertura da conta.';
COMMENT ON COLUMN sisbanco.contas.saldo IS 'Saldo da conta.';
COMMENT ON COLUMN sisbanco.contas.id_cliente IS 'Foreign Key que tem como referência a tabela clientes. Serve para identificar o dono da conta.';


CREATE TABLE sisbanco.historico (
                id_servico INTEGER NOT NULL,
                id_conta INTEGER NOT NULL,
                CONSTRAINT historico_pk PRIMARY KEY (id_servico, id_conta)
);
COMMENT ON TABLE sisbanco.historico IS 'A tabela historico armazena o histórico de serviços prestados às contas cadastradas.';
COMMENT ON COLUMN sisbanco.historico.id_servico IS 'Primary Key da tabela historico, é também uma Foreign Key pois tem como referência a tabela servicos.';
COMMENT ON COLUMN sisbanco.historico.id_conta IS 'Primary Key da tabela historico, é também uma Foreign Key pois tem como referência a tabela contas. Compõe a superchave da tabela em conjunto com a id_servico.';


CREATE TABLE sisbanco.bancos (
                cnpj CHAR(14) NOT NULL,
                razao_social VARCHAR(20) NOT NULL,
                site VARCHAR(100),
                CONSTRAINT bancos_pk PRIMARY KEY (cnpj)
);
COMMENT ON TABLE sisbanco.bancos IS 'A tabela bancos armazena dados referentes aos bancos do sistema bancário.';
COMMENT ON COLUMN sisbanco.bancos.cnpj IS 'O CNPJ (Cadastro Nacional de Pessoa Jurídica) é usado para identificar uma empresa no Brasil.';
COMMENT ON COLUMN sisbanco.bancos.razao_social IS 'O nome o qual uma empresa responde juridicamente. É também uma chave alternativa na tabela.';
COMMENT ON COLUMN sisbanco.bancos.site IS 'Página WEB do banco.';


CREATE UNIQUE INDEX bancos_ak
 ON sisbanco.bancos
 ( razao_social );

CREATE TABLE sisbanco.enderecos_banco (
                id_banco CHAR(14) NOT NULL,
                logradouro VARCHAR(50),
                numero CHAR(5),
                complemento VARCHAR(50),
                bairro VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep CHAR(8),
                CONSTRAINT enderecos_banco_pk PRIMARY KEY (id_banco)
);
COMMENT ON TABLE sisbanco.enderecos_banco IS 'A tabela endereco_bancos contém os endereços dos bancos.';
COMMENT ON COLUMN sisbanco.enderecos_banco.id_banco IS 'Primary Key da tabela endereco_bancos, é também uma Foreign Key, pois tem como referência a tabela bancos.';
COMMENT ON COLUMN sisbanco.enderecos_banco.logradouro IS 'Espaço público comum que pode ser utilizado por toda a população e é reconhecido pela administração do município.';
COMMENT ON COLUMN sisbanco.enderecos_banco.numero IS 'Número da casa, edifício ou condomínio.';
COMMENT ON COLUMN sisbanco.enderecos_banco.complemento IS 'Informações adicionais referentes ao endereço. Exemplo: Apt 403, Bloco C...';
COMMENT ON COLUMN sisbanco.enderecos_banco.bairro IS 'Conjunto de ruas, praças e residências que compõe um pedaço da cidade com características em comum.';
COMMENT ON COLUMN sisbanco.enderecos_banco.cidade IS 'Nome da cidade.';
COMMENT ON COLUMN sisbanco.enderecos_banco.uf IS 'Abreviação de Unidade Federal - Corresponde ao estado do Brasil o qual se encontram as demais informações do endereço.';
COMMENT ON COLUMN sisbanco.enderecos_banco.cep IS 'Abreviação de Código de Endereçamento Postal.';


CREATE TABLE sisbanco.agencias (
                id_agencia INTEGER NOT NULL,
                nome VARCHAR(100),
                id_banco CHAR(14) NOT NULL,
                CONSTRAINT agencias_pk PRIMARY KEY (id_agencia)
);
COMMENT ON TABLE sisbanco.agencias IS 'A tabela agencias armazena dados relativos as agências pertencentes aos bancos da tabela bancos.';
COMMENT ON COLUMN sisbanco.agencias.id_agencia IS 'Primary Key da tabela agencias.';
COMMENT ON COLUMN sisbanco.agencias.nome IS 'Nome da agência.';
COMMENT ON COLUMN sisbanco.agencias.id_banco IS 'Foreign Key da tabela agencias, tem como referência a tabela bancos.';


CREATE TABLE sisbanco.endereco_agencia (
                id_agencia INTEGER NOT NULL,
                logradouro VARCHAR(50),
                numero CHAR(5),
                complemento VARCHAR(50),
                bairro VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep CHAR(8),
                CONSTRAINT enderecos_agencia_pk PRIMARY KEY (id_agencia)
);
COMMENT ON TABLE sisbanco.endereco_agencia IS 'A tabela endereco_agencia armazena os endereços das agências.';
COMMENT ON COLUMN sisbanco.endereco_agencia.id_agencia IS 'Primary Key da tabela endereco_agencia, é também uma Foreign Key pois tem como referência a tabela agencias.';
COMMENT ON COLUMN sisbanco.endereco_agencia.logradouro IS 'Espaço público comum que pode ser utilizado por toda a população e é reconhecido pela administração do município.';
COMMENT ON COLUMN sisbanco.endereco_agencia.numero IS 'Número da casa, edifício ou condomínio.';
COMMENT ON COLUMN sisbanco.endereco_agencia.complemento IS 'Informações adicionais referentes ao endereço. Exemplo: Apt 403, Bloco C...';
COMMENT ON COLUMN sisbanco.endereco_agencia.bairro IS 'Conjunto de ruas, praças e residências que compõe um pedaço da cidade com características em comum.';
COMMENT ON COLUMN sisbanco.endereco_agencia.cidade IS 'Nome da cidade.';
COMMENT ON COLUMN sisbanco.endereco_agencia.uf IS 'Abreviação de Unidade Federal - Corresponde ao estado do Brasil o qual se encontram as demais informações do endereço.';
COMMENT ON COLUMN sisbanco.endereco_agencia.cep IS 'Abreviação de Código de Endereçamento Postal.';


CREATE TABLE sisbanco.oferta (
                id_agencia INTEGER NOT NULL,
                id_servico INTEGER NOT NULL,
                CONSTRAINT oferta_pk PRIMARY KEY (id_agencia, id_servico)
);
COMMENT ON TABLE sisbanco.oferta IS 'A tabela oferta funciona como uma representação relacionamento N:N entre as tabelas agencias e servicos.';
COMMENT ON COLUMN sisbanco.oferta.id_agencia IS 'Primary Key da tabela oferta, é também uma Foreign Key pois tem como referência a tabela agencias.';
COMMENT ON COLUMN sisbanco.oferta.id_servico IS 'Primary Key da tabela oferta, é também uma Foreign Key pois tem como referência a tabela servicos. Compõe a superchave da tabela em conjunto com a id_agencia.';


CREATE TABLE sisbanco.lotacoes (
                id_lotacao INTEGER NOT NULL,
                id_agencia INTEGER NOT NULL,
                funcao VARCHAR(35) NOT NULL,
                CONSTRAINT lotacoes_pk PRIMARY KEY (id_lotacao)
);
COMMENT ON COLUMN sisbanco.lotacoes.id_lotacao IS 'Primary Key da tabela lotacoes.';
COMMENT ON COLUMN sisbanco.lotacoes.id_agencia IS 'É uma Foreign Key pois tem como referência a tabela agencias.';
COMMENT ON COLUMN sisbanco.lotacoes.funcao IS 'Função desempenhada na lotação.';


CREATE TABLE sisbanco.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_lotacao INTEGER NOT NULL,
                salario NUMERIC(8,2),
                id_gerente INTEGER NOT NULL,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE sisbanco.empregados IS 'A tabela empregados armazena dados referentes aos empregados dos bancos e agências.';
COMMENT ON COLUMN sisbanco.empregados.id_empregado IS 'Primary Key da tabela empregados.';
COMMENT ON COLUMN sisbanco.empregados.nome IS 'Nome do empregado.';
COMMENT ON COLUMN sisbanco.empregados.salario IS 'Salário do empregado.';
COMMENT ON COLUMN sisbanco.empregados.id_gerente IS 'Id do gerente, é também um auto-relacionamento da tabela empregados com ela mesma.';


CREATE TABLE sisbanco.endereco_empregado (
                id_empregado INTEGER NOT NULL,
                logradouro VARCHAR(50),
                numero CHAR(5),
                complemento VARCHAR(50),
                bairro VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep CHAR(8),
                CONSTRAINT enderecos_empregado_pk PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE sisbanco.endereco_empregado IS 'A tabela endereco_empregado armazena dados referentes aos endereços dos empregados.';
COMMENT ON COLUMN sisbanco.endereco_empregado.id_empregado IS 'Primary Key da tabela endereco_empregado, é também uma Foreign Key pois tem como referência a tabela empregados.';
COMMENT ON COLUMN sisbanco.endereco_empregado.logradouro IS 'Espaço público comum que pode ser utilizado por toda a população e é reconhecido pela administração do município.';
COMMENT ON COLUMN sisbanco.endereco_empregado.numero IS 'Número da casa, edifício ou condomínio.';
COMMENT ON COLUMN sisbanco.endereco_empregado.complemento IS 'Informações adicionais referentes ao endereço. Exemplo: Apt 403, Bloco C...';
COMMENT ON COLUMN sisbanco.endereco_empregado.bairro IS 'Conjunto de ruas, praças e residências que compõe um pedaço da cidade com características em comum.';
COMMENT ON COLUMN sisbanco.endereco_empregado.cidade IS 'Nome da cidade.';
COMMENT ON COLUMN sisbanco.endereco_empregado.uf IS 'Abreviação de Unidade Federal - Corresponde ao estado do Brasil o qual se encontram as demais informações do endereço.';
COMMENT ON COLUMN sisbanco.endereco_empregado.cep IS 'Abreviação de Código de Endereçamento Postal.';


CREATE TABLE sisbanco.tempo_servico (
                id_lotacao INTEGER NOT NULL,
                horas_trabalhadas INTEGER NOT NULL,
                dias_trabalhados INTEGER,
                CONSTRAINT tempo_servico_pk PRIMARY KEY (id_lotacao)
);
COMMENT ON COLUMN sisbanco.tempo_servico.id_lotacao IS 'Primary Key da tabela tempo_servico. É também uma Foreign Key pois tem como referência a tabela lotacoes.';
COMMENT ON COLUMN sisbanco.tempo_servico.horas_trabalhadas IS 'Horas trabalhadas pelo empregado na lotação.';
COMMENT ON COLUMN sisbanco.tempo_servico.dias_trabalhados IS 'Dias trabalhados pelo empregado na lotação.';


CREATE TABLE sisbanco.telefones_agencias (
                id_agencia INTEGER NOT NULL,
                telefone CHAR(12),
                CONSTRAINT telefones_agencias_pk PRIMARY KEY (id_agencia)
);
COMMENT ON TABLE sisbanco.telefones_agencias IS 'Números de telefone das agências da tabela agencias.';
COMMENT ON COLUMN sisbanco.telefones_agencias.id_agencia IS 'Primary Key da tabela telefones_agencias, é também uma Foreign Key pois tem como referência a tabela agencias.';
COMMENT ON COLUMN sisbanco.telefones_agencias.telefone IS 'Número de telefone da agência.';


CREATE TABLE sisbanco.telefones_bancos (
                cnpj CHAR(14) NOT NULL,
                telefone CHAR(12),
                CONSTRAINT telefones_bancos_pk PRIMARY KEY (cnpj)
);
COMMENT ON TABLE sisbanco.telefones_bancos IS 'A tabela telefones_bancos armazena os telefones para contato dos bancos, identificados por seus respectivos CNPJs.';
COMMENT ON COLUMN sisbanco.telefones_bancos.cnpj IS 'É a Primary Key da tabela telefones_bancos, recebe também o nome de Foreign Key pois faz referência a tabela Bancos.';
COMMENT ON COLUMN sisbanco.telefones_bancos.telefone IS 'Armazena os telefones para contato dos bancos.';


ALTER TABLE sisbanco.contas ADD CONSTRAINT clientes_contas_fk
FOREIGN KEY (id_cliente)
REFERENCES sisbanco.clientes (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.requerimento ADD CONSTRAINT clientes_requerimento_fk
FOREIGN KEY (id_cliente)
REFERENCES sisbanco.clientes (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.emprestimos ADD CONSTRAINT clientes_emprestimos_fk
FOREIGN KEY (id_cliente)
REFERENCES sisbanco.clientes (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.enderecos_clientes ADD CONSTRAINT clientes_enderecos_clientes_fk
FOREIGN KEY (id_cliente)
REFERENCES sisbanco.clientes (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.historico ADD CONSTRAINT servicos_historico_fk
FOREIGN KEY (id_servico)
REFERENCES sisbanco.servicos (id_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.requerimento ADD CONSTRAINT servicos_requerimento_fk
FOREIGN KEY (id_servico)
REFERENCES sisbanco.servicos (id_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.oferta ADD CONSTRAINT servicos_oferta_fk
FOREIGN KEY (id_servico)
REFERENCES sisbanco.servicos (id_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.contrato ADD CONSTRAINT servicos_contrato_fk
FOREIGN KEY (id_servico)
REFERENCES sisbanco.servicos (id_servico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.parcelas ADD CONSTRAINT emprestimos_parcelas_fk
FOREIGN KEY (id_emprestimo)
REFERENCES sisbanco.emprestimos (id_emprestimo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.historico ADD CONSTRAINT contas_historico_fk
FOREIGN KEY (id_conta)
REFERENCES sisbanco.contas (id_conta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.telefones_bancos ADD CONSTRAINT bancos_telefones_bancos_fk
FOREIGN KEY (cnpj)
REFERENCES sisbanco.bancos (cnpj)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.agencias ADD CONSTRAINT bancos_agencias_fk
FOREIGN KEY (id_banco)
REFERENCES sisbanco.bancos (cnpj)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.enderecos_banco ADD CONSTRAINT bancos_enderecos_banco_fk
FOREIGN KEY (id_banco)
REFERENCES sisbanco.bancos (cnpj)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.telefones_agencias ADD CONSTRAINT agencias_telefones_agencias_fk
FOREIGN KEY (id_agencia)
REFERENCES sisbanco.agencias (id_agencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.lotacoes ADD CONSTRAINT agencias_lotacoes_fk
FOREIGN KEY (id_agencia)
REFERENCES sisbanco.agencias (id_agencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.oferta ADD CONSTRAINT agencias_oferta_fk
FOREIGN KEY (id_agencia)
REFERENCES sisbanco.agencias (id_agencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.endereco_agencia ADD CONSTRAINT agencias_endereco_agencia_fk
FOREIGN KEY (id_agencia)
REFERENCES sisbanco.agencias (id_agencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.tempo_servico ADD CONSTRAINT lotacoes_tempo_servico_fk
FOREIGN KEY (id_lotacao)
REFERENCES sisbanco.lotacoes (id_lotacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.empregados ADD CONSTRAINT lotacoes_empregados_fk
FOREIGN KEY (id_lotacao)
REFERENCES sisbanco.lotacoes (id_lotacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_gerente)
REFERENCES sisbanco.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sisbanco.endereco_empregado ADD CONSTRAINT empregados_endereco_empregado_fk
FOREIGN KEY (id_empregado)
REFERENCES sisbanco.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;