class Estabelecimento {
  final String id;
  final String nome;
  final String? cnpj;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String municipio;
  final String uf;
  final String? cep;
  final DateTime criadoEm;

  Estabelecimento({
    required this.id,
    required this.nome,
    this.cnpj,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    required this.municipio,
    required this.uf,
    this.cep,
    required this.criadoEm,
  });

  factory Estabelecimento.fromJson(Map<String, dynamic> json) {
    return Estabelecimento(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cnpj: json['cnpj'] as String?,
      logradouro: json['logradouro'] as String?,
      numero: json['numero'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String?,
      municipio: json['municipio'] as String,
      uf: json['uf'] as String,
      cep: json['cep'] as String?,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }
}
