import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CloudStorageService extends GetxService {
  final _storageRef = FirebaseStorage.instance.ref();

  final Directory _generalDownloadDir = Directory(
      '/storage/emulated/0/Download/Minecraft mods'); //! THIS WORKS for android only !!!!!!
  String get modDirPath => _generalDownloadDir.path;

  @override
  Future<void> onInit() async {
    if (!await _generalDownloadDir.exists()) {
      _generalDownloadDir.create();
    }
    super.onInit();
  }

  Future<String> _getFileUrl({
    required String folder,
    required String file,
  }) async {
    try {
      final url = await _storageRef.child('$folder/$file').getDownloadURL();
      return url;
    } on FirebaseException catch (_) {
      return 'https://firebasestorage.googleapis.com/v0/b/my-app-962e3.appspot.com/o/covers%2Fcover%20(2).png?alt=media&token=a614933e-1bfe-4fc5-9bfd-f34d12228e99';
    }
  }

  Future<String> getArticleTopicFileUrl({required String file}) =>
      _getFileUrl(folder: 'articles/cover/', file: file);

  Future<void> downloadFile({
    required String folder,
    required String filename,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    final ref = _storageRef.child('$folder/$filename');
    final filePath = '$modDirPath/$filename';
    final file = await File(filePath).create();

    final downloadTask = ref.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          if (onSuccess != null) onSuccess();
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          if (onError != null) onError();
          break;
      }
    });
  }
}
