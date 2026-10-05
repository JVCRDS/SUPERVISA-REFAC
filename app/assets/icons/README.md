# assets/icons

Logo e ícones do app. Toda a pasta está registrada em `pubspec.yaml`
(`flutter > assets`), então qualquer arquivo adicionado aqui já fica
disponível via `Image.asset('assets/icons/<nome>')`.

| Arquivo | Uso |
| --- | --- |
| `logo.png` | Wordmark "SUPERVISA", tela inicial (`home_screen.dart`) |
| `marca.png` | Marca isolada (sem texto) — item "Ocorrências" do menu e área "Saúde" no formulário de ocorrência |
| `icon_estabelecimento.png` | Item "Estabelecimentos" do menu e lista de estabelecimentos |
| `icon_alimentos.png` | Área "Alimentos" no formulário de nova ocorrência |
| `icon_agua.png` | Área "Água" no formulário de nova ocorrência |
| `icon_pragas.png` | Área de controle de pragas (quando cadastrada) no formulário de nova ocorrência |
| `icon_info.png` | Reservado — sem tela de informações ainda |
| `icon_ajuda.png` | Reservado — sem tela de ajuda ainda |

A escolha do ícone por área, no formulário de nova ocorrência, é feita por
nome (função `_iconeDaArea` em `ocorrencia_form_screen.dart`) — qualquer
área cujo nome não bata com nenhum desses casos cai na marca genérica.
