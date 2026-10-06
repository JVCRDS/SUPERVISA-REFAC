import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/agente.dart';
import '../models/area.dart';
import '../models/estabelecimento.dart';
import '../models/evidencia.dart';
import '../models/inspecao.dart';
import '../models/inspecao_fiscal.dart';
import '../models/ocorrencia.dart';
import '../models/situacao_inspecao.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class CredenciaisInvalidasException implements Exception {
  @override
  String toString() => 'CPF ou senha inválidos';
}

/// Cliente HTTP fino para a API do visa-campo. Cada método corresponde a um
/// endpoint do backend e devolve o modelo já convertido do JSON.
class ApiClient {
  Future<List<Ocorrencia>> listarOcorrencias() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/ocorrencias'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Ocorrencia.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Area> buscarArea(String id) async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/areas/$id'));
    _verificarResposta(resposta);
    return Area.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  Future<List<Area>> listarAreas() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/areas'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Area.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Estabelecimento> buscarEstabelecimento(String id) async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/estabelecimentos/$id'));
    _verificarResposta(resposta);
    return Estabelecimento.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  Future<List<Estabelecimento>> listarEstabelecimentos() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/estabelecimentos'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Estabelecimento.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<Inspecao>> listarInspecoes() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/inspecoes'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Inspecao.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<InspecaoFiscal>> listarInspecaoFiscais() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/inspecoes-fiscais'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => InspecaoFiscal.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<Evidencia>> listarEvidencias() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/evidencias'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Evidencia.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<Agente> buscarAgente(String id) async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/agentes/$id'));
    _verificarResposta(resposta);
    return Agente.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  Future<List<Agente>> listarAgentes() async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/agentes'));
    _verificarResposta(resposta);
    final lista = jsonDecode(resposta.body) as List<dynamic>;
    return lista.map((item) => Agente.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Cria uma ocorrência. O servidor gera o `id` e o `criadoEm` quando
  /// omitidos no corpo, então o cliente só precisa informar os dados do
  /// formulário.
  Future<Ocorrencia> criarOcorrencia({
    required String areaId,
    required String estabelecimentoId,
    required String descricao,
  }) async {
    final resposta = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/ocorrencias'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'areaId': areaId,
        'estabelecimentoId': estabelecimentoId,
        'descricao': descricao,
      }),
    );
    _verificarResposta(resposta);
    return Ocorrencia.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  /// Cria uma inspeção. O servidor gera o `id`, e `dataHora`/`criadoEm`
  /// quando omitidos, então aqui sempre mandamos a data escolhida no
  /// formulário.
  Future<Inspecao> criarInspecao({
    required String ocorrenciaId,
    required DateTime dataHora,
    required SituacaoInspecao situacao,
    String? observacoesGerais,
  }) async {
    final resposta = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/inspecoes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ocorrenciaId': ocorrenciaId,
        'dataHora': dataHora.toUtc().toIso8601String(),
        'situacao': situacao.codigo,
        'observacoesGerais': observacoesGerais,
      }),
    );
    _verificarResposta(resposta);
    return Inspecao.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  /// Confere CPF e senha. O servidor só confirma a identidade do agente —
  /// ainda não há sessão/token (fica para quando a autenticação de rotas
  /// for implementada), então o próprio ApiClient não guarda nada após a
  /// chamada; quem chama decide o que fazer com o [Agente] devolvido.
  Future<Agente> login({required String cpf, required String senha}) async {
    final resposta = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cpf': cpf, 'senha': senha}),
    );
    if (resposta.statusCode == 401) {
      throw CredenciaisInvalidasException();
    }
    _verificarResposta(resposta);
    return Agente.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  void _verificarResposta(http.Response resposta) {
    if (resposta.statusCode >= 400) {
      throw ApiException('Erro ${resposta.statusCode} ao consultar ${resposta.request?.url}');
    }
  }
}
