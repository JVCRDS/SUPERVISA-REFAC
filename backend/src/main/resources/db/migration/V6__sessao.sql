-- Sessão de autenticação: um token por login, com expiração. Sem isso, a
-- API não tinha como saber quem está autenticado depois do login — cada
-- chamada seguinte era anônima.
CREATE TABLE sessao (
    id          UUID PRIMARY KEY,
    agente_id   UUID NOT NULL REFERENCES agente (id),
    token       VARCHAR(64) NOT NULL UNIQUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT now(),
    expira_em   TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_sessao_agente_id ON sessao (agente_id);
