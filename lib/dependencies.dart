import 'package:st7/app/modules/ad_container/controllers/ad_container_controller.dart';
import 'package:st7/services/admob_service.dart';
import 'package:st7/services/analytics/analytics_service.dart';
import 'package:st7/services/analytics/appmetrica_service.dart';
import 'package:st7/services/analytics/firebase_analytics_service.dart';
import 'package:st7/services/cloud_storage_service.dart';
import 'package:st7/services/config_service.dart';
import 'package:st7/services/configuration/configuration_service.dart';
import 'package:st7/services/error_service.dart';
import 'package:st7/services/firestore_service.dart';
import 'package:st7/services/navigation_interceptor_service.dart';
import 'package:st7/services/network_service.dart';
import 'package:st7/services/push_service.dart';
import 'package:st7/services/storage/storage_service.dart';
import 'package:get/get.dart';

class Dependencies {
  /// Inject dependencies before run app
  static Future<void> inject(ConfigurationService configuration) async {
    Get.put<ConfigurationService>(configuration);
    final storage = StorageService();
    await storage.init();
    Get.put<StorageService>(storage);

    await Get.putAsync(() async {
      final config = ConfigService();
      await config.init();
      return config;
    });

    Get.put(ErrorService());
    Get.put(AnalyticsService());
    Get.put(AppmetricaService());
    Get.put(FirebaseAnalyticsService());
    Get.put(PushService());
    Get.put(NetworkService());
    Get.put(NavigationInterceptorService());
    Get.put(AdmobService());
    Get.put(AdContainerController());
  }

  static Future<bool> loadOnSplash() async {
    Get.lazyPut(() => FirestoreService());
    Get.lazyPut(() => CloudStorageService());
    return true;
  }
}
