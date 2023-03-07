import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';

mixin EventMixin {
  RxNotifier get eventNotifier => _eventNotifier;
  final _eventNotifier = RxNotifier<Event>();

  final _subscriptions = <StreamSubscription<Event>>[];

  Event? lastEvent;

  void sendEvent(Event event) {
    if (_eventNotifier.subject.isClosed) return;

    lastEvent = event;
    _eventNotifier.subject.add(event);
  }

  StreamSubscription<Event> createEventSubscription(
      void Function(Event) onData) {
    final sub = _eventNotifier.listen(onData);
    _subscriptions.add(sub);
    return sub;
  }

  void clearSubscriptions() => _subscriptions
    ..forEach((s) => s.cancel())
    ..clear();

  void cancelEvents() {
    if (!_eventNotifier.subject.isClosed) {
      _eventNotifier.close();
    }
  }
}

abstract class Event {}

class NavigateEvent extends Event {
  final dynamic arguments;
  final String route;
  final int? index;

  NavigateEvent(
    this.route, {
    this.arguments,
    this.index,
  });
}

class ChangeRouteEvent extends Event {
  final String? newRoute;

  ChangeRouteEvent({required this.newRoute});
}

class DialogEvent extends Event {
  final dynamic arguments;
  final String? id;
  final String? title;
  final String? description;
  final Map<String, VoidCallback>? buttons;
  final bool? barrierDismissible;

  DialogEvent({
    this.arguments,
    this.title,
    this.description,
    this.buttons,
    this.id,
    this.barrierDismissible,
  });
}
