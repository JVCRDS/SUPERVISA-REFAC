class Ocorrencia {
  final String id;
  final String areaId;
  final String estabelecimentoId;
  final String descricao;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Ocorrencia({
    required this.id,
    required this.areaId,
    required this.estabelecimentoId,
    required this.descricao,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] as String,
      areaId: json['areaId'] as String,
      estabelecimentoId: json['estabelecimentoId'] as String,
      descricao: json['descricao'] as String,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
      atualizadoEm: DateTime.parse(json['atualizadoEm'] as String),
    );
  }
}
