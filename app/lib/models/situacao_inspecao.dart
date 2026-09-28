enum SituacaoInspecao {
  emAndamento,
  concluida;

  static SituacaoInspecao fromJson(String valor) {
    switch (valor) {
      case 'CONCLUIDA':
        return SituacaoInspecao.concluida;
      case 'EM_ANDAMENTO':
      default:
        return SituacaoInspecao.emAndamento;
    }
  }

  String get rotulo {
    switch (this) {
      case SituacaoInspecao.concluida:
        return 'Concluída';
      case SituacaoInspecao.emAndamento:
        return 'Em andamento';
    }
  }
}
