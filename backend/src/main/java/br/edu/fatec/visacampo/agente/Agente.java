package br.edu.fatec.visacampo.agente;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "agente")
public class Agente {

    @Id
    private UUID id;

    @NotBlank(message = "nome é obrigatório")
    @Column(nullable = false, length = 150)
    private String nome;

    @NotBlank(message = "email é obrigatório")
    @Email
    @Column(nullable = false, unique = true, length = 180)
    private String email;

    // write-only: nunca volta no JSON de resposta, só é aceita na entrada.
    @NotBlank(message = "senha é obrigatória")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    @Column(name = "senha_hash", nullable = false)
    private String senhaHash;

    @NotNull(message = "perfil é obrigatório")
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Perfil perfil;

    @NotNull(message = "área é obrigatória")
    @Column(name = "area_id", nullable = false)
    private UUID areaId;

    @Column(nullable = false)
    private boolean ativo = true;

    @Column(name = "criado_em", nullable = false)
    private OffsetDateTime criadoEm;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenhaHash() {
        return senhaHash;
    }

    public void setSenhaHash(String senhaHash) {
        this.senhaHash = senhaHash;
    }

    public Perfil getPerfil() {
        return perfil;
    }

    public void setPerfil(Perfil perfil) {
        this.perfil = perfil;
    }

    public UUID getAreaId() {
        return areaId;
    }

    public void setAreaId(UUID areaId) {
        this.areaId = areaId;
    }

    public boolean isAtivo() {
        return ativo;
    }

    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    public OffsetDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(OffsetDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }
}
