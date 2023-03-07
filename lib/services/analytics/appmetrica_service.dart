import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/models/common/error_model.dart';
import 'package:st7/models/common/profile_model.dart';
import 'package:st7/services/analytics/ianalytics.dart';
import 'package:st7/services/configuration/configuration_service.dart';
import 'package:st7/services/error_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppmetricaService extends IAnalytics {
  final _configurationService = Get.find<ConfigurationService>();
  final _errorService = Get.find<ErrorService>();

  final _appmetrica = AppmetricaSdk();

  @override
  void onInit() async {
    await _appmetrica.activate(apiKey: _configurationService.data.appmetricaKey);
    String? libraryVersion;
    try {
      libraryVersion = await _appmetrica.getLibraryVersion();
    } on PlatformException {
      libraryVersion = 'Failed to get library version.';
    }
    _errorService.addError(ErrorModel(message: 'AM version $libraryVersion'));
    super.onInit();
  }

  @override
  Future<void> setCurrentScreen(String? screenName) async {}

  @override
  Future<void> reportEvent(AnalyticsEventModel event) =>
      _appmetrica.reportEvent(name: event.name, attributes: event.allParameters);

  @override
  Future<void> profileEvent(ProfileModel profile) =>
      _appmetrica.setUserProfileID(userProfileID: profile.profileId);
}
