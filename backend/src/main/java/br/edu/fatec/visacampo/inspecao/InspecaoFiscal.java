package br.edu.fatec.visacampo.inspecao;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

/**
 * Tabela associativa: um fiscal presente em uma inspeção. "assinante" marca
 * qual dos fiscais presentes assina o auto de infração — no máximo um por
 * inspeção (garantido por índice único parcial na migration).
 */
@Entity
@Table(name = "inspecao_fiscal")
public class InspecaoFiscal {

    @Id
    private UUID id;

    @NotNull(message = "inspeção é obrigatória")
    @Column(name = "inspecao_id", nullable = false)
    private UUID inspecaoId;

    @NotNull(message = "agente é obrigatório")
    @Column(name = "agente_id", nullable = false)
    private UUID agenteId;

    @Column(nullable = false)
    private boolean assinante = false;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getInspecaoId() {
        return inspecaoId;
    }

    public void setInspecaoId(UUID inspecaoId) {
        this.inspecaoId = inspecaoId;
    }

    public UUID getAgenteId() {
        return agenteId;
    }

    public void setAgenteId(UUID agenteId) {
        this.agenteId = agenteId;
    }

    public boolean isAssinante() {
        return assinante;
    }

    public void setAssinante(boolean assinante) {
        this.assinante = assinante;
    }
}
