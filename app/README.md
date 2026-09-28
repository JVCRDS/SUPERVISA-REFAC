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
```

Sem gerenciador de estado externo (Provider/Riverpod/Bloc) por enquanto —
`StatefulWidget` + `FutureBuilder` dá conta do escopo atual. Adicionar um
gerenciador de estado é uma decisão pra quando o app crescer o bastante
pra justificar, não algo pra antecipar.

## Telas

Fluxo de navegação atual, pensado pro perfil Chefe/Supervisor acompanhar o
andamento das ocorrências da sua área:

1. **Ocorrências** (`screens/ocorrencias_screen.dart`) — lista todas as
   ocorrências, com nome do estabelecimento e da área resolvidos no
   cliente.
2. **Detalhe da ocorrência** (`screens/ocorrencia_detalhe_screen.dart`) —
   descrição, datas e a lista de inspeções vinculadas.
3. **Detalhe da inspeção** (`screens/inspecao_detalhe_screen.dart`) —
   situação, observações, fiscais presentes (com destaque pro assinante) e
   evidências capturadas.

A paleta de cores usada em todo o app está em `theme/app_colors.dart` e o
`ThemeData` correspondente em `theme/app_theme.dart`.

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

O `../start-dev.sh` já escolhe automaticamente entre Android/iOS e
Chrome, dependendo do que estiver disponível.

## Testes

```bash
flutter analyze
flutter test
```
