-- Bootstrap: com a criação de agente agora restrita a administradores
-- autenticados (ver AgenteController), precisa existir ao menos um
-- administrador no banco pra poder logar e criar os demais agentes.
-- Senha padrão "visa@123" (hash BCrypt abaixo) — trocar em produção.
INSERT INTO agente (id, nome, email, cpf, senha_hash, perfil, area_id, ativo, criado_em) VALUES
    ('99999999-9999-9999-9999-999999999999',
     'Administrador',
     'admin@visacampo.local',
     '00000000000',
     '$2a$10$5HkOTMPtduD69P2dDoYpDOVHVd00BKplBJjbLb2j3I1B.lN4R.QM.',
     'ADMINISTRATIVO',
     '11111111-1111-1111-1111-111111111111',
     true,
     now());
