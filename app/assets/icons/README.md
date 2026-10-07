# assets/icons

Logo e ícones do app. Toda a pasta está registrada em `pubspec.yaml`
(`flutter > assets`), então qualquer arquivo adicionado aqui já fica
disponível via `Image.asset('assets/icons/<nome>')`.

| Arquivo | Uso |
| --- | --- |
| `logo.png` | Wordmark "SUPERVISA", tela inicial (`home_screen.dart`) |
| `marca.png` | Marca isolada (sem texto) — item "Ocorrências" do menu |
| `icon_estabelecimento.png` | Item "Estabelecimentos" do menu e lista de estabelecimentos |
| `icon_info.png` | Reservado — sem tela de informações ainda |
| `icon_ajuda.png` | Reservado — sem tela de ajuda ainda |

O dropdown de área no formulário de nova ocorrência não usa ícone — as
seis áreas reais da Vigilância Sanitária têm nomes longos (ex:
"Instituições de Longa Permanência e Assistência Social"), e um ícone por
área não escalava bem pra esse conjunto.
