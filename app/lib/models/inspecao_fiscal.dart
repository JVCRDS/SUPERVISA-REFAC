class InspecaoFiscal {
  final String id;
  final String inspecaoId;
  final String agenteId;
  final bool assinante;

  InspecaoFiscal({
    required this.id,
    required this.inspecaoId,
    required this.agenteId,
    required this.assinante,
  });

  factory InspecaoFiscal.fromJson(Map<String, dynamic> json) {
    return InspecaoFiscal(
      id: json['id'] as String,
      inspecaoId: json['inspecaoId'] as String,
      agenteId: json['agenteId'] as String,
      assinante: json['assinante'] as bool,
    );
  }
}
