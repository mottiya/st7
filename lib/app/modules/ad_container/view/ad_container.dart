import 'package:st7/app/modules/ad_container/controllers/ad_container_controller.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdContainer extends StatelessWidget {
  AdContainer({Key? key, required this.child}) : super(key: key) {
    _controller.clearSubscriptions();
    _adEventHandlers.addAll({
      NavigateEvent: (e) => _navigate(e as NavigateEvent),
    });
    _controller.createEventSubscription((e) => _adEventHandlers[e.runtimeType]?.call(e));
  }

  final _controller = Get.find<AdContainerController>();

  final Widget child;

  final _adEventHandlers = <Type, Function(Event)>{};

  void _navigate(NavigateEvent event) async {
    Get.toNamed(event.route, arguments: event.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.theme.backgroundColor,
      child: child,
    );
  }
}
