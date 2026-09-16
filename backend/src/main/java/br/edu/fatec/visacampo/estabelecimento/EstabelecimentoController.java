
package br.edu.fatec.visacampo.estabelecimento;


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
@RequestMapping("/api/estabelecimentos")
public class EstabelecimentoController {

    private final EstabelecimentoRepository estabelecimentoRepository;

    public EstabelecimentoController(EstabelecimentoRepository estabelecimentoRepository) {
        this.estabelecimentoRepository = estabelecimentoRepository;
    }

    @GetMapping
    public List<Estabelecimento> listar() {
        return estabelecimentoRepository.findAll();
    }

    @GetMapping("/{id}")
    public Estabelecimento buscar(@PathVariable UUID id) {
        return buscarOuFalhar(id);
    }

    @PostMapping
    public ResponseEntity<Estabelecimento> criar(@Valid @RequestBody Estabelecimento estabelecimento) {
        if (estabelecimento.getId() == null) {
            estabelecimento.setId(UUID.randomUUID());
        }
        if (estabelecimento.getCriadoEm() == null) {
            estabelecimento.setCriadoEm(OffsetDateTime.now());
        }
        Estabelecimento salva = estabelecimentoRepository.save(estabelecimento);
        return ResponseEntity.created(URI.create("/api/estabelecimentos/" + salva.getId())).body(salva);
    }

    @PutMapping("/{id}")
    public Estabelecimento atualizar(@PathVariable UUID id, @Valid @RequestBody Estabelecimento estabelecimento) {
        Estabelecimento existente = buscarOuFalhar(id);
        existente.setCnpj(estabelecimento.getCnpj());
        existente.setId(estabelecimento.getId());
        existente.setNome(estabelecimento.getNome());
        existente.setNumero(estabelecimento.getNumero());
        existente.setComplemento(estabelecimento.getComplemento());
        existente.setBairro(estabelecimento.getBairro());
        existente.setLogradouro(estabelecimento.getLogradouro());
        existente.setUf(estabelecimento.getUf());
        existente.setCep(estabelecimento.getCep());
        existente.setLatitude(estabelecimento.getLatitude());
        existente.setLongitude(estabelecimento.getLongitude());
        
        
        
        return estabelecimentoRepository.save(existente);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable UUID id) {
        estabelecimentoRepository.delete(buscarOuFalhar(id));
        return ResponseEntity.noContent().build();
    }

    private Estabelecimento buscarOuFalhar(UUID id) {
        return estabelecimentoRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Estabelecimento não encontrado"));
    }
}
