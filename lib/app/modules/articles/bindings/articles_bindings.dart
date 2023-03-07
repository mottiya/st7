import 'package:st7/app/modules/articles/controller/articles_controller.dart';
import 'package:get/instance_manager.dart';

class ArticlesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticlesController());
  }
}
