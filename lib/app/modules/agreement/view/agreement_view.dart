import 'package:st7/app/components/ui/appbar_back_button.dart';
import 'package:st7/helpers/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AgreementType { privacy, terms }

class PrivacyAndTermsView extends StatelessWidget {
  PrivacyAndTermsView({super.key}) {
    agreementType = Get.parameters['agreementType'] == 'privacy'
        ? AgreementType.privacy
        : AgreementType.terms;
  }

  late final AgreementType agreementType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarBackButton(),
        centerTitle: true,
        title: Text(
          agreementType == AgreementType.privacy
              ? 'privacy policy'.toUpperCase()
              : 'terms of use'.toUpperCase(),
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: Get.theme.colorScheme.onBackground,
              ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Scrollbar(
                thickness: 3,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  physics: const BouncingScrollPhysics(), children: [
                                Text(
                agreementType == AgreementType.privacy
                    ? TextHelper.privacy
                    : TextHelper.terms,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                                ),
                              ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
