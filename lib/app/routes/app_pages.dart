import 'package:st7/app/modules/agreement/view/agreement_view.dart';
import 'package:st7/app/modules/articles/bindings/article_binding.dart';
import 'package:st7/app/modules/articles/bindings/articles_bindings.dart';
import 'package:st7/app/modules/articles/views/article_view.dart';
import 'package:st7/app/modules/articles/views/articles_view.dart';
import 'package:st7/app/modules/no_connection_view.dart';
import 'package:st7/app/modules/onboarding/binding/onboarding_binding.dart';
import 'package:st7/app/modules/onboarding/view/onboarding_view.dart';
import 'package:st7/app/modules/settings_view.dart';
import 'package:st7/app/modules/splash/view/splash_view.dart';
import 'package:get/get.dart';

part 'routes.dart';

abstract class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.articles,
      page: () => ArticlesView(),
      binding: ArticlesBindings(),
      children: [
        GetPage(
          name: _Paths.article,
          binding: ArticleBinding(),
          page: () => ArticleView(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.agreement,
      page: () => PrivacyAndTermsView(),
    ),
    GetPage(
      name: _Paths.noConnection,
      page: () => const NoConnectionView(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
    )
  ];
}
