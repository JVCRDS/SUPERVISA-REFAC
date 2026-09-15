package br.edu.fatec.visacampo.logauditoria;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.OffsetDateTime;
import java.util.UUID;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "log_auditoria")
public class LogAuditoria {

    @Id
    private UUID id;

    @NotBlank(message = "tabela é obrigatória")
    @Column(nullable = false, length = 60)
    private String tabela;

    @NotNull(message = "registro é obrigatório")
    @Column(name = "registro_id", nullable = false)
    private UUID registroId;

    @NotNull(message = "ação é obrigatória")
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private AcaoAuditoria acao;

    @Column(name = "agente_id")
    private UUID agenteId;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "dados_anteriores")
    private String dadosAnteriores;

    @Column(name = "realizado_em", nullable = false)
    private OffsetDateTime realizadoEm;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getTabela() {
        return tabela;
    }

    public void setTabela(String tabela) {
        this.tabela = tabela;
    }

    public UUID getRegistroId() {
        return registroId;
    }

    public void setRegistroId(UUID registroId) {
        this.registroId = registroId;
    }

    public AcaoAuditoria getAcao() {
        return acao;
    }

    public void setAcao(AcaoAuditoria acao) {
        this.acao = acao;
    }

    public UUID getAgenteId() {
        return agenteId;
    }

    public void setAgenteId(UUID agenteId) {
        this.agenteId = agenteId;
    }

    public String getDadosAnteriores() {
        return dadosAnteriores;
    }

    public void setDadosAnteriores(String dadosAnteriores) {
        this.dadosAnteriores = dadosAnteriores;
    }

    public OffsetDateTime getRealizadoEm() {
        return realizadoEm;
    }

    public void setRealizadoEm(OffsetDateTime realizadoEm) {
        this.realizadoEm = realizadoEm;
    }
}
