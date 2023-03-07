import 'dart:developer';

import 'package:st7/models/articles/article_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreService extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _articles = <ArticleModel>[];

  List<ArticleModel> get articles => _articles;

  Future<void> getArticles() async {
    try {
      final articles = (await _firestore.collection('articles').get()).docs.first.data();

      articles.forEach((key, value) {
        _articles.add(ArticleModel.fromJson(json: value, title: key));
      });

      final reg = RegExp(r"\d+");
      _articles.sort((art1, art2) {
        final first = reg.stringMatch(art1.title);
        final second = reg.stringMatch(art2.title);

        if (first == null || second == null || (first == '1' && second == '1')) {
          return 0;
        }

        return int.parse(first.toString()).compareTo(int.parse(second.toString()));
      });
    } catch (error) {
      log('Firestore Exception: $error');
    }
  }
}
