ALTER TABLE ocorrencia
    ADD COLUMN atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now();
    ADD COLUMN descricao STRING NOT NULL DEFAULT 'Resumo da situação';