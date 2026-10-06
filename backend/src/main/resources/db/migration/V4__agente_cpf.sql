-- Nulável no banco porque agentes já existentes (criados antes do login
-- por CPF) não têm esse dado. A aplicação exige CPF em toda criação ou
-- atualização de agente a partir de agora (Bean Validation), então na
-- prática só sobra nulo em registros antigos.
ALTER TABLE agente
    ADD COLUMN cpf VARCHAR(11) UNIQUE;
