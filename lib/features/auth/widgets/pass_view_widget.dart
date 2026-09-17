import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassViewWidget extends StatelessWidget {
  const PassViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
        child: Wrap(children: [

          View(title: '8_or_more_character'.tr, done: authController.lengthCheck),

          View(title: '1_number'.tr, done: authController.numberCheck),

          View(title: '1_upper_case'.tr, done: authController.uppercaseCheck),

          View(title: '1_lower_case'.tr, done: authController.lowercaseCheck),

          View(title: '1_special_character'.tr, done: authController.spatialCheck),

        ]),
      );
    });
  }
}

class View extends StatelessWidget {
  final String title;
  final bool done;
  const View({super.key, required this.title, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisSize: MainAxisSize.min, children: [

        Icon(done ? Icons.check : Icons.clear, color: done ? Colors.green: Theme.of(context).colorScheme.error, size: 12),

        Text(title, style: robotoRegular.copyWith(color: done ? Colors.green : Theme.of(context).colorScheme.error, fontSize: 12)),

      ]),
    );
  }
}