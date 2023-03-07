import 'package:bmprogresshud/progresshud.dart';
import 'package:st7/app/modules/ad_container/view/ad_container.dart';
import 'package:st7/app/modules/splash/view/splash_view.dart';
import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/dependencies.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/services/analytics/analytics_service.dart';
import 'package:st7/services/configuration/configuration_service.dart';
import 'package:st7/services/navigation_interceptor_service.dart';
import 'package:st7/themes/default_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();

  final config = ConfigurationService();
  await config.load();
  await Dependencies.inject(config);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      isGlobalHud: true,
      child: GetMaterialApp(
        title: 'Mine guide craft',
        enableLog: true,
        theme: DefaultThemeGetter.get(),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        getPages: AppPages.routes,
        initialRoute: AppPages.initial,
        navigatorObservers: [CustomNavigatorObserver()],
        builder: (context, widget) {
          if (widget == null) {
            return SplashView();
          }
          return AdContainer(child: widget);
        },
      ),
    );
  }
}

class CustomNavigatorObserver extends NavigatorObserver {
  final _navigationService = Get.find<NavigationInterceptorService>();

  final _analService = Get.find<AnalyticsService>();

  @override
  void didPop(Route route, Route? previousRoute) {
    final newRoute = previousRoute?.settings.name;
    _analService.setCurrentScreen(newRoute);
    _navigationService.sendEvent(ChangeRouteEvent(newRoute: newRoute));
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final newRoute = route.settings.name;
    _analService.setCurrentScreen(newRoute);
    _navigationService.sendEvent(ChangeRouteEvent(newRoute: newRoute));
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final newRouteName = newRoute?.settings.name;
    _analService.setCurrentScreen(newRouteName);
    _navigationService.sendEvent(ChangeRouteEvent(newRoute: newRouteName));
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
