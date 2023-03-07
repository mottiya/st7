import 'package:st7/mixins/admob_mixin.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/services/navigation_interceptor_service.dart';
import 'package:get/get.dart';

class AdContainerController extends GetxController with AdmobMixin, EventMixin {
  final _navigationService = Get.find<NavigationInterceptorService>();

  final _eventHandlers = <Type, Function(Event)>{};

  final currentRoute = '/'.obs;

  @override
  void onInit() {
    _eventHandlers.addAll({
      NavigateEvent: (e) => sendEvent(e),
      ChangeRouteEvent: (e) => _changeRoute(e as ChangeRouteEvent),
    });
    _navigationService.createEventSubscription((e) => _eventHandlers[e.runtimeType]?.call(e));
    super.onInit();
  }

  void _changeRoute(ChangeRouteEvent e) {
    final route = e.newRoute;
    if (route != null) {
      currentRoute.value = route;
    }
  }
}
