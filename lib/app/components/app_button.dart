import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.text,
    this.width = 244,
    this.height = 57,
    this.child,
    this.onPressed,
    this.color,
    this.borderColor,
    this.borderWidth = 0,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final double width;
  final double height;
  final String text;
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Get.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(61),
        border: Border.all(
          color: borderColor ?? Get.theme.primaryColorDark,
          width: borderWidth,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: Get.textTheme.button!.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
