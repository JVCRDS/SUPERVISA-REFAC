package br.edu.fatec.visacampo.agente;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AgenteRepository extends JpaRepository<Agente, UUID> {

    Optional<Agente> findByCpf(String cpf);
}
