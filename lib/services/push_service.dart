import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:st7/services/storage/storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Translations;

class PushService extends GetxService {
  final _storageService = Get.find<StorageService>();

  final _cloudMessaging = FirebaseMessaging.instance;
  final _notifications = AwesomeNotifications();

  @override
  void onInit() {
    _initializePermissions();
    super.onInit();
  }

  Future<void> _initializePermissions() async {
    final settings = await _cloudMessaging.requestPermission();

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        if (GetPlatform.isAndroid) await _initActionNotifications();
        log('Notifications access granted');
        log('FCM token ${await _cloudMessaging.getToken()}');

        updateTopics();

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          final notification = message.notification;

          if (notification != null && notification.title != null && notification.body != null) {
            showNotification(
              message.notification.hashCode,
              notification.title!,
              notification.body!,
              'general',
            );
          }
        });
        break;
      case AuthorizationStatus.denied:
      case AuthorizationStatus.notDetermined:
        log('Notifications access denied');
        break;
    }
  }

  Future<void> updateTopics() async {
    final Map<PushTopic, bool> topics = {};

    topics[PushTopic.noSub] = !_storageService.getBoolOrFalse(StorageKeys.subscriptionActive);
    topics[PushTopic.noArticles] = _storageService.getBoolOrFalse(StorageKeys.usedArticles);
    topics[PushTopic.enteredFirstTime] =
        _storageService.getBoolOrFalse(StorageKeys.enteredFirstTime);

    topics.forEach((key, value) {
      if (value) {
        _subscribeToTopic(key);
      } else {
        _unsubscribeFromTopic(key);
      }
    });
  }

  Future<void> _subscribeToTopic(PushTopic topic) =>
      FirebaseMessaging.instance.subscribeToTopic(topic.asString);

  Future<void> _unsubscribeFromTopic(PushTopic topic) =>
      FirebaseMessaging.instance.unsubscribeFromTopic(topic.asString);

  Future<void> _initActionNotifications() async {
    await _notifications.initialize(
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
          channelName: 'General',
          locked: true,
          playSound: false,
          enableVibration: false,
          channelKey: 'general',
          defaultColor: Get.theme.colorScheme.primary,
          importance: NotificationImportance.Max,
          channelDescription: 'General',
        )
      ],
    );
  }

  Future<void> showPersistentNotification(int id, String title, String body, String channelName,
          {List<NotificationActionButton>? actionButtons,
          Map<String, String>? payload,
          bool needShowButtons = true}) =>
      _notifications.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'general',
          title: title,
          body: body,
          autoDismissible: false,
          showWhen: false,
          payload: payload,
        ),
        actionButtons: needShowButtons ? actionButtons : null,
      );

  Future<void> showNotification(int id, String title, String body, String channelName,
      [String? payload]) async {
    _notifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'general',
        title: title,
        body: body,
        autoDismissible: false,
        showWhen: false,
      ),
    );
  }

  Future<void> cancelNotification(int id) => _notifications.cancel(id);

  Future<void> cancelAllNotifications() => _notifications.cancelAll();
}

enum PushTopic {
  noSub,
  noArticles,
  enteredFirstTime,
}

extension PushTopicExtension on PushTopic {
  String get asString => describeEnum(this);
}
