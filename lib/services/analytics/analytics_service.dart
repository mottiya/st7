import 'dart:developer';

import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/models/common/profile_model.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService with EventMixin {
  var _time = DateTime.now();

  void setCurrentScreen(String? screenName) {
    if (screenName == null) return;

    log('║ Set current screen: $screenName');
    sendEvent(SetCurrentScreenEvent(screenName));
  }

  void reportEvent(AnalyticsEventModel event) {
    if (DateTime.now().difference(_time).inMilliseconds < 500) return;
    _time = DateTime.now();

    final params = event.parameters;
    log('║ Report event: ${event.name} with params: ${params?.length}');
    if (params != null) {
      params.forEach((key, value) {
        log('║ key: $key value: $value');
      });
    }

    sendEvent(ReportEvent(event));
  }

  void setProfile(ProfileModel profile) {
    sendEvent(ProfileEvent(profile));
  }
}

class SetCurrentScreenEvent extends Event {
  final String? screenName;

  SetCurrentScreenEvent(this.screenName);
}

class ReportEvent extends Event {
  final AnalyticsEventModel event;

  ReportEvent(this.event);
}

class ProfileEvent extends Event {
  final ProfileModel profile;

  ProfileEvent(this.profile);
}

class AnalyticsEvents {
  static const rateApp = 'rate_app';
  static const noTopic = 'no_topic';
}
