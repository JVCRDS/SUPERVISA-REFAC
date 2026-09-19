import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/area.dart';
import '../models/estabelecimento.dart';
import '../models/ocorrencia.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
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

  Future<Estabelecimento> buscarEstabelecimento(String id) async {
    final resposta = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/estabelecimentos/$id'));
    _verificarResposta(resposta);
    return Estabelecimento.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  }

  void _verificarResposta(http.Response resposta) {
    if (resposta.statusCode >= 400) {
      throw ApiException('Erro ${resposta.statusCode} ao consultar ${resposta.request?.url}');
    }
  }
}
