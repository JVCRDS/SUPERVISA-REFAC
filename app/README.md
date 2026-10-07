# visa-campo — app

App Flutter do protótipo visa-campo. Consome a API do `backend/`.

## Estrutura

```text
lib/
├── main.dart
├── config/       # configuração (URL base da API)
├── theme/        # paleta de cores e ThemeData da aplicação
├── models/       # espelham o JSON devolvido pela API, sem lógica
├── services/      # ApiClient: uma chamada HTTP por método
└── screens/      # telas; combinam dados de mais de um endpoint quando preciso

assets/
└── icons/        # logo e ícones do app (ver assets/icons/README.md)
```

Sem gerenciador de estado externo (Provider/Riverpod/Bloc) por enquanto —
`StatefulWidget` + `FutureBuilder` dá conta do escopo atual. Adicionar um
gerenciador de estado é uma decisão pra quando o app crescer o bastante
pra justificar, não algo pra antecipar.

## Telas

A tela inicial do app é o **login** (`screens/login_screen.dart`), por CPF
e senha. Não existe tela de autocadastro de propósito — o agente é criado
via administração (ver seção "Login" abaixo). Login bem-sucedido leva pro
menu (`screens/home_screen.dart`), com o logo do app e três atalhos:
Ocorrências, Estabelecimentos e Agentes.

Fluxo de ocorrências, pensado pro perfil Chefe/Supervisor acompanhar o
andamento das ocorrências da sua área:

1. **Ocorrências** (`screens/ocorrencias_screen.dart`) — lista todas as
   ocorrências, com nome do estabelecimento e da área resolvidos no
   cliente. O botão flutuante abre o formulário de nova ocorrência.
2. **Nova ocorrência** (`screens/ocorrencia_form_screen.dart`) — formulário
   com área e estabelecimento (carregados da API) e descrição.
3. **Detalhe da ocorrência** (`screens/ocorrencia_detalhe_screen.dart`) —
   descrição, datas e a lista de inspeções vinculadas. O botão flutuante
   abre o formulário de nova inspeção.
4. **Nova inspeção** (`screens/inspecao_form_screen.dart`) — formulário com
   data/hora, situação, observações gerais e a lista de fiscais (agentes
   com perfil Fiscal) pra marcar quem esteve presente e, entre eles, quem
   assina o auto de infração.
5. **Detalhe da inspeção** (`screens/inspecao_detalhe_screen.dart`) —
   situação, observações, fiscais presentes (com destaque pro assinante) e
   evidências capturadas.

- **Estabelecimentos** (`screens/estabelecimentos_screen.dart`) — lista, com
  botão flutuante que abre o formulário de novo estabelecimento
  (`screens/estabelecimento_form_screen.dart`: nome obrigatório, endereço e
  CNPJ opcionais, município e UF com o padrão do servidor).

Telas de consulta, sem formulário (o cadastro ainda é feito pelo Swagger):

- **Agentes** (`screens/agentes_screen.dart`).

A paleta de cores usada em todo o app está em `theme/app_colors.dart` e o
`ThemeData` correspondente em `theme/app_theme.dart`.

## Login

`POST /api/auth/login` confere CPF e senha contra o agente cadastrado
(senha comparada por hash BCrypt, nunca em texto puro) e devolve os dados
do agente em caso de sucesso. **Isso é só a confirmação de identidade** —
ainda não existe sessão/token, nem proteção de rota no backend; qualquer
endpoint continua acessível sem login, inclusive `POST /api/agentes`. Essa
camada de autenticação (token, rotas protegidas, e a rota administrativa
de criação de agente) é a próxima etapa.

Pra testar o login agora, crie um agente com CPF e senha pelo Swagger
(`POST /api/agentes`, campos `cpf` — 11 dígitos, sem pontuação — e
`senha` em texto puro, que o servidor faz o hash antes de salvar).

## Pré-requisitos

Diferente do backend (`../backend/`), este app **não roda em container** —
o `docker-compose.yml` da raiz sobe só o banco (`db`) e a API (`api`).
Pra rodar o app numa máquina nova, é preciso instalar o
[Flutter SDK](https://docs.flutter.dev/get-started/install) diretamente
nela, independente de estar usando Android, iOS ou Web. Isso vale mesmo
com o `device_preview` (ver seção abaixo) — ele é só mais um pacote Dart
do projeto, baixado via `flutter pub get` e compilado junto com o resto do
app; não substitui o SDK nem roda separado dele.

## Como rodar

Suba a API primeiro (`../start-dev.sh` ou `docker compose up --build` na
raiz do repositório).

**Android** (precisa de um emulador já aberto, ou aparelho físico com
depuração USB):

```bash
flutter run
```

Aponta por padrão pra `http://10.0.2.2:8080` (alias do emulador Android
para o `localhost` da máquina hospedeira). Pra aparelho físico ou
simulador iOS, aponte pro IP da sua rede local:

```bash
flutter run --dart-define=API_BASE_URL=http://SEU_IP:8080
```

**Web** (precisa de Chrome ou Chromium instalado — é o único navegador
que o `flutter run` sabe abrir em modo de desenvolvimento):

```bash
flutter run -d chrome
```

Aponta por padrão pra `http://localhost:8080` — sem truque de alias,
porque o navegador roda direto na sua máquina, junto com a API.

Sem Chrome/Chromium instalado (ex: só tem Firefox)? Use o modo
`web-server`, que não depende do protocolo de depuração do Chrome — ele só
sobe o servidor e você abre a URL no navegador que tiver:

```bash
flutter run -d web-server --web-port=8081
```

Depois abra `http://localhost:8081` manualmente. Hot reload continua
funcionando normalmente.

O `../start-dev.sh` já escolhe automaticamente entre Android/iOS e
Chrome, dependendo do que estiver disponível.

## Device preview

Em modo debug (`!kReleaseMode`), o app abre dentro do
[`device_preview`](https://pub.dev/packages/device_preview): uma moldura de
celular com seletor de aparelho, orientação e zoom, tudo dentro da própria
janela do app. É útil principalmente rodando no navegador
(`flutter run -d chrome`), pra simular telas de celular sem precisar de um
emulador Android instalado. Em build de release (`flutter build ... --release`)
ele é automaticamente desligado e o app roda normal, sem a moldura.

## Testes

```bash
flutter analyze
flutter test
```
