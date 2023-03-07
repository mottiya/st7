import 'package:st7/app/components/cover_future_builder.dart';
import 'package:st7/app/components/native_banner_ad.dart';
import 'package:st7/app/modules/articles/controller/articles_controller.dart';
import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/helpers/enums.dart';
import 'package:st7/mixins/admob_mixin.dart';
import 'package:st7/models/articles/article_model.dart';
import 'package:st7/services/cloud_storage_service.dart';
import 'package:st7/services/navigation_interceptor_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesView extends GetView<ArticlesController> with AdmobMixin {
  ArticlesView({Key? key}) : super(key: key) {
    showAppOpen(AppOpenType.start);
  }

  final _navigationService = Get.find<NavigationInterceptorService>();
  final _cloudStorageService = Get.find<CloudStorageService>();
  final _globalAds = [
    GlobalKey(debugLabel: 'firstAD'),
    GlobalKey(debugLabel: 'secondAD'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.background,
          image: const DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () => Get.toNamed(Routes.settings),
                      icon: const Icon(Icons.settings_outlined),
                      color: Colors.black,
                      iconSize: 28,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'mods'.toUpperCase(),
                        style: Get.textTheme.headline2!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
              Expanded(
                child: Obx(
                  () {
                    final length = controller.articles.length;
                    final adCount = length ~/ 2;
                    return controller.isLoading.value
                        ? const Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              for (var index = 0;
                                  index < (length + adCount);
                                  index++)
                                Builder(
                                  builder: (context) {
                                    final adsPasted = (index + 1) ~/ 3;
                                    final adIndex = adsPasted - 1;

                                    if ((index + 1) % 3 == 0 && adIndex <= 1) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: NativeBannerAd(
                                          key: _globalAds[adIndex],
                                          index: adIndex,
                                        ),
                                      );
                                    }

                                    final article =
                                        controller.articles[index - adsPasted];

                                    return ArticleCard(
                                      topic: article,
                                      onPressed: () =>
                                          _navigationService.goWithAdAndAnal(
                                        Routes.article,
                                        arguments: article,
                                      ),
                                      coverUrlFuture: _cloudStorageService
                                          .getArticleTopicFileUrl(
                                        file: article.cover,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyTextButton(
                    name: 'Terms of use',
                    onPressed: () => Get.toNamed(Routes.terms),
                  ),
                  MyTextButton(
                    name: 'Privacy policy',
                    onPressed: () => Get.toNamed(Routes.privacy),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final ArticleModel topic;
  final VoidCallback onPressed;
  final Future<String> coverUrlFuture;

  const ArticleCard({
    super.key,
    required this.topic,
    required this.onPressed,
    required this.coverUrlFuture,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 328 / 180,
                child: CoverFutureBuilder(
                  future: coverUrlFuture,
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
          Positioned(
              bottom: 10,
              right: 40,
              left: 40,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(35),
                ),
                height: 55,
                child: Center(
                  child: Text(topic.title,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: Get.theme.colorScheme.onPrimary,
                          )),
                ),
              )),
        ],
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const MyTextButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        name,
        style: Get.textTheme.overline!
            .copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
    );
  }
}
