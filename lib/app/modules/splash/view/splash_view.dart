import 'dart:async';

import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/dependencies.dart';
import 'package:st7/services/network_service.dart';
import 'package:st7/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  final NetworkService _networkService = Get.find();
  final StorageService _storageService = Get.find();

  SplashView({Key? key}) : super(key: key) {
    Timer(1.seconds, () async {
      await Dependencies.loadOnSplash();

      final launchingCount =
          _storageService.getInt(StorageKeys.launchingCount) ?? 0;
      _storageService.setInt(StorageKeys.launchingCount, launchingCount + 1);

      if (launchingCount == 0) {
        Get.offAllNamed(Routes.onboarding);
      } else if (!await _networkService.checkConnection()) {
        Get.offAllNamed(Routes.noConnection);
      } else {
        Get.offAllNamed(Routes.articles);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: const Alignment(1, 1),
            child: Image(
              image: const AssetImage('assets/images/splash_image.png'),
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _TextBox(),
              SizedBox(
                height: 30,
              ),
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'minecraft'.toUpperCase(),
          style: Get.textTheme.headline1!.copyWith(
            color: Get.theme.colorScheme.background,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'mods'.toUpperCase(),
          style: Get.textTheme.subtitle1!.copyWith(
            color: Get.theme.colorScheme.background,
          ),
        )
      ],
    );
  }
}
