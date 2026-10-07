import 'package:flutter/material.dart';

import '../models/area.dart';
import '../models/estabelecimento.dart';
import '../services/api_client.dart';

/// Formulário de cadastro de uma nova ocorrência. Devolve `true` via
/// [Navigator.pop] quando a ocorrência é criada, pra quem chamou saber que
/// precisa recarregar a lista.
class OcorrenciaFormScreen extends StatefulWidget {
  const OcorrenciaFormScreen({super.key});

  @override
  State<OcorrenciaFormScreen> createState() => _OcorrenciaFormScreenState();
}

class _OcorrenciaFormScreenState extends State<OcorrenciaFormScreen> {
  final ApiClient _apiClient = ApiClient();
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  late Future<(List<Area>, List<Estabelecimento>)> _futureOpcoes;
  String? _areaId;
  String? _estabelecimentoId;
  bool _salvando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _futureOpcoes = _carregarOpcoes();
  }

  Future<(List<Area>, List<Estabelecimento>)> _carregarOpcoes() async {
    final areas = await _apiClient.listarAreas();
    final estabelecimentos = await _apiClient.listarEstabelecimentos();
    return (areas, estabelecimentos);
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _areaId == null || _estabelecimentoId == null) {
      setState(() {
        _erro = _areaId == null || _estabelecimentoId == null
            ? 'Selecione a área e o estabelecimento.'
            : null;
      });
      return;
    }

    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      await _apiClient.criarOcorrencia(
        areaId: _areaId!,
        estabelecimentoId: _estabelecimentoId!,
        descricao: _descricaoController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _erro = 'Não foi possível salvar a ocorrência.\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova ocorrência')),
      body: FutureBuilder<(List<Area>, List<Estabelecimento>)>(
        future: _futureOpcoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar áreas e estabelecimentos.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final (areas, estabelecimentos) = snapshot.data!;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _areaId,
                  decoration: const InputDecoration(labelText: 'Área'),
                  items: areas
                      .map((area) => DropdownMenuItem(value: area.id, child: Text(area.nome)))
                      .toList(),
                  onChanged: (valor) => setState(() => _areaId = valor),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _estabelecimentoId,
                  decoration: const InputDecoration(labelText: 'Estabelecimento'),
                  items: estabelecimentos
                      .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome)))
                      .toList(),
                  onChanged: (valor) => setState(() => _estabelecimentoId = valor),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  validator: (valor) =>
                      (valor == null || valor.trim().isEmpty) ? 'Informe uma descrição' : null,
                ),
                if (_erro != null) ...[
                  const SizedBox(height: 16),
                  Text(_erro!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
