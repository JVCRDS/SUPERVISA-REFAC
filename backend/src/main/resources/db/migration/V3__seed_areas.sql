-- Área não tem endpoint de criação (RestController só expõe GET) por ser
-- um cadastro de referência. Sem seed, um banco novo não tem nenhuma área
-- pra referenciar em uma ocorrência. Estes registros servem de ponto de
-- partida para testes manuais via Swagger.
INSERT INTO area (id, nome, descricao, ativo, criado_em) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Alimentos', 'Estabelecimentos que manipulam, armazenam ou comercializam alimentos.', true, now()),
    ('22222222-2222-2222-2222-222222222222', 'Água', 'Sistemas de abastecimento e qualidade da água.', true, now()),
    ('33333333-3333-3333-3333-333333333333', 'Saúde', 'Estabelecimentos de saúde e serviços correlatos.', true, now());
