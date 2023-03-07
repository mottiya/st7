import 'package:st7/services/configuration/configuration_data.dart';
import 'package:get/get.dart';

/// Сервис конфигурации
class ConfigurationService extends GetxService {
  late ConfigurationData _configuration;

  ConfigurationData get data => _configuration;

  /// Загружает конфигурацию для окружения
  Future<void> load() async {
    _configuration = await ConfigurationData.load();
  }
}

enum Configuration {
  dev,
  prod,
}
