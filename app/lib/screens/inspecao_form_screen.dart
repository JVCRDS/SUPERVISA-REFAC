import 'package:flutter/material.dart';

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

  DateTime _dataHora = DateTime.now();
  SituacaoInspecao _situacao = SituacaoInspecao.emAndamento;
  bool _salvando = false;
  String? _erro;

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

  Future<void> _salvar() async {
    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      await _apiClient.criarInspecao(
        ocorrenciaId: widget.ocorrenciaId,
        dataHora: _dataHora,
        situacao: _situacao,
        observacoesGerais:
            _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
      );
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
