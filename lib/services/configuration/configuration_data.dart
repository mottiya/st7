import 'package:st7/services/configuration/configuration_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Модель конфигурации
class ConfigurationData {
  final String appOpenStartAdId;
  final String appmetricaKey;
  final String rewardedAdId;
  final String articleAdId;
  final String listAdId;
  final String listAdSecondId;

  final bool debugMode;

  const ConfigurationData({
    required this.appmetricaKey,
    required this.debugMode,
    required this.simulator,
    required this.rewardedAdId,
    required this.articleAdId,
    required this.appOpenStartAdId,
    required this.listAdId,
    required this.listAdSecondId,
  });

  /// Attention! Only android check
  final bool simulator;

  static Future<ConfigurationData> load() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final isSimulator = !(deviceInfo.isPhysicalDevice);

    if (kDebugMode) {
      return ConfigurationData(
        appmetricaKey: ConfigurationConstants.appmetricaApiKey,
        debugMode: true,
        simulator: isSimulator,
        appOpenStartAdId: ConfigurationConstants.testAppOpenAdId,
        rewardedAdId: ConfigurationConstants.testRewardedAdId,
        articleAdId: ConfigurationConstants.testNativeAdId,
        listAdId: ConfigurationConstants.testNativeAdId,
        listAdSecondId: ConfigurationConstants.testNativeAdId,
        
      );
    } else {
      return const ConfigurationData(
        appmetricaKey: ConfigurationConstants.appmetricaApiKey,
        debugMode: false,
        simulator: false,
        appOpenStartAdId: ConfigurationConstants.appOpenAdId,
        rewardedAdId: ConfigurationConstants.rewardVideoAdId,
        articleAdId: ConfigurationConstants.articleNativeAdId,
        listAdId: ConfigurationConstants.listNativeId,
        listAdSecondId: ConfigurationConstants.listNativeSecondId,
        
      );
    }
  }
}
