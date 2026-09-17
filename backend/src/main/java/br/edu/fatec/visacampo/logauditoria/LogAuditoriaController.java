package br.edu.fatec.visacampo.logauditoria;

import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Somente leitura: quem escreve em log_auditoria é o próprio backend (ex:
 * EvidenciaController ao excluir), nunca o cliente diretamente.
 */
@RestController
@RequestMapping("/api/logs-auditoria")
public class LogAuditoriaController {

    private final LogAuditoriaRepository logAuditoriaRepository;

    public LogAuditoriaController(LogAuditoriaRepository logAuditoriaRepository) {
        this.logAuditoriaRepository = logAuditoriaRepository;
    }

    @GetMapping
    public List<LogAuditoria> listar() {
        return logAuditoriaRepository.findAll();
    }

    @GetMapping("/{id}")
    public LogAuditoria buscar(@PathVariable UUID id) {
        return logAuditoriaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Log de auditoria não encontrado"));
    }
}
