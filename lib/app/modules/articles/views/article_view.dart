import 'package:st7/app/components/cover_future_builder.dart';
import 'package:st7/app/components/native_banner_ad.dart';
import 'package:st7/app/components/ui/appbar_back_button.dart';
import 'package:st7/app/modules/articles/controller/article_controller.dart';
import 'package:st7/mixins/admob_mixin.dart';
import 'package:st7/services/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class ArticleView extends GetView<ArticleController> with AdmobMixin {
  ArticleView({Key? key}) : super(key: key);

  final _cloudStorageService = Get.find<CloudStorageService>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(
          () {
            return SafeArea(
              child: controller.isDownloading.value
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            'Your file is being downloaded.\nPlease wait.',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.bodyText1!.copyWith(
                              color: Get.theme.colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: AppbarBackButton(),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    controller.article.value.title
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Get
                                              .theme.colorScheme.onBackground,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.center,
                              color: Get.theme.colorScheme.primary,
                              width: double.infinity,
                              child: Markdown(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 31,
                                  vertical: 29,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                styleSheet:
                                    MarkdownStyleSheet.fromTheme(Get.theme)
                                        .copyWith(
                                  p: Get.textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                ),
                                data: controller.article.value.content
                                    .replaceAll('\\n', '\n'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: AspectRatio(
                                aspectRatio: 328 / 203,
                                child: CoverFutureBuilder(
                                  future: _cloudStorageService
                                      .getArticleTopicFileUrl(
                                    file: controller.article.value.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.white,
                                    child: const Center(
                                        child: Text('Failed image loading')),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: NativeBannerAd(index: -1),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Obx(
                                () {
                                  return ElevatedButton(
                                    onPressed: () => controller.adWatched.value
                                        ? controller.downloadMod()
                                        : showRewarded(
                                            callback: () => controller
                                                .adWatched.value = true,
                                          ),
                                    style: Get.theme.elevatedButtonTheme.style,
                                    child: Text(
                                      controller.adWatched.value
                                          ? 'download mod'.toUpperCase()
                                          : 'watch ad to get mod'.toUpperCase(),
                                      maxLines: 1,
                                      style: Get.textTheme.button!.copyWith(
                                          color: Get.theme.colorScheme.surface),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
