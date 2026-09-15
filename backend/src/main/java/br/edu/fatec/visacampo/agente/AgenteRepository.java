package br.edu.fatec.visacampo.agente;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AgenteRepository extends JpaRepository<Agente, UUID> {
}
