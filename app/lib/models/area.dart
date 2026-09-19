class Area {
  final String id;
  final String nome;
  final String? descricao;
  final bool ativo;
  final DateTime criadoEm;

  Area({
    required this.id,
    required this.nome,
    this.descricao,
    required this.ativo,
    required this.criadoEm,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      ativo: json['ativo'] as bool,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}
