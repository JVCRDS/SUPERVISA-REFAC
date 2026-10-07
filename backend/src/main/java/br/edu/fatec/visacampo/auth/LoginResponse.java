package br.edu.fatec.visacampo.auth;

import br.edu.fatec.visacampo.agente.Agente;
import java.time.OffsetDateTime;

/**
 * Corpo de resposta do login: o agente autenticado e o token de sessão que
 * ele deve enviar em `Authorization: Bearer <token>` nas próximas
 * chamadas. Não é uma entidade — só existe pra compor esses dois valores
 * numa resposta só.
 */
public class LoginResponse {

    private final Agente agente;
    private final String token;
    private final OffsetDateTime expiraEm;

    public LoginResponse(Agente agente, String token, OffsetDateTime expiraEm) {
        this.agente = agente;
        this.token = token;
        this.expiraEm = expiraEm;
    }

    public Agente getAgente() {
        return agente;
    }

    public String getToken() {
        return token;
    }

    public OffsetDateTime getExpiraEm() {
        return expiraEm;
    }
}
