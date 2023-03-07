import 'package:st7/app/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemedAlertDialog extends StatelessWidget {
  const ThemedAlertDialog({
    Key? key,
    this.backgroundColor,
    this.title,
    this.content,
    this.description,
    this.actions,
    this.buttons,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? title;
  final Widget? content;
  final String? description;
  final List<Widget>? actions;
  final Map<String, VoidCallback?>? buttons;

  List<Widget>? _buildActions() {
    if (actions != null) return actions;
    if (buttons != null) {
      return buttons!.entries
          .map(
            (button) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AppButton(
                text: button.key,
                onPressed: button.value,
                height: 68,
              ),
            ),
          )
          .toList();
    }
    return [
      AppButton(
        onPressed: Get.back,
        text: 'CLOSE',
      )
    ];
  }

  Widget? _buildContent(BuildContext context) {
    if (content != null) return content;
    if (description != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: const Alignment(1.15, 0),
            child: IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.close),
              iconSize: 14,
              splashRadius: 20,
            ),
          ),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor ?? Get.theme.colorScheme.background,
      insetPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actionsPadding: buttons == null && actions == null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(bottom: 20, left: 15, right: 15),
      title: title == null
          ? null
          : Text(
              title!,
              style: Theme.of(context).textTheme.subtitle1,
            ),
      content: _buildContent(context),
      actionsAlignment: MainAxisAlignment.center,
      actions: _buildActions(),
    );
  }
}
