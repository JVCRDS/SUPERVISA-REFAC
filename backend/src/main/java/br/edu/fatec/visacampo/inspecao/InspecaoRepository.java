package br.edu.fatec.visacampo.inspecao;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InspecaoRepository extends JpaRepository<Inspecao, UUID> {
}
