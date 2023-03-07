part of 'storage_service.dart';

abstract class StorageKeys {
  /// Is this the first launch of the app
  static const String isFirstLaunch = 'isFirstLaunch';

  /// Checks if home tutorial have been shown
  static const String homeTutorialShown = 'homeTutorialShown';

  static const String launchingCount = 'launchingCount';

  static const String admobViewedTimes = 'admobViewedTimes';

  static const String usedArticles = 'usedArticles';
  static const String enteredFirstTime = 'enteredFirstTime';
  static const String subscriptionActive = 'subscriptionActive';
}