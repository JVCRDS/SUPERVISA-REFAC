import 'package:flutter/foundation.dart' show kIsWeb;

/// URL base da API do backend.
///
/// O padrão muda conforme a plataforma, porque "localhost" significa algo
/// diferente em cada uma:
/// - Web: o navegador roda na própria máquina que tem a API, então
///   `localhost` já funciona.
/// - Android (emulador): `localhost` apontaria para o próprio emulador, não
///   para a máquina hospedeira — por isso o alias `10.0.2.2`.
///
/// Para aparelho físico ou simulador iOS, sobrescreva em tempo de build:
///
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080
class ApiConfig {
  static const String _padrao = kIsWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _padrao,
  );
}
