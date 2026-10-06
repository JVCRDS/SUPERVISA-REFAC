import 'package:flutter/material.dart';

import '../models/agente.dart';
import '../models/situacao_inspecao.dart';
import '../services/api_client.dart';

/// Formulário de registro de uma nova inspeção vinculada a [ocorrenciaId].
/// Devolve `true` via [Navigator.pop] quando a inspeção é criada.
class InspecaoFormScreen extends StatefulWidget {
  final String ocorrenciaId;

  const InspecaoFormScreen({super.key, required this.ocorrenciaId});

  @override
  State<InspecaoFormScreen> createState() => _InspecaoFormScreenState();
}

class _InspecaoFormScreenState extends State<InspecaoFormScreen> {
  final ApiClient _apiClient = ApiClient();
  final _observacoesController = TextEditingController();

  late Future<List<Agente>> _futureFiscais;
  DateTime _dataHora = DateTime.now();
  SituacaoInspecao _situacao = SituacaoInspecao.emAndamento;
  final Set<String> _presentes = {};
  String? _assinanteId;
  bool _salvando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _futureFiscais = _carregarFiscais();
  }

  Future<List<Agente>> _carregarFiscais() async {
    final agentes = await _apiClient.listarAgentes();
    return agentes.where((a) => a.perfil == Perfil.fiscal && a.ativo).toList();
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _escolherDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataHora,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dataHora),
    );
    if (hora == null) return;

    setState(() {
      _dataHora = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
    });
  }

  void _alternarPresenca(String agenteId, bool? presente) {
    setState(() {
      if (presente == true) {
        _presentes.add(agenteId);
      } else {
        _presentes.remove(agenteId);
        if (_assinanteId == agenteId) _assinanteId = null;
      }
    });
  }

  Future<void> _salvar() async {
    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      final inspecao = await _apiClient.criarInspecao(
        ocorrenciaId: widget.ocorrenciaId,
        dataHora: _dataHora,
        situacao: _situacao,
        observacoesGerais:
            _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
      );

      for (final agenteId in _presentes) {
        await _apiClient.criarInspecaoFiscal(
          inspecaoId: inspecao.id,
          agenteId: agenteId,
          assinante: agenteId == _assinanteId,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _erro = 'Não foi possível salvar a inspeção.\n$e';
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
      appBar: AppBar(title: const Text('Nova inspeção')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Data e hora'),
            subtitle: Text(_formatarDataHora(_dataHora)),
            trailing: const Icon(Icons.edit_calendar_outlined),
            onTap: _escolherDataHora,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<SituacaoInspecao>(
            initialValue: _situacao,
            decoration: const InputDecoration(labelText: 'Situação'),
            items: SituacaoInspecao.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.rotulo)))
                .toList(),
            onChanged: (valor) {
              if (valor != null) setState(() => _situacao = valor);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacoesController,
            decoration: const InputDecoration(labelText: 'Observações gerais (opcional)'),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Text('Fiscais presentes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Marque quem esteve na inspeção e, entre eles, quem assina o auto de infração.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Agente>>(
            future: _futureFiscais,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Não foi possível carregar os fiscais.\n${snapshot.error}'),
                );
              }

              final fiscais = snapshot.data ?? const [];
              if (fiscais.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Nenhum fiscal cadastrado.'),
                );
              }

              return Column(
                children: fiscais.map((fiscal) {
                  final presente = _presentes.contains(fiscal.id);
                  return Card(
                    child: CheckboxListTile(
                      value: presente,
                      onChanged: (valor) => _alternarPresenca(fiscal.id, valor),
                      title: Text(fiscal.nome),
                      subtitle: presente
                          ? TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _assinanteId = _assinanteId == fiscal.id ? null : fiscal.id;
                                });
                              },
                              icon: Icon(
                                _assinanteId == fiscal.id ? Icons.star : Icons.star_border,
                                size: 18,
                              ),
                              label: Text(
                                _assinanteId == fiscal.id ? 'Assinante do auto' : 'Marcar como assinante',
                              ),
                            )
                          : null,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
              );
            },
          ),
          if (_erro != null) ...[
            const SizedBox(height: 16),
            Text(_erro!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _salvando ? null : _salvar,
            child: _salvando
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  String _formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano às $hora:$minuto';
  }
}
