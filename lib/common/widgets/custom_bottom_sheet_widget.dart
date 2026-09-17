import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

void showCustomBottomSheet({required Widget child, double? maxHeight}) {
  Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight ?? MediaQuery.of(Get.context!).size.height * 0.8),
      child: child,
    ),
    isScrollControlled: true, useRootNavigator: true,
    backgroundColor: Theme.of(Get.context!).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
    ),
  );
}