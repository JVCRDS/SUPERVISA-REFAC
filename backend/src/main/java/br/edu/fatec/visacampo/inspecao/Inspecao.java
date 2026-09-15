package br.edu.fatec.visacampo.inspecao;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "inspecao")
public class Inspecao {

    @Id
    private UUID id;

    @NotNull(message = "ocorrência é obrigatória")
    @Column(name = "ocorrencia_id", nullable = false)
    private UUID ocorrenciaId;

    @Column(name = "data_hora", nullable = false)
    private OffsetDateTime dataHora;

    private BigDecimal latitude;

    private BigDecimal longitude;

    @NotNull(message = "situação é obrigatória")
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private SituacaoInspecao situacao = SituacaoInspecao.EM_ANDAMENTO;

    @Column(name = "observacoes_gerais")
    private String observacoesGerais;

    @Column(name = "criado_em", nullable = false)
    private OffsetDateTime criadoEm;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getOcorrenciaId() {
        return ocorrenciaId;
    }

    public void setOcorrenciaId(UUID ocorrenciaId) {
        this.ocorrenciaId = ocorrenciaId;
    }

    public OffsetDateTime getDataHora() {
        return dataHora;
    }

    public void setDataHora(OffsetDateTime dataHora) {
        this.dataHora = dataHora;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public SituacaoInspecao getSituacao() {
        return situacao;
    }

    public void setSituacao(SituacaoInspecao situacao) {
        this.situacao = situacao;
    }

    public String getObservacoesGerais() {
        return observacoesGerais;
    }

    public void setObservacoesGerais(String observacoesGerais) {
        this.observacoesGerais = observacoesGerais;
    }

    public OffsetDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(OffsetDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }
}
