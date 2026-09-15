package br.edu.fatec.visacampo.area;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
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
    public List<AreaResponse> listar() {
        return areaRepository.findAll().stream().map(AreaResponse::from).toList();
    }

    @GetMapping("/{id}")
    public AreaResponse buscar(@PathVariable UUID id) {
        return AreaResponse.from(buscarOuFalhar(id));
    }

    @PostMapping
    public ResponseEntity<AreaResponse> criar(@Valid @RequestBody AreaRequest request) {
        Area area = new Area(UUID.randomUUID(), request.nome(), request.descricao());
        Area salva = areaRepository.save(area);
        return ResponseEntity.created(URI.create("/api/areas/" + salva.getId()))
                .body(AreaResponse.from(salva));
    }

    @PutMapping("/{id}")
    public AreaResponse atualizar(@PathVariable UUID id, @Valid @RequestBody AreaRequest request) {
        Area area = buscarOuFalhar(id);
        area.setNome(request.nome());
        area.setDescricao(request.descricao());
        return AreaResponse.from(areaRepository.save(area));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        Area area = buscarOuFalhar(id);
        areaRepository.delete(area);
        return ResponseEntity.noContent().build();
    }

    private Area buscarOuFalhar(UUID id) {
        return areaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Área não encontrada"));
    }

    public record AreaRequest(
            @NotBlank(message = "nome é obrigatório") String nome,
            String descricao) {
    }

    public record AreaResponse(
            UUID id,
            String nome,
            String descricao,
            boolean ativo,
            OffsetDateTime criadoEm) {

        static AreaResponse from(Area area) {
            return new AreaResponse(
                    area.getId(),
                    area.getNome(),
                    area.getDescricao(),
                    area.isAtivo(),
                    area.getCriadoEm());
        }
    }
}
