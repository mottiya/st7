import 'package:get/get.dart';

import '../../../../models/articles/article_model.dart';
import '../../../../services/firestore_service.dart';

class ArticlesController extends GetxController {
  @override
  void onInit() {
    _initArticles();
    super.onInit();
  }

  final FirestoreService _firestoreService = Get.find();

  final articles = <ArticleModel>[];

  final isLoading = true.obs;

  Future<void> _initArticles() async {
    await _firestoreService.getArticles();
    isLoading.value = false;

    articles.addAll(_firestoreService.articles);
  }
}
