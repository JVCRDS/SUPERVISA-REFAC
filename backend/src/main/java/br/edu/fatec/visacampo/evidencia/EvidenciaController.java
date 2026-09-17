package br.edu.fatec.visacampo.evidencia;

import br.edu.fatec.visacampo.logauditoria.AcaoAuditoria;
import br.edu.fatec.visacampo.logauditoria.LogAuditoria;
import br.edu.fatec.visacampo.logauditoria.LogAuditoriaRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import java.net.URI;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Evidência é imutável por decisão de arquitetura: sem UPDATE após a
 * captura. Por isso este controller não tem @PutMapping; a exclusão fica
 * registrada em log_auditoria antes de remover a linha.
 */
@RestController
@RequestMapping("/api/evidencias")
public class EvidenciaController {

    private final EvidenciaRepository evidenciaRepository;
    private final LogAuditoriaRepository logAuditoriaRepository;
    private final ObjectMapper objectMapper;

    public EvidenciaController(
            EvidenciaRepository evidenciaRepository,
            LogAuditoriaRepository logAuditoriaRepository,
            ObjectMapper objectMapper) {
        this.evidenciaRepository = evidenciaRepository;
        this.logAuditoriaRepository = logAuditoriaRepository;
        this.objectMapper = objectMapper;
    }

    @GetMapping
    public List<Evidencia> listar() {
        return evidenciaRepository.findAll();
    }

    @GetMapping("/{id}")
    public Evidencia buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<Evidencia> criar(@Valid @RequestBody Evidencia evidencia) {
        if (evidencia.getId() == null) {
            evidencia.setId(UUID.randomUUID());
        }
        if (evidencia.getCriadoEm() == null) {
            evidencia.setCriadoEm(OffsetDateTime.now());
        }
        Evidencia salva = evidenciaRepository.save(evidencia);
        return ResponseEntity.created(URI.create("/api/evidencias/" + salva.getId())).body(salva);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id, @RequestParam UUID agenteId) {
        Evidencia evidencia = buscarOuFalhar(id);
        registrarExclusao(evidencia, agenteId);
        evidenciaRepository.delete(evidencia);
        return ResponseEntity.noContent().build();
    }

    private void registrarExclusao(Evidencia evidencia, UUID agenteId) {
        LogAuditoria log = new LogAuditoria();
        log.setId(UUID.randomUUID());
        log.setTabela("evidencia");
        log.setRegistroId(evidencia.getId());
        log.setAcao(AcaoAuditoria.DELETE);
        log.setAgenteId(agenteId);
        log.setDadosAnteriores(serializar(evidencia));
        log.setRealizadoEm(OffsetDateTime.now());
        logAuditoriaRepository.save(log);
    }

    private String serializar(Evidencia evidencia) {
        try {
            return objectMapper.writeValueAsString(evidencia);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Falha ao serializar evidência para o log de auditoria", e);
        }
    }

    private Evidencia buscarOuFalhar(UUID id) {
        return evidenciaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Evidência não encontrada"));
    }
}
