import 'package:st7/helpers/enums.dart';
import 'package:flutter/foundation.dart';

class AnalyticsEventModel {
  final String name;
  final Map<String, Object?>? parameters;
  final Map<String, Object?> defaultParameters = {
    // 'traffic_type': describeEnum(Settings.installData?.buildType ?? BuildType.release),
  };

  Map<String, Object?> get allParameters =>
      defaultParameters..addAll(parameters ?? {});

  AnalyticsEventModel(this.name, {this.parameters});
}

class AnalyticsAdEventModel extends AnalyticsEventModel {
  AnalyticsAdEventModel(
    AdEvent adEvent, {
    AdType adType = AdType.rewarded,
    InterType? moduleType,
    String? bannerId,
  }) : super('Ad', parameters: {
          if (moduleType != null) 'Module': describeEnum(moduleType),
          if (bannerId != null) 'Banner': bannerId,
          'AdEvent': describeEnum(adEvent),
          'AdType': describeEnum(adType),
        });
}

class AnalyticsNavigationEventModel extends AnalyticsEventModel {
  AnalyticsNavigationEventModel(InterType moduleType,
      {EventType eventType = EventType.open})
      : super('Navigate', parameters: {
          'Module': describeEnum(moduleType),
          'EventType': describeEnum(eventType),
        });
}

class AnalyticsSubscriptionEventModel extends AnalyticsEventModel {
  AnalyticsSubscriptionEventModel(SubEvent subEvent)
      : super('Subscription', parameters: {
          'SubEvent': describeEnum(subEvent),
        });
}
