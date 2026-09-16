package br.edu.fatec.visacampo.area;

import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    private Area buscarOuFalhar(UUID id) {
        return areaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Área não encontrada"));
    }
}
