import 'package:st7/app/modules/onboarding/controller/onboarding_controller.dart';
import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/helpers/dialog_helper.dart';
import 'package:st7/models/common/analytics_event_model.dart';
import 'package:st7/services/analytics/analytics_service.dart';
import 'package:st7/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  OnboardingView({super.key});

  final NetworkService _networkService = Get.find();
  final AnalyticsService _analyticsService = Get.find();
  final _currentRating = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Obx(
            () => Image(
              image: AssetImage('assets/images/onboarding_${controller.step.value}.png'),
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                color: Get.theme.colorScheme.background,
              ),
              width: Get.width,
              height: 340,
              child: Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        (controller.step.value == 1
                                ? 'get more\n features'
                                : 'do you like\nthe app?')
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline3?.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        (controller.step.value == 1
                            ? 'and new emotions from playing\n with mods'
                            : 'then put a rating and write\n a review on Google Play'),
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyText1?.copyWith(
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                      if (controller.step.value == 1)
                        const SizedBox(height: 0)
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Get.theme.colorScheme.primaryContainer,
                            ),
                            unratedColor: Colors.grey.withOpacity(0.35),
                            onRatingUpdate: (rating) => _currentRating.value = rating.toInt(),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final nextStep = controller.step.value + 1;
                          if (nextStep > 2) {
                            if (_currentRating.value == 0) {
                              return;
                            } else {
                              _analyticsService.reportEvent(
                                AnalyticsEventModel(
                                  AnalyticsEvents.rateApp,
                                  parameters: {'rating': _currentRating.value},
                                ),
                              );
                            }
                            if (_currentRating.value > 3) {
                              await DialogHelper.showReviewDialog();
                            }
                            if (await _networkService.checkConnection()) {
                              Get.offAllNamed(Routes.articles);
                            } else {
                              Get.offAllNamed(Routes.noConnection);
                            }
                          } else {
                            controller.step.value = nextStep;
                          }
                        },
                        child: Text(
                          'Continue'.toUpperCase(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
