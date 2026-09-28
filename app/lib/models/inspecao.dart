import 'situacao_inspecao.dart';

class Inspecao {
  final String id;
  final String ocorrenciaId;
  final DateTime dataHora;
  final double? latitude;
  final double? longitude;
  final SituacaoInspecao situacao;
  final String? observacoesGerais;
  final DateTime criadoEm;

  Inspecao({
    required this.id,
    required this.ocorrenciaId,
    required this.dataHora,
    this.latitude,
    this.longitude,
    required this.situacao,
    this.observacoesGerais,
    required this.criadoEm,
  });

  factory Inspecao.fromJson(Map<String, dynamic> json) {
    return Inspecao(
      id: json['id'] as String,
      ocorrenciaId: json['ocorrenciaId'] as String,
      dataHora: DateTime.parse(json['dataHora'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      situacao: SituacaoInspecao.fromJson(json['situacao'] as String),
      observacoesGerais: json['observacoesGerais'] as String?,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}
