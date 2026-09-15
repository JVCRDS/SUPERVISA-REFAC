package br.edu.fatec.visacampo.estabelecimento;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EstabelecimentoRepository extends JpaRepository<Estabelecimento, UUID> {
}
