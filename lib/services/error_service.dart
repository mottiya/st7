import 'dart:async';

import 'package:st7/helpers/error_reporter_helper.dart';
import 'package:st7/models/common/error_model.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ErrorService extends GetxService {
  final _errorsController = PublishSubject<ErrorModel>();
  late StreamSubscription<ErrorModel> _errorsSubscription;

  void addError(ErrorModel error) => _errorsController.add(error);

  Stream<ErrorModel> get events => _errorsController.stream;

  @override
  void onInit() {
    _errorsSubscription = events.listen((event) {
      switch (event.priority) {
        case ErrorPriority.critical:
          ErrorReporterHelper.reportCritical(event);
          break;
        case ErrorPriority.warning:
          ErrorReporterHelper.reportWarning(event);
          break;
        case ErrorPriority.info:
          ErrorReporterHelper.reportInfo(event);
          break;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    _errorsSubscription.cancel();
    super.onClose();
  }
}
