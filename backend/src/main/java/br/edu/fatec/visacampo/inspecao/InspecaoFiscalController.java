package br.edu.fatec.visacampo.inspecao;

import jakarta.validation.Valid;
import java.net.URI;
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
@RequestMapping("/api/inspecoes-fiscais")
public class InspecaoFiscalController {

    private final InspecaoFiscalRepository inspecaoFiscalRepository;

    public InspecaoFiscalController(InspecaoFiscalRepository inspecaoFiscalRepository) {
        this.inspecaoFiscalRepository = inspecaoFiscalRepository;
    }

    @GetMapping
    public List<InspecaoFiscal> listar() {
        return inspecaoFiscalRepository.findAll();
    }

    @GetMapping("/{id}")
    public InspecaoFiscal buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<InspecaoFiscal> criar(@Valid @RequestBody InspecaoFiscal inspecaoFiscal) {
        if (inspecaoFiscal.getId() == null) {
            inspecaoFiscal.setId(UUID.randomUUID());
        }
        InspecaoFiscal salvo = inspecaoFiscalRepository.save(inspecaoFiscal);
        return ResponseEntity.created(URI.create("/api/inspecoes-fiscais/" + salvo.getId())).body(salvo);
    }

    @PutMapping("/{id}")
    public InspecaoFiscal atualizar(@PathVariable UUID id, @Valid @RequestBody InspecaoFiscal inspecaoFiscal) {
        InspecaoFiscal existente = buscarOuFalhar(id);
        existente.setInspecaoId(inspecaoFiscal.getInspecaoId());
        existente.setAgenteId(inspecaoFiscal.getAgenteId());
        existente.setAssinante(inspecaoFiscal.isAssinante());
        return inspecaoFiscalRepository.save(existente);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        inspecaoFiscalRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }

    private InspecaoFiscal buscarOuFalhar(UUID id) {
        return inspecaoFiscalRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Fiscal da inspeção não encontrado"));
    }
}
