# visa-campo

Protótipo de aplicativo móvel para registro e organização de evidências de
inspeções da vigilância sanitária da Secretaria Municipal de Saúde de Ribeirão
Preto.

Trabalho de Conclusão de Curso — Análise e Desenvolvimento de Sistemas, FATEC
Ribeirão Preto.

---

## O problema

Os fiscais da vigilância sanitária realizam inspeções sem aviso prévio. Em
campo, observam estrutura física, instalações, processos de trabalho,
instrumental e documentação, sempre com fundamento na legislação sanitária, e
registram o que encontram por meio de fotografias.

O relatório de inspeção, porém, só é redigido no retorno à sede, diretamente no
sistema oficial. Entre a constatação em campo e o registro formal existe um
intervalo em que a informação depende da memória do profissional e de imagens
armazenadas no dispositivo sem qualquer vínculo com a ocorrência que as
originou.

Este projeto atua exatamente nesse intervalo.

---

## O que o sistema faz

Organiza as evidências coletadas em campo por ocorrência, preservando os
metadados de captura, e as exporta em um pacote para anexação ao processo no
sistema oficial.

A estrutura segue três níveis:

```
Ocorrência  →  Inspeção  →  Evidência
 (o caso)      (cada ida)    (o que foi fotografado)
```

Uma ocorrência vincula um estabelecimento a uma área de atuação e pode conter
mais de uma ida ao local: inspeção inicial e retornos após prazo de
adequação. Cada inspeção é conduzida por um ou mais fiscais, sendo um deles
o signatário do auto de infração, quando aplicável.

### Funcionalidades

- Cadastro de ocorrências, vinculando área de atuação e estabelecimento
- Registro dos fiscais presentes em cada inspeção, com marcação de quem
  assina o auto de infração
- Registro da inspeção, com observações gerais e situação (em andamento ou
  concluída)
- Captura de fotografias com data, hora, coordenadas, autor e resumo
  criptográfico (SHA-256)
- Dossiê consolidado da ocorrência, reunindo todas as inspeções e evidências
- Exportação do pacote de evidências para anexação no sistema oficial

### O que está fora do escopo

- Emissão do auto de infração, cuja numeração é sequencial e controlada pelo
  órgão
- Assinatura do autuado e de testemunhas
- Integração automatizada com o Solar BPM e com a Ouvidoria
- Etapas posteriores do processo administrativo sanitário
- Cadastro formal do responsável legal do estabelecimento e roteiro de
  inspeção detalhado por item/base legal — reduzidos do modelo inicial para
  manter o protótipo focado no fluxo essencial (quem inspecionou, onde e
  quais evidências foram coletadas)

---

## Decisões de arquitetura

**Identificadores UUID gerados na aplicação.** Nenhuma chave primária depende
de sequência do banco, o que permite ao dispositivo criar registros sem
conexão e sincronizá-los depois sem conflito de numeração.

**As imagens permanecem no dispositivo.** Apenas os metadados da ocorrência
trafegam para o servidor. Isso dispensa serviço de armazenamento em nuvem,
reduz o volume transmitido e limita a exposição de dados pessoais e de imagens
de estabelecimentos, mantendo o fluxo coerente com o destino final das
evidências, que é o processo no sistema oficial.

**Evidência não é editável.** Após a captura, o registro não sofre alteração;
exclusões ficam gravadas em log de auditoria. O hash é calculado no momento da
captura para permitir verificação posterior de integridade.

**Esquema versionado por migrations.** O banco é criado e evoluído pelo Flyway;
o Hibernate opera em modo de validação e não altera estruturas.

---

## Tecnologias

### Aplicativo

- Flutter (Dart) — Android e iOS
- SQLite para persistência local e operação offline

### Backend

- Java 21 com Spring Boot 3
- Spring Data JPA, Bean Validation, Flyway
- PostgreSQL 16

### Ambiente

- Docker Compose (banco de dados e API)

---

## Estrutura do repositório

```text
visa-campo/
├── docker-compose.yml
├── backend/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/main/
│       ├── java/br/edu/fatec/visacampo/
│       └── resources/
│           ├── application.yml
│           └── db/migration/
└── app/                      # aplicativo Flutter (em desenvolvimento)
```

---

## Como executar

Pré-requisitos: Docker Desktop. Para rodar a API pela IDE, também JDK 21.

```bash
docker compose up --build
```

Verificação:

```bash
# API no ar
curl http://localhost:8080/actuator/health

# tabelas criadas pelo Flyway
docker exec -it visa-db psql -U visa -d visacampo -c "\dt"
```

Documentação interativa da API (Swagger UI), pra testar os endpoints sem
Postman:

```
http://localhost:8080/swagger-ui/index.html
```

Durante o desenvolvimento, suba apenas o banco e execute a aplicação pela IDE:

```bash
docker compose up db
```

> No emulador Android, `localhost` aponta para o próprio emulador. Use
> `10.0.2.2` para alcançar a API na máquina hospedeira, ou o IP da rede local
> em aparelho físico.

---

## Modelo de dados

Oito tabelas, criadas pela migration `V1__esquema_inicial.sql`:

| Tabela | Papel |
| --- | --- |
| `area` | áreas de atuação (alimentos, água, saúde) |
| `agente` | usuários e seus perfis (administrativo, chefe, fiscal) — `Area 1:N Agente` |
| `estabelecimento` | local inspecionado |
| `ocorrencia` | o caso — agrega as inspeções de um mesmo estabelecimento numa área |
| `inspecao` | cada ida ao local, vinculada a uma ocorrência |
| `inspecao_fiscal` | fiscais presentes em cada inspeção, com o signatário do auto marcado |
| `evidencia` | metadados e hash das fotografias, vinculadas à inspeção e ao autor |
| `log_auditoria` | rastro de alterações |

O modelo inicial contemplava também `responsavel` (responsável legal),
`atribuicao` (histórico formal de distribuição) e `roteiro`/`item_roteiro`/
`registro` (checklist por segmento com base legal por item). Essas entidades
foram removidas nesta iteração para manter o protótipo focado no fluxo
essencial — ver "O que está fora do escopo".

---

## Proteção de dados

O sistema trata dados pessoais — nome e e-mail de agentes, endereços de
estabelecimentos e imagens capturadas em campo — no contexto de execução de
política pública, nos termos da Lei nº 13.709/2018. Documentos oficiais
usados durante o levantamento de requisitos foram anonimizados antes da
análise.

---

## Status

Em desenvolvimento.

- [x] Levantamento do fluxo de trabalho e requisitos
- [x] Modelagem de dados e esquema inicial
- [x] Ambiente containerizado com API e banco
- [x] Fatia vertical de referência (`area`: entidade, repositório e
      controller CRUD)
- [ ] Autenticação e perfis de acesso
- [ ] Cadastro de estabelecimentos e ocorrências
- [ ] Registro de fiscais presentes na inspeção
- [ ] Aplicativo Flutter
- [ ] Exportação do pacote de evidências

---

## Autores

Cauan Eduardo Cunha || João Vitor Candido Ribeiro dos Santos
