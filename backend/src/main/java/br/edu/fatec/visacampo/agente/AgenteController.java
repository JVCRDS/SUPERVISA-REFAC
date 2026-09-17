package br.edu.fatec.visacampo.agente;

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
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/agentes")
public class AgenteController {

    private final AgenteRepository agenteRepository;

    public AgenteController(AgenteRepository agenteRepository) {
        this.agenteRepository = agenteRepository;
    }

    @GetMapping
    public List<Agente> listar() {
        return agenteRepository.findAll();
    }

    @GetMapping("/{id}")
    public Agente buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<Agente> criar(@Valid @RequestBody Agente agente) {
        if (agente.getId() == null) {
            agente.setId(UUID.randomUUID());
        }
        if (agente.getCriadoEm() == null) {
            agente.setCriadoEm(OffsetDateTime.now());
        }
        Agente salvo = agenteRepository.save(agente);
        return ResponseEntity.created(URI.create("/api/agentes/" + salvo.getId())).body(salvo);
    }

    @PutMapping("/{id}")
    public Agente atualizar(@PathVariable UUID id, @Valid @RequestBody Agente agente) {
        Agente existente = buscarOuFalhar(id);
        existente.setNome(agente.getNome());
        existente.setEmail(agente.getEmail());
        existente.setSenhaHash(agente.getSenhaHash());
        existente.setPerfil(agente.getPerfil());
        existente.setAreaId(agente.getAreaId());
        existente.setAtivo(agente.isAtivo());
        return agenteRepository.save(existente);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        agenteRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }

    private Agente buscarOuFalhar(UUID id) {
        return agenteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agente não encontrado"));
    }
}
