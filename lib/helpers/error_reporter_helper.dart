import 'package:st7/app/components/ui/dialogs/themed_alert_dialog.dart';
import 'package:st7/models/common/error_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'dialog_helper.dart';

class ErrorReporterHelper {
  static final _logger = Logger();

  /// Report and show critical error
  static void reportCritical(ErrorModel error) {
    _logger.e(error.message, error.exception);

    showError(message: error.message, callback: error.callback, type: error.type);
  }

  /// Report and show warning
  static void reportWarning(ErrorModel error) {
    _logger.w(error.message, error.exception);

    showError(message: error.message, callback: error.callback, type: error.type);
  }

  /// Report and show minor error
  static void reportInfo(ErrorModel error) {
    _logger.i(error.message, error.exception);

    showError(message: error.message, callback: error.callback, type: error.type);
  }

  /// Shows error depending on error type
  static void showError({
    required String message,
    VoidCallback? callback,
    required ErrorType type,
    String title = 'Error',
  }) {
    switch (type) {
      case ErrorType.snack:
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        break;
      case ErrorType.dialog:
        DialogHelper.showCustom(
          ThemedAlertDialog(
            title: 'Error',
            description: message,
            buttons: {'Ok': callback},
          ),
        );
        break;
      default:
        break;
    }
  }
}
