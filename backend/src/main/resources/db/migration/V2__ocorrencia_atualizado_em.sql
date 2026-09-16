ALTER TABLE ocorrencia
    ADD COLUMN atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now();

ALTER TABLE ocorrencia
    ADD COLUMN descricao TEXT NOT NULL DEFAULT 'Resumo da situação';