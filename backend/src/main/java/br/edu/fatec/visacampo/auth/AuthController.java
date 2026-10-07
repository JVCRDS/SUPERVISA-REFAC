package br.edu.fatec.visacampo.auth;

import br.edu.fatec.visacampo.agente.Agente;
import br.edu.fatec.visacampo.agente.AgenteRepository;
import jakarta.validation.Valid;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.Base64;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Login por CPF e senha. Em caso de sucesso, abre uma sessão (tabela
 * `sessao`) e devolve um token — a partir daqui, toda rota /api/** exige
 * esse token no header `Authorization: Bearer <token>`
 * ({@link AutenticacaoFiltro} cobre a exceção de /api/auth/login).
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private static final Duration DURACAO_SESSAO = Duration.ofHours(12);

    private final AgenteRepository agenteRepository;
    private final SessaoRepository sessaoRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthController(
            AgenteRepository agenteRepository, SessaoRepository sessaoRepository, PasswordEncoder passwordEncoder) {
        this.agenteRepository = agenteRepository;
        this.sessaoRepository = sessaoRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest login) {
        Agente agente = agenteRepository.findByCpf(login.getCpf())
                .filter(Agente::isAtivo)
                .filter(a -> passwordEncoder.matches(login.getSenha(), a.getSenha()))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "CPF ou senha inválidos"));

        OffsetDateTime agora = OffsetDateTime.now();
        Sessao sessao = new Sessao();
        sessao.setId(UUID.randomUUID());
        sessao.setAgenteId(agente.getId());
        sessao.setToken(gerarToken());
        sessao.setCriadoEm(agora);
        sessao.setExpiraEm(agora.plus(DURACAO_SESSAO));
        sessaoRepository.save(sessao);

        return new LoginResponse(agente, sessao.getToken(), sessao.getExpiraEm());
    }

    @PostMapping("/logout")
    @Transactional
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String authorization) {
        sessaoRepository.deleteByToken(extrairToken(authorization));
        return ResponseEntity.noContent().build();
    }

    private String gerarToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private String extrairToken(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cabeçalho Authorization inválido");
        }
        return authorization.substring("Bearer ".length());
    }
}
