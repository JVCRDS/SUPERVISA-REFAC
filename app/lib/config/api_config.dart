/// URL base da API do backend.
///
/// Padrão aponta para 10.0.2.2, que no emulador Android é o alias para
/// `localhost` da máquina hospedeira. Para rodar num aparelho físico ou no
/// simulador iOS, sobrescreva em tempo de build:
///
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
