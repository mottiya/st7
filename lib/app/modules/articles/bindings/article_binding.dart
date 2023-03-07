import 'package:st7/app/modules/articles/controller/article_controller.dart';
import 'package:get/instance_manager.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ArticleController());
  }
}
