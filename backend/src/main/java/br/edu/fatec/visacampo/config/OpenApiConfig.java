package br.edu.fatec.visacampo.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI visaCampoOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("visa-campo API")
                        .description("API do protótipo de TCC para registro e organização de "
                                + "evidências de inspeções da vigilância sanitária de Ribeirão Preto.")
                        .version("v0.1.0"));
    }
}
