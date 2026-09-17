import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class LeaveBogoOfferConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const LeaveBogoOfferConfirmationBottomSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Image.asset(Images.warning, height: 44, width: 44),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          'are_you_sure_to_leave'.tr, textAlign: TextAlign.center,
          style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(children: [
          Expanded(child: CustomButtonWidget(
            buttonText: 'no'.tr,
            color: theme.disabledColor.withValues(alpha: 0.2),
            textColor: theme.textTheme.bodyLarge!.color,
            onPressed: () => Get.back(),
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: CustomButtonWidget(
            buttonText: 'yes'.tr,
            color: theme.colorScheme.error,
            onPressed: () {
              Get.back();
              onConfirm();
            },
          )),
        ]),
      ]),
    );
  }
}
