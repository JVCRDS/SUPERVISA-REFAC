# visa-campo — app

App Flutter do protótipo visa-campo. Consome a API do `backend/`.

## Estrutura

```text
lib/
├── main.dart
├── config/       # configuração (URL base da API)
├── models/       # espelham o JSON devolvido pela API, sem lógica
├── services/      # ApiClient: uma chamada HTTP por método
└── screens/      # telas; combinam dados de mais de um endpoint quando preciso
```

Sem gerenciador de estado externo (Provider/Riverpod/Bloc) por enquanto —
`StatefulWidget` + `FutureBuilder` dá conta do escopo atual. Adicionar um
gerenciador de estado é uma decisão pra quando o app crescer o bastante
pra justificar, não algo pra antecipar.

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
