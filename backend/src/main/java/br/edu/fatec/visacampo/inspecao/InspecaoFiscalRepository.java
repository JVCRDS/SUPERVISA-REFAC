package br.edu.fatec.visacampo.inspecao;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InspecaoFiscalRepository extends JpaRepository<InspecaoFiscal, UUID> {
}
