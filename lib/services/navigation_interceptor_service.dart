import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/services/network_service.dart';
import 'package:get/get.dart';

class NavigationInterceptorService extends GetxService with EventMixin {
  final _networkService = Get.find<NetworkService>();

  /// Перейти на страницу по адресу
  Future<void> goWithAdAndAnal(String page, {dynamic arguments, int? index}) async {
    if (await _networkService.checkConnection()) {
      sendEvent(
        NavigateEvent(
          page,
          arguments: arguments,
        ),
      );
    } else {
      sendEvent(NavigateEvent(Routes.noConnection));
    }
  }
}

enum Origin { funnel, general }
