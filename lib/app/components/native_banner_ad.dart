import 'package:st7/mixins/admob_mixin.dart';
import 'package:st7/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeBannerAd extends StatefulWidget {
  const NativeBannerAd({Key? key, this.index = 0}) : super(key: key);

  final int index;

  @override
  State<NativeBannerAd> createState() => _NativeBannerAdState();
}

class _NativeBannerAdState extends State<NativeBannerAd>
    with AutomaticKeepAliveClientMixin, AdmobMixin {
  _NativeBannerAdState() {
    launchAd();
  }

  final _remoteConfigService = Get.find<ConfigService>();

  Future<void> launchAd() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      id = widget.index == -1
          ? _remoteConfigService.article
          : _remoteConfigService.getAdId(widget.index);

      loadBannerAd(id);

      setState(() {});
    });
  }

  String id = '';

  @override
  Widget build(BuildContext context) {
    return id.isNotEmpty
        ? Obx(
            () => readyBanners.contains(id) && getBannerAd(id) != null
                ? SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: AdWidget(
                      ad: getBannerAd(id)!,
                    ),
                  )
                : const SizedBox(height: 200),
          )
        : const SizedBox(height: 200);
  }

  @override
  bool get wantKeepAlive => true;
}
