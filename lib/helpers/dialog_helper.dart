import 'dart:io';

import 'package:st7/app/components/ui/dialogs/themed_alert_dialog.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

class DialogHelper {
  static Future<dynamic> show(
    DialogEvent event, {
    bool barrierDismissible = true,
  }) async {
    return await Get.dialog(
      ThemedAlertDialog(
        title: event.title,
        description: event.description,
        buttons: event.buttons,
      ),
      barrierDismissible: event.barrierDismissible ?? true,
    );
  }

  /// Show custom widget dialog
  static Future<dynamic> showCustom(
    Widget widget, {
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async {
    return await Get.dialog(
      widget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<dynamic> showReviewDialog() async {
    final text = Platform.isIOS
        ? 'GO TO THE APPSTORE'
        : Platform.isAndroid
            ? 'GO TO THE PLAY MARKET'
            : 'GO TO THE STORE';
    return await Get.dialog(
      ThemedAlertDialog(
        description: 'Good reviews motivate us to work harder\non the app. Please leave a review!',
        buttons: {
          text: () {
            final inAppReview = InAppReview.instance;
            inAppReview.openStoreListing();
            Get.back();
          }
        },
      ),
      barrierDismissible: false,
    );
  }
}
