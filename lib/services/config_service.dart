import 'dart:async';
import 'dart:developer';

import 'package:st7/services/configuration/configuration_constants.dart';
import 'package:st7/services/configuration/configuration_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConfigService extends GetxService {
  /// To get value you need to know its type
  /// Get value as bool type: config['key'].asBool()
  final _config = <String, RemoteConfigValue>{};
  final _remoteConfig = FirebaseRemoteConfig.instance;
  final _configurationService = Get.find<ConfigurationService>();
  final _ads = <int, String>{};

  final _remoteConfigSettings = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    // How often to fetch new values from the server
    minimumFetchInterval: const Duration(minutes: 0),
  );

  String getAdId(int? number) {
    if (_configurationService.data.debugMode) {
      return _configurationService.data.articleAdId;
    }
    if (_ads.containsKey(number)) {
      final ad = _ads[number] ?? '';
      return ad;
    } else {
      return '';
    }
  }

  String get appOpen {
    try {
      if (kDebugMode) {
        return ConfigurationConstants.testAppOpenAdId;
      }
      final appOpen = _remoteConfig.getString('appOpen');
      return appOpen;
    } catch (_) {
      return ConfigurationConstants.testAppOpenAdId;
    }
  }

  String get article {
    try {
      if (kDebugMode) {
        return ConfigurationConstants.testNativeAdId;
      }
      final articleAd = _remoteConfig.getString('articleNative');
      return articleAd;
    } catch (_) {
      return ConfigurationConstants.testNativeAdId;
    }
  }

  String get rewardVideo {
    try {
      if (kDebugMode) {
        return ConfigurationConstants.testRewardedAdId;
      }
      final rewardId = _remoteConfig.getString('rewardVideo');
      return rewardId;
    } catch (_) {
      return ConfigurationConstants.testRewardedAdId;
    }
  }

  Future<void> init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(_remoteConfigSettings);

    try {
      await remoteConfig.fetchAndActivate();
      _config.assignAll(remoteConfig.getAll());
      log('Config received');
    } catch (_) {
      log('Cannot fetch remote config');
      await Future.delayed(const Duration(seconds: 3));

      return;
    }

    try {
      _fetchAds();

      log('All events sent');
    } catch (e) {
      log('Error when parsing remote config $e');
    }
  }

  void _fetchAds() {
    final featuresConfig = {
      for (final adId in _config.entries.where((adId) {
        return adId.key.startsWith('feedNative_');
      }))
        // key
        int.tryParse(adId.key.replaceFirst('feedNative_', '')) ?? 0:
            // value
            adId.value.asString()
    };

    _ads.assignAll(featuresConfig);
  }
}
