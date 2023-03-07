import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppbarBackButton extends StatelessWidget {
  const AppbarBackButton({Key? key, this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: onPressed ?? Get.back,
        icon: const Icon(
          Icons.chevron_left_outlined,
          size: 30,
          color: Colors.black,
        ),
        splashRadius: 24,
      ),
    );
  }
}
