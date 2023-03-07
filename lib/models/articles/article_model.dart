class ArticleModel {
  String title;
  String content;
  String file;
  String cover;

  ArticleModel({
    required this.file,
    required this.title,
    required this.cover,
    required this.content,
  });

  ArticleModel.fromJson(
      {required Map<String, dynamic> json, required this.title})
      : file = json['file'] ?? '',
        cover = json['cover'],
        content = json['content'] ?? 'No content';
}
