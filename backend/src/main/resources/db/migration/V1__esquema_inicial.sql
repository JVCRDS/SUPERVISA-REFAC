-- Esquema inicial do visa-campo.
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

CREATE TABLE agente (
    id          UUID PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(180) NOT NULL UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,
    perfil      VARCHAR(20) NOT NULL
                    CHECK (perfil IN ('ADMINISTRATIVO', 'CHEFE', 'FISCAL')),
    area_id     UUID REFERENCES area (id),
    ativo       BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_agente_area_id ON agente (area_id);

CREATE TABLE responsavel (
    id          UUID PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    cpf         VARCHAR(11) NOT NULL UNIQUE,
    telefone    VARCHAR(20),
    email       VARCHAR(180),
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE estabelecimento (
    id              UUID PRIMARY KEY,
    nome            VARCHAR(180) NOT NULL,
    cnpj            VARCHAR(14),
    logradouro      VARCHAR(200),
    numero          VARCHAR(20),
    complemento     VARCHAR(100),
    bairro          VARCHAR(100),
    municipio       VARCHAR(100) NOT NULL DEFAULT 'Ribeirão Preto',
    uf              CHAR(2) NOT NULL DEFAULT 'SP',
    cep             VARCHAR(8),
    latitude        NUMERIC(10, 7),
    longitude       NUMERIC(10, 7),
    responsavel_id  UUID NOT NULL REFERENCES responsavel (id),
    area_id         UUID NOT NULL REFERENCES area (id),
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_estabelecimento_responsavel_id ON estabelecimento (responsavel_id);
CREATE INDEX idx_estabelecimento_area_id ON estabelecimento (area_id);

CREATE TABLE ocorrencia (
    id                  UUID PRIMARY KEY,
    estabelecimento_id  UUID NOT NULL REFERENCES estabelecimento (id),
    area_id             UUID NOT NULL REFERENCES area (id),
    origem              VARCHAR(30) NOT NULL
                             CHECK (origem IN ('LICENCA', 'RENOVACAO', 'DENUNCIA',
                                                'REQUISICAO_ORGAO_EXTERNO', 'ROTINA')),
    protocolo_externo   VARCHAR(60),
    status              VARCHAR(20) NOT NULL DEFAULT 'ABERTA'
                             CHECK (status IN ('ABERTA', 'EM_ANDAMENTO', 'ENCERRADA')),
    descricao           TEXT,
    aberta_em           TIMESTAMPTZ NOT NULL DEFAULT now(),
    encerrada_em        TIMESTAMPTZ,
    criado_por          UUID NOT NULL REFERENCES agente (id)
);

CREATE INDEX idx_ocorrencia_estabelecimento_id ON ocorrencia (estabelecimento_id);
CREATE INDEX idx_ocorrencia_area_id ON ocorrencia (area_id);
CREATE INDEX idx_ocorrencia_status ON ocorrencia (status);

CREATE TABLE atribuicao (
    id              UUID PRIMARY KEY,
    ocorrencia_id   UUID NOT NULL REFERENCES ocorrencia (id),
    fiscal_id       UUID NOT NULL REFERENCES agente (id),
    atribuido_por   UUID NOT NULL REFERENCES agente (id),
    atribuido_em    TIMESTAMPTZ NOT NULL DEFAULT now(),
    ativa           BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX idx_atribuicao_ocorrencia_id ON atribuicao (ocorrencia_id);
CREATE INDEX idx_atribuicao_fiscal_id ON atribuicao (fiscal_id);

CREATE TABLE roteiro (
    id          UUID PRIMARY KEY,
    area_id     UUID NOT NULL REFERENCES area (id),
    nome        VARCHAR(150) NOT NULL,
    versao      INTEGER NOT NULL DEFAULT 1,
    ativo       BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_roteiro_area_id ON roteiro (area_id);

CREATE TABLE item_roteiro (
    id          UUID PRIMARY KEY,
    roteiro_id  UUID NOT NULL REFERENCES roteiro (id),
    ordem       INTEGER NOT NULL,
    descricao   TEXT NOT NULL,
    base_legal  VARCHAR(300)
);

CREATE INDEX idx_item_roteiro_roteiro_id ON item_roteiro (roteiro_id);

CREATE TABLE inspecao (
    id                  UUID PRIMARY KEY,
    ocorrencia_id       UUID NOT NULL REFERENCES ocorrencia (id),
    fiscal_id           UUID NOT NULL REFERENCES agente (id),
    roteiro_id          UUID NOT NULL REFERENCES roteiro (id),
    data_hora           TIMESTAMPTZ NOT NULL DEFAULT now(),
    latitude            NUMERIC(10, 7),
    longitude           NUMERIC(10, 7),
    situacao            VARCHAR(20) NOT NULL DEFAULT 'EM_ANDAMENTO'
                             CHECK (situacao IN ('EM_ANDAMENTO', 'CONCLUIDA')),
    observacoes_gerais  TEXT
);

CREATE INDEX idx_inspecao_ocorrencia_id ON inspecao (ocorrencia_id);
CREATE INDEX idx_inspecao_fiscal_id ON inspecao (fiscal_id);

CREATE TABLE registro (
    id                    UUID PRIMARY KEY,
    inspecao_id           UUID NOT NULL REFERENCES inspecao (id),
    item_roteiro_id       UUID NOT NULL REFERENCES item_roteiro (id),
    situacao_constatada   VARCHAR(20) NOT NULL
                               CHECK (situacao_constatada IN ('CONFORME', 'NAO_CONFORME', 'NAO_APLICAVEL')),
    observacao            TEXT,
    criado_em             TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_registro_inspecao_id ON registro (inspecao_id);
CREATE INDEX idx_registro_item_roteiro_id ON registro (item_roteiro_id);

CREATE TABLE evidencia (
    id              UUID PRIMARY KEY,
    registro_id     UUID NOT NULL REFERENCES registro (id),
    nome_arquivo    VARCHAR(255) NOT NULL,
    hash_sha256     CHAR(64) NOT NULL,
    capturado_em    TIMESTAMPTZ NOT NULL,
    latitude        NUMERIC(10, 7),
    longitude       NUMERIC(10, 7),
    autor_id        UUID NOT NULL REFERENCES agente (id),
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_evidencia_registro_id ON evidencia (registro_id);

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
