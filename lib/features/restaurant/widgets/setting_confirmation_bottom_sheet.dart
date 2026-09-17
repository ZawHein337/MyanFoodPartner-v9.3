import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class SettingConfirmationBottomSheet extends StatelessWidget {
  final String? image;
  final String title;
  final String? description;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Function onConfirm;
  const SettingConfirmationBottomSheet({super.key, this.image, required this.title, this.description, this.confirmButtonText, this.cancelButtonText, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 30, width: 30,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),

        Image.asset(
          image ?? Images.switchIcon, height: 60, width: 60,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            description ?? '',
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 50),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Row(children: [

            Expanded(
              child: CustomButtonWidget(
                onPressed: () {
                  Get.back();
                },
                buttonText: cancelButtonText ?? 'no'.tr,
                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: CustomButtonWidget(
                onPressed: () => onConfirm(),
                buttonText: confirmButtonText ?? 'yes'.tr,
                color: Theme.of(context).primaryColor,
              ),
            ),

          ]),
        ),

      ]),

    );
  }
}
