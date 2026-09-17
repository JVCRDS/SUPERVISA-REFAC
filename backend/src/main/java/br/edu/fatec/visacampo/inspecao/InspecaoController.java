package br.edu.fatec.visacampo.inspecao;

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
@RequestMapping("/api/inspecoes")
public class InspecaoController {

    private final InspecaoRepository inspecaoRepository;

    public InspecaoController(InspecaoRepository inspecaoRepository) {
        this.inspecaoRepository = inspecaoRepository;
    }

    @GetMapping
    public List<Inspecao> listar() {
        return inspecaoRepository.findAll();
    }

    @GetMapping("/{id}")
    public Inspecao buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<Inspecao> criar(@Valid @RequestBody Inspecao inspecao) {
        if (inspecao.getId() == null) {
            inspecao.setId(UUID.randomUUID());
        }
        if (inspecao.getDataHora() == null) {
            inspecao.setDataHora(OffsetDateTime.now());
        }
        if (inspecao.getCriadoEm() == null) {
            inspecao.setCriadoEm(OffsetDateTime.now());
        }
        Inspecao salva = inspecaoRepository.save(inspecao);
        return ResponseEntity.created(URI.create("/api/inspecoes/" + salva.getId())).body(salva);
    }

    @PutMapping("/{id}")
    public Inspecao atualizar(@PathVariable UUID id, @Valid @RequestBody Inspecao inspecao) {
        Inspecao existente = buscarOuFalhar(id);
        existente.setOcorrenciaId(inspecao.getOcorrenciaId());
        existente.setDataHora(inspecao.getDataHora());
        existente.setLatitude(inspecao.getLatitude());
        existente.setLongitude(inspecao.getLongitude());
        existente.setSituacao(inspecao.getSituacao());
        existente.setObservacoesGerais(inspecao.getObservacoesGerais());
        return inspecaoRepository.save(existente);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        inspecaoRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }

    private Inspecao buscarOuFalhar(UUID id) {
        return inspecaoRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Inspeção não encontrada"));
    }
}
