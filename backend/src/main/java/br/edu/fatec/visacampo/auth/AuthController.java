package br.edu.fatec.visacampo.auth;

import br.edu.fatec.visacampo.agente.Agente;
import br.edu.fatec.visacampo.agente.AgenteRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Login por CPF e senha. Só confirma a identidade do agente — ainda não
 * emite token/sessão nem protege nenhuma outra rota, porque a camada de
 * autenticação (proteção de rotas, incluindo a de criação de agente por
 * administrador) fica para uma próxima etapa.
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AgenteRepository agenteRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthController(AgenteRepository agenteRepository, PasswordEncoder passwordEncoder) {
        this.agenteRepository = agenteRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/login")
    public Agente login(@Valid @RequestBody LoginRequest login) {
        Agente agente = agenteRepository.findByCpf(login.getCpf())
                .filter(Agente::isAtivo)
                .filter(a -> passwordEncoder.matches(login.getSenha(), a.getSenha()))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "CPF ou senha inválidos"));
        return agente;
    }
}
