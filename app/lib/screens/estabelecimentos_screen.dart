import 'package:flutter/material.dart';

import '../models/agente.dart';
import '../models/estabelecimento.dart';
import '../services/api_client.dart';
import '../widgets/confirmar_exclusao.dart';
import 'estabelecimento_form_screen.dart';

class EstabelecimentosScreen extends StatefulWidget {
  final Agente agenteLogado;

  const EstabelecimentosScreen({super.key, required this.agenteLogado});

  @override
  State<EstabelecimentosScreen> createState() => _EstabelecimentosScreenState();
}

class _EstabelecimentosScreenState extends State<EstabelecimentosScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<Estabelecimento>> _futureEstabelecimentos;

  @override
  void initState() {
    super.initState();
    _futureEstabelecimentos = _apiClient.listarEstabelecimentos();
  }

  Future<void> _recarregar() {
    final futuro = _apiClient.listarEstabelecimentos();
    setState(() {
      _futureEstabelecimentos = futuro;
    });
    return futuro;
  }

  Future<void> _excluir(Estabelecimento estabelecimento) async {
    final confirmado = await confirmarExclusao(
      context,
      titulo: 'Excluir estabelecimento?',
      mensagem:
          'Essa ação não pode ser desfeita. Só é possível excluir estabelecimentos sem ocorrências vinculadas.',
    );
    if (!confirmado) return;

    try {
      await _apiClient.excluirEstabelecimento(estabelecimento.id);
      _recarregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível excluir o estabelecimento.\n$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estabelecimentos')),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: FutureBuilder<List<Estabelecimento>>(
          future: _futureEstabelecimentos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar os estabelecimentos.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final estabelecimentos = snapshot.data ?? const [];
            if (estabelecimentos.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => ListView(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: Text('Nenhum estabelecimento cadastrado.')),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: estabelecimentos.length,
              itemBuilder: (context, index) {
                final estabelecimento = estabelecimentos[index];
                final endereco = [
                  estabelecimento.logradouro,
                  estabelecimento.numero,
                  estabelecimento.bairro,
                ].where((parte) => parte != null && parte.isNotEmpty).join(', ');
                return Card(
                  child: ListTile(
                    leading: Image.asset('assets/icons/icon_estabelecimento.png', width: 32, height: 32),
                    title: Text(estabelecimento.nome),
                    subtitle: Text(
                      endereco.isEmpty
                          ? '${estabelecimento.municipio}/${estabelecimento.uf}'
                          : '$endereco · ${estabelecimento.municipio}/${estabelecimento.uf}',
                    ),
                    trailing: widget.agenteLogado.podeExcluir
                        ? IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Excluir',
                            onPressed: () => _excluir(estabelecimento),
                          )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final criado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const EstabelecimentoFormScreen()),
          );
          if (criado == true) {
            _recarregar();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
