package br.edu.fatec.visacampo.area;

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
@RequestMapping("/api/areas")
public class AreaController {

    private final AreaRepository areaRepository;

    public AreaController(AreaRepository areaRepository) {
        this.areaRepository = areaRepository;
    }

    @GetMapping
    public List<Area> listar() {
        return areaRepository.findAll();
    }

    @GetMapping("/{id}")
    public Area buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<Area> criar(@Valid @RequestBody Area area) {
        if (area.getId() == null) {
            area.setId(UUID.randomUUID());
        }
        if (area.getCriadoEm() == null) {
            area.setCriadoEm(OffsetDateTime.now());
        }
        Area salva = areaRepository.save(area);
        return ResponseEntity.created(URI.create("/api/areas/" + salva.getId())).body(salva);
    }

    @PutMapping("/{id}")
    public Area atualizar(@PathVariable UUID id, @Valid @RequestBody Area area) {
        Area existente = buscarOuFalhar(id);
        existente.setNome(area.getNome());
        existente.setDescricao(area.getDescricao());
        return areaRepository.save(existente);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        areaRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }

    private Area buscarOuFalhar(UUID id) {
        return areaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Área não encontrada"));
    }
}
