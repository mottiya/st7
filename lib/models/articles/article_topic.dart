import 'article_model.dart';

class ArticleTopic {
  late final String title;
  late final String? cover;
  late final bool isAvailable;
  final List<ArticleModel> articles = [];

  ArticleTopic({
    this.title = 'No title',
    this.cover,
    this.isAvailable = false,
  });

  ArticleTopic.fromJson(
    Map<String, dynamic> json, {
    this.title = 'No title',
  }) {
    cover = json['cover'];
    isAvailable = json['available'] ?? true;
  }
}