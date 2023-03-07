import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/models/common/profile_model.dart';
import 'package:st7/services/analytics/analytics_service.dart';
import 'package:get/get.dart';

abstract class IAnalytics extends GetxService {
  final _analyticsService = Get.find<AnalyticsService>();

  final eventHandlers = <Type, Function(Event)>{};

  @override
  void onInit() async {
    eventHandlers.addAll({
      SetCurrentScreenEvent: (e) => setCurrentScreen((e as SetCurrentScreenEvent).screenName),
      ReportEvent: (e) => reportEvent((e as ReportEvent).event),
      ProfileEvent: (e) => profileEvent((e as ProfileEvent).profile),
    });

    _analyticsService.createEventSubscription((e) => eventHandlers[e.runtimeType]?.call(e));
    super.onInit();
  }

  Future<void> setCurrentScreen(String? screenName);

  Future<void> reportEvent(AnalyticsEventModel event);

  Future<void> profileEvent(ProfileModel profile);
}
