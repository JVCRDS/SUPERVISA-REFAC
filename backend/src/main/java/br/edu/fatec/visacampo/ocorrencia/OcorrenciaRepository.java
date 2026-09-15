package br.edu.fatec.visacampo.ocorrencia;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OcorrenciaRepository extends JpaRepository<Ocorrencia, UUID> {
}
