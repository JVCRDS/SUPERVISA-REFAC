package br.edu.fatec.visacampo.logauditoria;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LogAuditoriaRepository extends JpaRepository<LogAuditoria, UUID> {
}
