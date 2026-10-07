package br.edu.fatec.visacampo.auth;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SessaoRepository extends JpaRepository<Sessao, UUID> {

    Optional<Sessao> findByToken(String token);

    void deleteByToken(String token);
}
