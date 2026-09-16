ALTER TABLE ocorrencia
    ADD COLUMN atualizado_em TIMESTAMPTZ NOT NULL DEFAULT now();
