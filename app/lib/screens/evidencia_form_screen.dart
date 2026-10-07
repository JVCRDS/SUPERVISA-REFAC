import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/agente.dart';
import '../services/api_client.dart';

/// Formulário de registro de uma nova evidência vinculada a [inspecaoId].
/// O arquivo em si nunca sai do dispositivo (decisão de arquitetura do
/// projeto) — só os metadados (nome, hash SHA-256, autor, data) vão pro
/// servidor. Devolve `true` via [Navigator.pop] quando a evidência é
/// registrada.
class EvidenciaFormScreen extends StatefulWidget {
  final String inspecaoId;

  const EvidenciaFormScreen({super.key, required this.inspecaoId});

  @override
  State<EvidenciaFormScreen> createState() => _EvidenciaFormScreenState();
}

class _EvidenciaFormScreenState extends State<EvidenciaFormScreen> {
  final ApiClient _apiClient = ApiClient();
  final ImagePicker _imagePicker = ImagePicker();

  late Future<List<Agente>> _futureAgentes;
  XFile? _arquivo;
  Uint8List? _bytes;
  String? _hashSha256;
  DateTime? _capturadoEm;
  String? _autorId;

  bool _calculandoHash = false;
  bool _salvando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _futureAgentes = _apiClient.listarAgentes();
  }

  Future<void> _escolherFoto(ImageSource origem) async {
    final arquivo = await _imagePicker.pickImage(source: origem, imageQuality: 85);
    if (arquivo == null) return;

    setState(() {
      _arquivo = arquivo;
      _hashSha256 = null;
      _calculandoHash = true;
      _erro = null;
    });

    final bytes = await arquivo.readAsBytes();
    final hash = sha256.convert(bytes).toString();

    if (!mounted) return;
    setState(() {
      _bytes = bytes;
      _hashSha256 = hash;
      _capturadoEm = DateTime.now();
      _calculandoHash = false;
    });
  }

  Future<void> _salvar() async {
    if (_arquivo == null || _hashSha256 == null || _capturadoEm == null) {
      setState(() => _erro = 'Escolha uma foto.');
      return;
    }
    if (_autorId == null) {
      setState(() => _erro = 'Selecione o autor da captura.');
      return;
    }

    setState(() {
      _salvando = true;
      _erro = null;
    });

    try {
      await _apiClient.criarEvidencia(
        inspecaoId: widget.inspecaoId,
        autorId: _autorId!,
        nomeArquivo: _arquivo!.name,
        hashSha256: _hashSha256!,
        capturadoEm: _capturadoEm!,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _erro = 'Não foi possível salvar a evidência.\n$e';
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
      appBar: AppBar(title: const Text('Nova evidência')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_bytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_bytes!, height: 220, width: double.infinity, fit: BoxFit.cover),
            )
          else
            Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 64)),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _escolherFoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Câmera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _escolherFoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeria'),
                ),
              ),
            ],
          ),
          if (_calculandoHash) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_arquivo != null && _hashSha256 != null) ...[
            const SizedBox(height: 16),
            Text(_arquivo!.name, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              'SHA-256: ${_hashSha256!.substring(0, 16)}…',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Capturada em ${_formatarDataHora(_capturadoEm!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          Text('Autor da captura', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<Agente>>(
            future: _futureAgentes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Não foi possível carregar os agentes.\n${snapshot.error}');
              }

              final agentes = snapshot.data ?? const [];
              return DropdownButtonFormField<String>(
                initialValue: _autorId,
                decoration: const InputDecoration(labelText: 'Agente'),
                items: agentes
                    .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome)))
                    .toList(),
                onChanged: (valor) => setState(() => _autorId = valor),
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
    final dataLocal = data.toLocal();
    final dia = dataLocal.day.toString().padLeft(2, '0');
    final mes = dataLocal.month.toString().padLeft(2, '0');
    final hora = dataLocal.hour.toString().padLeft(2, '0');
    final minuto = dataLocal.minute.toString().padLeft(2, '0');
    return '$dia/$mes às $hora:$minuto';
  }
}
