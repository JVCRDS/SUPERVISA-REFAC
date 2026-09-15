-- Esquema inicial do visa-campo (modelo reduzido do estudo de caso).
--
-- Identificadores sao UUID gerados pela aplicacao (nunca por sequencia ou
-- funcao do banco), o que permite ao dispositivo criar registros offline e
-- sincronizar sem conflito de numeracao. Por isso nenhuma coluna "id" tem
-- valor DEFAULT: a aplicacao sempre informa o UUID no INSERT.

CREATE TABLE area (
    id          UUID PRIMARY KEY,
    nome        VARCHAR(120) NOT NULL UNIQUE,
    descricao   TEXT,
    ativo       BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Area 1:N Agente
CREATE TABLE agente (
    id          UUID PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(180) NOT NULL UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,
    perfil      VARCHAR(20) NOT NULL
                    CHECK (perfil IN ('ADMINISTRATIVO', 'CHEFE', 'FISCAL')),
    area_id     UUID NOT NULL REFERENCES area (id),
    ativo       BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_agente_area_id ON agente (area_id);

CREATE TABLE estabelecimento (
    id              UUID PRIMARY KEY,
    nome            VARCHAR(180) NOT NULL,
    cnpj            VARCHAR(14),
    logradouro      VARCHAR(200),
    numero          VARCHAR(20),
    complemento     VARCHAR(100),
    bairro          VARCHAR(100),
    municipio       VARCHAR(100) NOT NULL DEFAULT 'Ribeirão Preto',
    uf              VARCHAR(2) NOT NULL DEFAULT 'SP',
    cep             VARCHAR(8),
    latitude        NUMERIC(10, 7),
    longitude       NUMERIC(10, 7),
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Estabelecimento 1:N Ocorrencia, Area 1:N Ocorrencia
CREATE TABLE ocorrencia (
    id                  UUID PRIMARY KEY,
    area_id             UUID NOT NULL REFERENCES area (id),
    estabelecimento_id  UUID NOT NULL REFERENCES estabelecimento (id),
    criado_em           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ocorrencia_area_id ON ocorrencia (area_id);
CREATE INDEX idx_ocorrencia_estabelecimento_id ON ocorrencia (estabelecimento_id);

-- Ocorrencia 1:N Inspecao (a inspecao nao referencia area/estabelecimento
-- diretamente: area e estabelecimento sao atributos do caso, nao da visita)
CREATE TABLE inspecao (
    id                  UUID PRIMARY KEY,
    ocorrencia_id       UUID NOT NULL REFERENCES ocorrencia (id),
    data_hora           TIMESTAMPTZ NOT NULL DEFAULT now(),
    latitude            NUMERIC(10, 7),
    longitude           NUMERIC(10, 7),
    situacao            VARCHAR(20) NOT NULL DEFAULT 'EM_ANDAMENTO'
                             CHECK (situacao IN ('EM_ANDAMENTO', 'CONCLUIDA')),
    observacoes_gerais  TEXT,
    criado_em           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_inspecao_ocorrencia_id ON inspecao (ocorrencia_id);

-- Tabela associativa: Inspecao N:M Agente (fiscais presentes), com o
-- atributo "assinante" marcando quem assina o auto de infracao. No maximo
-- um assinante por inspecao (indice unico parcial abaixo).
CREATE TABLE inspecao_fiscal (
    id              UUID PRIMARY KEY,
    inspecao_id     UUID NOT NULL REFERENCES inspecao (id),
    agente_id       UUID NOT NULL REFERENCES agente (id),
    assinante       BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (inspecao_id, agente_id)
);

CREATE INDEX idx_inspecao_fiscal_inspecao_id ON inspecao_fiscal (inspecao_id);
CREATE INDEX idx_inspecao_fiscal_agente_id ON inspecao_fiscal (agente_id);
CREATE UNIQUE INDEX idx_inspecao_fiscal_assinante_unico
    ON inspecao_fiscal (inspecao_id)
    WHERE assinante;

-- Inspecao 1:N Evidencia, Agente 1:N Evidencia (autor)
CREATE TABLE evidencia (
    id              UUID PRIMARY KEY,
    inspecao_id     UUID NOT NULL REFERENCES inspecao (id),
    autor_id        UUID NOT NULL REFERENCES agente (id),
    nome_arquivo    VARCHAR(255) NOT NULL,
    hash_sha256     VARCHAR(64) NOT NULL,
    capturado_em    TIMESTAMPTZ NOT NULL,
    latitude        NUMERIC(10, 7),
    longitude       NUMERIC(10, 7),
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_evidencia_inspecao_id ON evidencia (inspecao_id);
CREATE INDEX idx_evidencia_autor_id ON evidencia (autor_id);

-- Sem UPDATE de evidencia apos a captura; exclusoes ficam registradas aqui.
CREATE TABLE log_auditoria (
    id                  UUID PRIMARY KEY,
    tabela              VARCHAR(60) NOT NULL,
    registro_id         UUID NOT NULL,
    acao                VARCHAR(20) NOT NULL
                             CHECK (acao IN ('INSERT', 'UPDATE', 'DELETE')),
    agente_id           UUID REFERENCES agente (id),
    dados_anteriores    JSONB,
    realizado_em        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_log_auditoria_tabela_registro ON log_auditoria (tabela, registro_id);
