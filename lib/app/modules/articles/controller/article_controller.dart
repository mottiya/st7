import 'dart:developer';

import 'package:st7/models/articles/article_model.dart';
import 'package:st7/services/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleController extends GetxController {
  final _cloudStorageService = Get.find<CloudStorageService>();
  final isDownloading = false.obs;
  final adWatched = false.obs;
  final article = Rx<ArticleModel>(Get.arguments);

  Future<void> downloadMod() async {
    try {
      isDownloading.value = true;
      await _cloudStorageService.downloadFile(
          folder: 'articles/file',
          filename: article.value.file,
          onSuccess: () {
            isDownloading.value = false;
            Get.snackbar(
              'Mod downloaded',
              'You can find it in your Downloads directory',
              colorText: Colors.white,
            );
          },
          onError: () {
            isDownloading.value = false;
            Get.snackbar('Error', 'Could not download the mod, please try again');
          });
    } catch (e) {
      log('Download error - $e');
    }
  }
}
