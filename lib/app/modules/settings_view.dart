import 'package:st7/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.chevron_left_outlined),
                      color: Colors.black,
                      iconSize: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyElevatedButton(
                      text: 'privacy police',
                      func: () {
                        Get.toNamed(Routes.privacy);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyElevatedButton(
                      text: 'terms of use  ',
                      func: () {
                        Get.toNamed(Routes.terms);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Function()? func;

  const MyElevatedButton({super.key, required this.text, this.func});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: Get.theme.elevatedButtonTheme.style,
      child: FittedBox(
        child: Text(text.toUpperCase(),
            style: Get.textTheme.button!.copyWith(
              color: Get.theme.colorScheme.surface,
            )),
      ),
    );
  }
}
