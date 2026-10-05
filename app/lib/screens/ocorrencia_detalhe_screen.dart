import 'package:flutter/material.dart';

import '../models/inspecao.dart';
import '../models/ocorrencia.dart';
import '../services/api_client.dart';
import 'inspecao_detalhe_screen.dart';
import 'inspecao_form_screen.dart';

class OcorrenciaDetalheScreen extends StatefulWidget {
  final Ocorrencia ocorrencia;
  final String nomeArea;
  final String nomeEstabelecimento;

  const OcorrenciaDetalheScreen({
    super.key,
    required this.ocorrencia,
    required this.nomeArea,
    required this.nomeEstabelecimento,
  });

  @override
  State<OcorrenciaDetalheScreen> createState() => _OcorrenciaDetalheScreenState();
}

class _OcorrenciaDetalheScreenState extends State<OcorrenciaDetalheScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<Inspecao>> _futureInspecoes;

  @override
  void initState() {
    super.initState();
    _futureInspecoes = _carregarInspecoes();
  }

  Future<void> _recarregar() {
    final futuro = _carregarInspecoes();
    setState(() {
      _futureInspecoes = futuro;
    });
    return futuro;
  }

  Future<List<Inspecao>> _carregarInspecoes() async {
    final todas = await _apiClient.listarInspecoes();
    return todas.where((inspecao) => inspecao.ocorrenciaId == widget.ocorrencia.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ocorrencia = widget.ocorrencia;
    return Scaffold(
      appBar: AppBar(title: Text(widget.nomeEstabelecimento)),
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
                    Text(widget.nomeEstabelecimento, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(widget.nomeArea, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text(ocorrencia.descricao),
                    const SizedBox(height: 12),
                    Text(
                      'Aberta em ${_formatarData(ocorrencia.criadoEm)} · '
                      'Atualizada em ${_formatarData(ocorrencia.atualizadoEm)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Inspeções', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<List<Inspecao>>(
              future: _futureInspecoes,
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
                    child: Text('Não foi possível carregar as inspeções.\n${snapshot.error}'),
                  );
                }

                final inspecoes = snapshot.data ?? const [];
                if (inspecoes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Nenhuma inspeção cadastrada para esta ocorrência.'),
                  );
                }

                return Column(
                  children: inspecoes
                      .map(
                        (inspecao) => Card(
                          child: ListTile(
                            title: Text(_formatarDataHora(inspecao.dataHora)),
                            subtitle: Text(inspecao.situacao.rotulo),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InspecaoDetalheScreen(inspecao: inspecao),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final criada = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => InspecaoFormScreen(ocorrenciaId: widget.ocorrencia.id),
            ),
          );
          if (criada == true) {
            _recarregar();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dataLocal = data.toLocal();
    final dia = dataLocal.day.toString().padLeft(2, '0');
    final mes = dataLocal.month.toString().padLeft(2, '0');
    final ano = dataLocal.year.toString();
    return '$dia/$mes/$ano';
  }

  String _formatarDataHora(DateTime data) {
    final dataLocal = data.toLocal();
    final hora = dataLocal.hour.toString().padLeft(2, '0');
    final minuto = dataLocal.minute.toString().padLeft(2, '0');
    return '${_formatarData(data)} às $hora:$minuto';
  }
}
