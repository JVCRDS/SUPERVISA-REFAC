package br.edu.fatec.visacampo.auth;

import br.edu.fatec.visacampo.agente.Agente;
import br.edu.fatec.visacampo.agente.AgenteRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.Set;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Exige um token de sessão válido (header `Authorization: Bearer <token>`)
 * em toda rota /api/**, com excecão do login. Quando válido, guarda o
 * agente autenticado como atributo da requisição
 * ("agenteAutenticado") — é assim que, por exemplo, o AgenteController
 * sabe quem está chamando a rota de criação pra decidir se é
 * administrador.
 *
 * Rotas fora de /api/** (Swagger, actuator) não passam por aqui.
 */
@Component
public class AutenticacaoFiltro extends OncePerRequestFilter {

    public static final String ATRIBUTO_AGENTE_AUTENTICADO = "agenteAutenticado";

    private static final Set<String> ROTAS_PUBLICAS = Set.of("/api/auth/login");

    private final SessaoRepository sessaoRepository;
    private final AgenteRepository agenteRepository;

    public AutenticacaoFiltro(SessaoRepository sessaoRepository, AgenteRepository agenteRepository) {
        this.sessaoRepository = sessaoRepository;
        this.agenteRepository = agenteRepository;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return !path.startsWith("/api/")
                || ROTAS_PUBLICAS.contains(path)
                || "OPTIONS".equalsIgnoreCase(request.getMethod());
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            responderNaoAutorizado(response, "Autenticação necessária");
            return;
        }

        String token = authorization.substring("Bearer ".length());
        Sessao sessao = sessaoRepository.findByToken(token).orElse(null);
        if (sessao == null || sessao.getExpiraEm().isBefore(OffsetDateTime.now())) {
            responderNaoAutorizado(response, "Sessão inválida ou expirada");
            return;
        }

        Agente agente = agenteRepository.findById(sessao.getAgenteId()).orElse(null);
        if (agente == null || !agente.isAtivo()) {
            responderNaoAutorizado(response, "Sessão inválida ou expirada");
            return;
        }

        request.setAttribute(ATRIBUTO_AGENTE_AUTENTICADO, agente);
        filterChain.doFilter(request, response);
    }

    private void responderNaoAutorizado(HttpServletResponse response, String mensagem) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"erro\":\"" + mensagem + "\"}");
    }
}
