package br.edu.fatec.visacampo.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    private static final String ESQUEMA_BEARER = "bearerAuth";

    @Bean
    public OpenAPI visaCampoOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("visa-campo API")
                        .description("API do protótipo de TCC para registro e organização de "
                                + "evidências de inspeções da vigilância sanitária de Ribeirão Preto. "
                                + "Faça POST /api/auth/login, copie o token da resposta e cole no botão "
                                + "Authorize (sem o prefixo \"Bearer \") pra testar as demais rotas.")
                        .version("v0.1.0"))
                .addSecurityItem(new SecurityRequirement().addList(ESQUEMA_BEARER))
                .components(new Components()
                        .addSecuritySchemes(
                                ESQUEMA_BEARER,
                                new SecurityScheme()
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("token")));
    }
}
