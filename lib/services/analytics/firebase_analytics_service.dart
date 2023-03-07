import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/models/common/profile_model.dart';
import 'package:st7/services/analytics/ianalytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService extends IAnalytics {
  final _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Future<void> setCurrentScreen(String? screenName) =>
      _firebaseAnalytics.setCurrentScreen(screenName: screenName);

  @override
  Future<void> reportEvent(AnalyticsEventModel event) =>
      _firebaseAnalytics.logEvent(name: event.name, parameters: event.allParameters);

  @override
  Future<void> profileEvent(ProfileModel profile) =>
      _firebaseAnalytics.setUserId(id: profile.profileId);
}
