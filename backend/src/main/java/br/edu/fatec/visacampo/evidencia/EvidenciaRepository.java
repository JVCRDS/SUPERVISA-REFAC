package br.edu.fatec.visacampo.evidencia;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EvidenciaRepository extends JpaRepository<Evidencia, UUID> {
}
