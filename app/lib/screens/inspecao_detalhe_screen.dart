import 'package:flutter/material.dart';

import '../models/evidencia.dart';
import '../models/inspecao.dart';
import '../models/inspecao_fiscal.dart';
import '../services/api_client.dart';

class InspecaoDetalheScreen extends StatefulWidget {
  final Inspecao inspecao;

  const InspecaoDetalheScreen({super.key, required this.inspecao});

  @override
  State<InspecaoDetalheScreen> createState() => _InspecaoDetalheScreenState();
}

class _InspecaoDetalheScreenState extends State<InspecaoDetalheScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<_InspecaoDetalhes> _futureDetalhes;

  @override
  void initState() {
    super.initState();
    _futureDetalhes = _carregarDetalhes();
  }

  Future<void> _recarregar() {
    final futuro = _carregarDetalhes();
    setState(() {
      _futureDetalhes = futuro;
    });
    return futuro;
  }

  /// Busca fiscais e evidências da inspeção, filtrando no cliente (a API
  /// não tem parâmetros de filtro), e resolve o nome de cada fiscal uma
  /// única vez por agenteId.
  Future<_InspecaoDetalhes> _carregarDetalhes() async {
    final todosFiscais = await _apiClient.listarInspecaoFiscais();
    final fiscaisDaInspecao =
        todosFiscais.where((f) => f.inspecaoId == widget.inspecao.id).toList();

    final nomesAgente = <String, String>{};
    for (final fiscal in fiscaisDaInspecao) {
      if (!nomesAgente.containsKey(fiscal.agenteId)) {
        final agente = await _apiClient.buscarAgente(fiscal.agenteId);
        nomesAgente[fiscal.agenteId] = agente.nome;
      }
    }

    final todasEvidencias = await _apiClient.listarEvidencias();
    final evidenciasDaInspecao =
        todasEvidencias.where((e) => e.inspecaoId == widget.inspecao.id).toList();

    return _InspecaoDetalhes(
      fiscais: fiscaisDaInspecao,
      nomesAgente: nomesAgente,
      evidencias: evidenciasDaInspecao,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inspecao = widget.inspecao;
    return Scaffold(
      appBar: AppBar(title: Text('Inspeção de ${_formatarData(inspecao.dataHora)}')),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(label: Text(inspecao.situacao.rotulo)),
                        const SizedBox(width: 8),
                        Text(_formatarDataHora(inspecao.dataHora)),
                      ],
                    ),
                    if (inspecao.observacoesGerais != null &&
                        inspecao.observacoesGerais!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(inspecao.observacoesGerais!),
                    ],
                    if (inspecao.latitude != null && inspecao.longitude != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Local: ${inspecao.latitude!.toStringAsFixed(5)}, '
                        '${inspecao.longitude!.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<_InspecaoDetalhes>(
              future: _futureDetalhes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('Não foi possível carregar os detalhes.\n${snapshot.error}'),
                  );
                }

                final detalhes = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fiscais presentes', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (detalhes.fiscais.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Nenhum fiscal registrado.'),
                      )
                    else
                      ...detalhes.fiscais.map(
                        (fiscal) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.badge_outlined),
                            title: Text(detalhes.nomesAgente[fiscal.agenteId] ?? fiscal.agenteId),
                            trailing: fiscal.assinante ? const Chip(label: Text('Assinante')) : null,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text('Evidências', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (detalhes.evidencias.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Nenhuma evidência registrada.'),
                      )
                    else
                      ...detalhes.evidencias.map((evidencia) => _CartaoEvidencia(evidencia: evidencia)),
                  ],
                );
              },
            ),
          ],
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

  String _formatarDataHora(DateTime data) {
    final dataLocal = data.toLocal();
    final hora = dataLocal.hour.toString().padLeft(2, '0');
    final minuto = dataLocal.minute.toString().padLeft(2, '0');
    final dia = dataLocal.day.toString().padLeft(2, '0');
    final mes = dataLocal.month.toString().padLeft(2, '0');
    final ano = dataLocal.year.toString();
    return '$dia/$mes/$ano às $hora:$minuto';
  }
}

class _InspecaoDetalhes {
  final List<InspecaoFiscal> fiscais;
  final Map<String, String> nomesAgente;
  final List<Evidencia> evidencias;

  _InspecaoDetalhes({
    required this.fiscais,
    required this.nomesAgente,
    required this.evidencias,
  });
}

class _CartaoEvidencia extends StatelessWidget {
  final Evidencia evidencia;

  const _CartaoEvidencia({required this.evidencia});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.image_outlined),
        title: Text(evidencia.nomeArquivo),
        subtitle: Text('Capturada em ${_formatarDataHora(evidencia.capturadoEm)}'),
      ),
    );
  }

  String _formatarDataHora(DateTime data) {
    final dataLocal = data.toLocal();
    final dia = dataLocal.day.toString().padLeft(2, '0');
    final mes = dataLocal.month.toString().padLeft(2, '0');
    final hora = dataLocal.hour.toString().padLeft(2, '0');
    final minuto = dataLocal.minute.toString().padLeft(2, '0');
    return '$dia/$mes às $hora:$minuto';
  }
}
