class Evidencia {
  final String id;
  final String inspecaoId;
  final String autorId;
  final String nomeArquivo;
  final String hashSha256;
  final DateTime capturadoEm;
  final double? latitude;
  final double? longitude;
  final DateTime criadoEm;

  Evidencia({
    required this.id,
    required this.inspecaoId,
    required this.autorId,
    required this.nomeArquivo,
    required this.hashSha256,
    required this.capturadoEm,
    this.latitude,
    this.longitude,
    required this.criadoEm,
  });

  factory Evidencia.fromJson(Map<String, dynamic> json) {
    return Evidencia(
      id: json['id'] as String,
      inspecaoId: json['inspecaoId'] as String,
      autorId: json['autorId'] as String,
      nomeArquivo: json['nomeArquivo'] as String,
      hashSha256: json['hashSha256'] as String,
      capturadoEm: DateTime.parse(json['capturadoEm'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}
