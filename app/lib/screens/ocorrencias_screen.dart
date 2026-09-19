import 'package:flutter/material.dart';

import '../models/ocorrencia.dart';
import '../services/api_client.dart';

class OcorrenciasScreen extends StatefulWidget {
  const OcorrenciasScreen({super.key});

  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<_OcorrenciaExibicao>> _futureOcorrencias;

  @override
  void initState() {
    super.initState();
    _futureOcorrencias = _carregarOcorrencias();
  }

  Future<void> _recarregar() {
    final futuro = _carregarOcorrencias();
    setState(() {
      _futureOcorrencias = futuro;
    });
    return futuro;
  }

  /// Busca as ocorrências e resolve nome de área/estabelecimento no
  /// cliente, cada um só uma vez por id (evita repetir a mesma chamada
  /// pra ids que aparecem em mais de uma ocorrência).
  Future<List<_OcorrenciaExibicao>> _carregarOcorrencias() async {
    final ocorrencias = await _apiClient.listarOcorrencias();

    final nomesArea = <String, String>{};
    final nomesEstabelecimento = <String, String>{};

    for (final ocorrencia in ocorrencias) {
      nomesArea.putIfAbsent(
        ocorrencia.areaId,
        () => '',
      );
      nomesEstabelecimento.putIfAbsent(
        ocorrencia.estabelecimentoId,
        () => '',
      );
    }

    for (final areaId in nomesArea.keys.toList()) {
      final area = await _apiClient.buscarArea(areaId);
      nomesArea[areaId] = area.nome;
    }
    for (final estabelecimentoId in nomesEstabelecimento.keys.toList()) {
      final estabelecimento = await _apiClient.buscarEstabelecimento(estabelecimentoId);
      nomesEstabelecimento[estabelecimentoId] = estabelecimento.nome;
    }

    return ocorrencias
        .map((ocorrencia) => _OcorrenciaExibicao(
              ocorrencia: ocorrencia,
              nomeArea: nomesArea[ocorrencia.areaId] ?? ocorrencia.areaId,
              nomeEstabelecimento:
                  nomesEstabelecimento[ocorrencia.estabelecimentoId] ?? ocorrencia.estabelecimentoId,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocorrências')),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: FutureBuilder<List<_OcorrenciaExibicao>>(
          future: _futureOcorrencias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _ErroCarregamento(
                erro: snapshot.error.toString(),
                onTentarNovamente: _recarregar,
              );
            }

            final ocorrencias = snapshot.data ?? const [];
            if (ocorrencias.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => ListView(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: Text('Nenhuma ocorrência cadastrada.')),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: ocorrencias.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = ocorrencias[index];
                return ListTile(
                  title: Text(item.nomeEstabelecimento),
                  subtitle: Text('${item.nomeArea} · ${item.ocorrencia.descricao}'),
                  trailing: Text(_formatarData(item.ocorrencia.criadoEm)),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dataLocal = data.toLocal();
    final dia = dataLocal.day.toString().padLeft(2, '0');
    final mes = dataLocal.month.toString().padLeft(2, '0');
    return '$dia/$mes';
  }
}

class _OcorrenciaExibicao {
  final Ocorrencia ocorrencia;
  final String nomeArea;
  final String nomeEstabelecimento;

  _OcorrenciaExibicao({
    required this.ocorrencia,
    required this.nomeArea,
    required this.nomeEstabelecimento,
  });
}

class _ErroCarregamento extends StatelessWidget {
  final String erro;
  final Future<void> Function() onTentarNovamente;

  const _ErroCarregamento({required this.erro, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Não foi possível carregar as ocorrências.\n$erro',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onTentarNovamente,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
