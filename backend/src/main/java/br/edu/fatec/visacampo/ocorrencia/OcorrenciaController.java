
package br.edu.fatec.visacampo.ocorrencia;

import jakarta.validation.Valid;
import java.net.URI;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;



@RestController
@RequestMapping("/api/ocorrencias")
public class OcorrenciaController {
    private final OcorrenciaRepository ocorrenciaRepository;

    public OcorrenciaController(OcorrenciaRepository ocorrenciaRepository) {
        this.ocorrenciaRepository = ocorrenciaRepository;
    }
    
    public ResponseEntity<Ocorrencia> criar(@Valid @RequestBody Ocorrencia ocorrencia) {
        if (ocorrencia.getId() == null) {
            ocorrencia.setId(UUID.randomUUID());
        }
        if (ocorrencia.getCriadoEm() == null) {
            ocorrencia.setCriadoEm(OffsetDateTime.now());
        }
        Ocorrencia salva = ocorrenciaRepository.save(ocorrencia);
        return ResponseEntity.created(URI.create("/api/ocorrencias/" + salva.getId())).body(salva);
    }
    
    @GetMapping ("/{id}")
    public List<Ocorrencia> listar() {
        return ocorrenciaRepository.findAll();
    }
    
    @PutMapping ("/{id}")
    public Ocorrencia atualizar(@PathVariable UUID id, @Valid @RequestBody Ocorrencia ocorrencia){
        Ocorrencia existente = buscarOuFalhar(id);
        existente.setAreaId(ocorrencia.getAreaId());
        existente.setEstabelecimentoId(ocorrencia.getEstabelecimentoId());
        existente.setCriadoEm(ocorrencia.getCriadoEm());
        existente.setAtualizadoEm(new Timestamp(System.currentTimeMillis()));
        return ocorrenciaRepository.save(existente);
        
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        ocorrenciaRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }
    
    private Ocorrencia buscarOuFalhar(UUID id) {
        return ocorrenciaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Ocorrencia não encontrada"));
    }

    
}
