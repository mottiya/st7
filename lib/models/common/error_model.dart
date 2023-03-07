import 'package:flutter/material.dart';

/// Тип ошибки
enum ErrorType { snack, dialog, logOnly }

/// Приоритет ошибки
enum ErrorPriority { critical, warning, info }

/// Модель ошибки
class ErrorModel implements Exception {
  ErrorModel({
    required this.message,
    this.exception,
    this.type = ErrorType.logOnly,
    this.priority = ErrorPriority.info,
    this.callback,
  });

  /// Текст ошибки
  final String message;

  /// Объект ошибки
  final dynamic exception;

  /// Тип ошибки
  final ErrorType type;

  /// Приоритет ошибки
  final ErrorPriority priority;

  /// Коллбэк
  final VoidCallback? callback;

  @override
  String toString() {
    return message;
  }
}