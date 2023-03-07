import 'package:st7/app/routes/app_pages.dart';
import 'package:st7/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionView extends GetView<NetworkService> {
  const NoConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Something went wrong with your internet connection. Please check it and try again',
                  style: Get.textTheme.bodyText1!.copyWith(color: Get.theme.colorScheme.surface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await controller.checkConnection()) {
                      Get.offAllNamed(Routes.home);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("You still do not have connection. Please try again"),
                            actions: [
                              TextButton(
                                onPressed: Get.back,
                                child: const Text('OK'),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: Get.theme.elevatedButtonTheme.style,
                  child: Text(
                    'Refresh',
                    style: Get.textTheme.button!.copyWith(color: Get.theme.colorScheme.surface),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
