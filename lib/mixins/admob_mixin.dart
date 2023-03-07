import 'package:st7/helpers/dialog_helper.dart';
import 'package:st7/helpers/enums.dart';
import 'package:st7/mixins/event_mixin.dart';
import 'package:st7/services/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin AdmobMixin {
  final _admobService = Get.find<AdmobService>();

  Future<void> showAppOpen(AppOpenType type) => _admobService.showAppOpen(type);

  Future<void> showRewarded({
    String? adId,
    required VoidCallback callback,
  }) async {
    try {
      _admobService.showRewarded(
        adId: adId,
        callback: callback,
      );
    } catch (e) {
      DialogHelper.show(
        DialogEvent(title: 'Error', description: 'Failed to load ad, please try again'),
      );
    }
  }

  Future<NativeAd?> loadBannerAd(String? id) => _admobService.loadBannerAd(id);

  NativeAd? getBannerAd(String? id) => _admobService.getBannerAd(id);

  RxSet<String> get readyBanners => _admobService.readyBanners;
}
