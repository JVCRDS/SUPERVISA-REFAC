-- A V3 semeou três áreas fictícias (Alimentos/Água/Saúde) só como ponto de
-- partida pros testes manuais. Troca pela estrutura real de setores da
-- Gerência de Vigilância Sanitária de Ribeirão Preto.
--
-- UPDATE nas três áreas já existentes em vez de DELETE+INSERT: preserva o
-- id de qualquer ocorrência já vinculada a elas (um DELETE quebraria a FK
-- ocorrencia_area_id_fkey). "Água" não tem equivalente direto na lista
-- oficial, então vira "Medicamentos, Farmácias e Produtos de Interesse à
-- Saúde" — mantém o id, troca só o conteúdo.
UPDATE area SET
    nome = 'Alimentos e Serviços de Alimentação',
    descricao = 'Restaurantes, bares, lanchonetes, mercados, padarias, açougues e indústrias de alimentos — foco em segurança alimentar e prevenção de doenças transmitidas por alimentos (DTAs).'
WHERE id = '11111111-1111-1111-1111-111111111111';

UPDATE area SET
    nome = 'Medicamentos, Farmácias e Produtos de Interesse à Saúde',
    descricao = 'Farmácias, drogarias, distribuidoras de medicamentos, produtos farmoquímicos e cosméticos.'
WHERE id = '22222222-2222-2222-2222-222222222222';

UPDATE area SET
    nome = 'Serviços de Saúde e Assistência Médica',
    descricao = 'Hospitais, clínicas médicas e odontológicas, laboratórios, serviços de diagnóstico por imagem e unidades de atendimento.'
WHERE id = '33333333-3333-3333-3333-333333333333';

INSERT INTO area (id, nome, descricao, ativo, criado_em) VALUES
    ('44444444-4444-4444-4444-444444444444', 'Instituições de Longa Permanência e Assistência Social', 'ILPIs (asilos e casas de repouso para idosos) e centros de tratamento para dependentes químicos.', true, now()),
    ('55555555-5555-5555-5555-555555555555', 'Interesse à Saúde e Estética', 'Salões de beleza, barbearias, clínicas de estética (com e sem intervenção médica), estúdios de tatuagem e piercing, e óticas.', true, now()),
    ('66666666-6666-6666-6666-666666666666', 'Seções e Equipes Distritais', 'Atuação descentralizada por meio das seções distritais de saúde integradas às regiões do município.', true, now());
