import 'package:flutter/material.dart';

import '../services/api_client.dart';

/// Formulário de cadastro de um novo estabelecimento. Devolve `true` via
/// [Navigator.pop] quando o estabelecimento é criado, pra quem chamou
/// saber que precisa recarregar a lista.
class EstabelecimentoFormScreen extends StatefulWidget {
  const EstabelecimentoFormScreen({super.key});

  @override
  State<EstabelecimentoFormScreen> createState() => _EstabelecimentoFormScreenState();
}

class _EstabelecimentoFormScreenState extends State<EstabelecimentoFormScreen> {
  final ApiClient _apiClient = ApiClient();
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _municipioController = TextEditingController(text: 'Ribeirão Preto');
  final _ufController = TextEditingController(text: 'SP');
  final _cepController = TextEditingController();

  bool _salvando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _municipioController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      await _apiClient.criarEstabelecimento(
        nome: _nomeController.text.trim(),
        cnpj: _cnpjController.text.trim(),
        logradouro: _logradouroController.text.trim(),
        numero: _numeroController.text.trim(),
        complemento: _complementoController.text.trim(),
        bairro: _bairroController.text.trim(),
        municipio: _municipioController.text.trim(),
        uf: _ufController.text.trim(),
        cep: _cepController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _erro = 'Não foi possível salvar o estabelecimento.\n$e';
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
      appBar: AppBar(title: const Text('Novo estabelecimento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (valor) =>
                  (valor == null || valor.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cnpjController,
              decoration: const InputDecoration(labelText: 'CNPJ (opcional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _logradouroController,
              decoration: const InputDecoration(labelText: 'Logradouro (opcional)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _numeroController,
                    decoration: const InputDecoration(labelText: 'Número (opcional)'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _complementoController,
                    decoration: const InputDecoration(labelText: 'Complemento (opcional)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bairroController,
              decoration: const InputDecoration(labelText: 'Bairro (opcional)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _municipioController,
                    decoration: const InputDecoration(labelText: 'Município'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _ufController,
                    decoration: const InputDecoration(labelText: 'UF'),
                    maxLength: 2,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'CEP (opcional)'),
              keyboardType: TextInputType.number,
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
      ),
    );
  }
}
