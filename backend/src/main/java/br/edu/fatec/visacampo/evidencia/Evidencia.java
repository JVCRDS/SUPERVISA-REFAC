package br.edu.fatec.visacampo.evidencia;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "evidencia")
public class Evidencia {

    @Id
    private UUID id;

    @NotNull(message = "inspeção é obrigatória")
    @Column(name = "inspecao_id", nullable = false)
    private UUID inspecaoId;

    @NotNull(message = "autor é obrigatório")
    @Column(name = "autor_id", nullable = false)
    private UUID autorId;

    @NotBlank(message = "nome do arquivo é obrigatório")
    @Column(name = "nome_arquivo", nullable = false)
    private String nomeArquivo;

    @NotBlank(message = "hash SHA-256 é obrigatório")
    @Size(min = 64, max = 64, message = "hash SHA-256 deve ter 64 caracteres")
    @Column(name = "hash_sha256", nullable = false, length = 64)
    private String hashSha256;

    @NotNull(message = "data de captura é obrigatória")
    @Column(name = "capturado_em", nullable = false)
    private OffsetDateTime capturadoEm;

    private BigDecimal latitude;

    private BigDecimal longitude;

    @Column(name = "criado_em", nullable = false)
    private OffsetDateTime criadoEm;

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

    public UUID getAutorId() {
        return autorId;
    }

    public void setAutorId(UUID autorId) {
        this.autorId = autorId;
    }

    public String getNomeArquivo() {
        return nomeArquivo;
    }

    public void setNomeArquivo(String nomeArquivo) {
        this.nomeArquivo = nomeArquivo;
    }

    public String getHashSha256() {
        return hashSha256;
    }

    public void setHashSha256(String hashSha256) {
        this.hashSha256 = hashSha256;
    }

    public OffsetDateTime getCapturadoEm() {
        return capturadoEm;
    }

    public void setCapturadoEm(OffsetDateTime capturadoEm) {
        this.capturadoEm = capturadoEm;
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

    public OffsetDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(OffsetDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }
}
