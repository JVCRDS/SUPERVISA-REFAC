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
raiz do repositório), depois:

```bash
flutter run
```

Por padrão a API é `http://10.0.2.2:8080` (alias do emulador Android para
o `localhost` da máquina hospedeira). Pra apontar pra outro endereço
(aparelho físico, simulador iOS):

```bash
flutter run --dart-define=API_BASE_URL=http://SEU_IP:8080
```

## Testes

```bash
flutter analyze
flutter test
```
