enum Perfil {
  administrativo,
  chefe,
  fiscal;

  static Perfil fromJson(String valor) {
    switch (valor) {
      case 'ADMINISTRATIVO':
        return Perfil.administrativo;
      case 'CHEFE':
        return Perfil.chefe;
      case 'FISCAL':
      default:
        return Perfil.fiscal;
    }
  }

  String get rotulo {
    switch (this) {
      case Perfil.administrativo:
        return 'Administrativo';
      case Perfil.chefe:
        return 'Chefe';
      case Perfil.fiscal:
        return 'Fiscal';
    }
  }
}

class Agente {
  final String id;
  final String nome;
  final String email;
  final Perfil perfil;
  final String areaId;
  final bool ativo;
  final DateTime criadoEm;

  Agente({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    required this.areaId,
    required this.ativo,
    required this.criadoEm,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      perfil: Perfil.fromJson(json['perfil'] as String),
      areaId: json['areaId'] as String,
      ativo: json['ativo'] as bool,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}
