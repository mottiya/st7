part of "app_pages.dart";

abstract class Routes {
  Routes._();
  // Splash module - app initialization there
  static const splash = _Paths.splash;

  static const onboarding = _Paths.onboarding;

  // Home screen
  static const home = _Paths.home;

  // Articles module
  static const articles = _Paths.articles;
   static const article = '$articles${_Paths.article}';
  static const topicUnavailable = '$articles${_Paths.topicUnavailable}';

  static const settings = _Paths.settings;

  // Agreements
  static final privacy = _agreement('privacy');
  static final terms = _agreement('terms');

  static String _agreement(String agreementType) => '/agreement_$agreementType';

  static const noConnection = _Paths.noConnection;
}

abstract class _Paths {
  static const splash = '/';

  static const onboarding = '/onboarding';

  static const home = '/home';

  static const articles = '/articles';
  static const article = '/article';
  static const topicUnavailable = '/topic-unavailable';

  static const agreement = '/agreement_:agreementType';
  static const settings = '/settings';

  static const noConnection = '/no-connection';
}
