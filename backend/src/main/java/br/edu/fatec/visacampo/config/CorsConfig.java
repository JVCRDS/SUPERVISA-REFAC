package br.edu.fatec.visacampo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Libera CORS para a API. Necessário só por causa do app Flutter Web — nos
 * clientes Android/iOS/curl isso nunca foi um problema, CORS é regra
 * aplicada pelo navegador, não pelo servidor nem por outros clientes HTTP.
 *
 * Origem liberada geral porque a autenticação usa um token no header
 * Authorization, não cookie — não há sessão de navegador pra proteger
 * com uma origem restrita.
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
    }
}
