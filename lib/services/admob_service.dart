import 'dart:async';
import 'dart:developer';

import 'package:st7/helpers/enums.dart';
import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/services/analytics/analytics_service.dart';
import 'package:st7/services/config_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService extends GetxService {
  final _remoteConfigService = Get.find<ConfigService>();
  final _analyticsService = Get.find<AnalyticsService>();

  static const _reloadDuration = Duration(seconds: 1);
  static const _channel = MethodChannel('channel');

  final _banners = <String, NativeAd>{};
  final RxSet<String> readyBanners = RxSet();
  RewardedAd? _rewardedAd;
  var _failedShowVideo = false;

  @override
  onInit() {
    loadAds();
    super.onInit();
  }

  Future<void> loadAds() async {
    _loadRewarded(_remoteConfigService.rewardVideo);
  }

  Future<void> showRewarded({
    String? adId,
    required VoidCallback callback,
  }) async {
    if (_failedShowVideo) {
      callback();
      return;
    }

    adId ??= _remoteConfigService.rewardVideo;
    if (_rewardedAd == null) await _loadRewarded(adId);

    try {
      _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView _, RewardItem __) {
          callback();
        },
      );
    } catch (e) {
      log('Failed to show rewarded - $adId');
      rethrow;
    }
  }

  Future<void> _loadRewarded(String? adId) async {
    if (adId == null || adId.isEmpty) return;
    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {
              _analyticsService.reportEvent(
                AnalyticsAdEventModel(AdEvent.open, adType: AdType.rewarded),
              );
              log('$ad onAdShowedFullScreenContent.');
            },
            onAdDismissedFullScreenContent: (RewardedAd ad) async {
              _analyticsService.reportEvent(
                AnalyticsAdEventModel(AdEvent.close, adType: AdType.rewarded),
              );
              log('$ad onAdDismissedFullScreenContent.');
              await _disposeRewarded();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) async {
              _analyticsService.reportEvent(
                AnalyticsAdEventModel(AdEvent.failedShow, adType: AdType.rewarded),
              );
              log('$ad onAdFailedToShowFullScreenContent: $error');
              await _disposeRewarded(reloadAd: false);
            },
            onAdImpression: (RewardedAd ad) {
              _analyticsService.reportEvent(
                AnalyticsAdEventModel(AdEvent.impression, adType: AdType.rewarded),
              );
              log('$ad impression occurred.');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _analyticsService.reportEvent(
            AnalyticsAdEventModel(AdEvent.failedLoad, adType: AdType.rewarded),
          );
          log('RewardedAd failed to load: $error');
          _disposeRewarded(reloadAd: false);
        },
      ),
    );
  }

  Future<void> _disposeRewarded({bool reloadAd = true}) async {
    _rewardedAd?.dispose();

    log('Rewarded Ad disposed');

    if (reloadAd) {
      Timer(_reloadDuration, () => _loadRewarded(_remoteConfigService.rewardVideo));
    } else {
      _failedShowVideo = true;
    }
  }

  Future<void> showAppOpen(AppOpenType type) async {
    if (_remoteConfigService.appOpen.isEmpty) return;
    await AppOpenAd.load(
      adUnitId: _remoteConfigService.appOpen,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('$ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              log('$ad onAdShowedFullScreenContent');
            },
            onAdFailedToShowFullScreenContent: (ad, error) async {
              log('$ad onAdFailedToShowFullScreenContent: $error');
              await ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) async {
              log('$ad onAdDismissedFullScreenContent');
              await ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          log('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  NativeAd? getBannerAd(String? id) => id == null ? null : _banners[id];

  Future<NativeAd?> loadBannerAd(String? id) async {
    if (id == null) return null;

    await _checkBanner(id);

    if (id.isEmpty) return null;

    try {
      final registered = await _channel.invokeMethod('isFactoryRegistered', id);
      if (!registered) {
        final result = await _channel.invokeMethod('registerFactory', id);
        if (!result) throw Exception('Factory registering problem');
      }
    } catch (e) {
      log('Factory check error: $e');
      return null;
    }

    _analyticsService.reportEvent(
        AnalyticsAdEventModel(AdEvent.load, adType: AdType.nativeBanner, bannerId: id));

    final native = NativeAd(
      adUnitId: id,
      factoryId: id,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad _) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.loaded, adType: AdType.nativeBanner, bannerId: id));
          readyBanners.assign(id);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError errors) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.failedLoad, adType: AdType.nativeBanner, bannerId: id));
          ad.dispose();
          readyBanners.remove(id);
        },
        onAdOpened: (Ad _) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.open, adType: AdType.nativeBanner, bannerId: id));
        },
        onAdClosed: (Ad _) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.close, adType: AdType.nativeBanner, bannerId: id));
        },
        onAdImpression: (Ad _) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.impression, adType: AdType.nativeBanner, bannerId: id));
        },
        onAdClicked: (Ad _) {
          _analyticsService.reportEvent(
              AnalyticsAdEventModel(AdEvent.click, adType: AdType.nativeBanner, bannerId: id));
        },
      ),
    );
    await native.load();
    _banners.assign(id, native);

    return native;
  }

  Future<void> _checkBanner(String id) async {
    if (_banners.containsKey(id)) {
      await _banners[id]?.dispose();
      _banners.remove(id);
      readyBanners.remove(id);
    }
  }
}
