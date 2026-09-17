import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Confirmation sheet shown before the restaurant joins or approves a happy
/// hour, spelling out what joining costs them.
class HappyHourJoinBottomSheetWidget extends StatelessWidget {
  final HappyHourModel happyHourModel;
  final Function()? onConfirm;
  const HappyHourJoinBottomSheetWidget({super.key, required this.happyHourModel, this.onConfirm});

  static Future<T?> show<T>({required HappyHourModel happyHourModel, Function()? onConfirm}) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HappyHourJoinBottomSheetWidget(happyHourModel: happyHourModel, onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraLarge,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.close, color: Theme.of(context).hintColor, size: 24),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Image.asset(Images.warning, height: 45, width: 45),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'join_happy_hour_campaign'.tr, textAlign: TextAlign.center,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(50),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              _buildBullet(context, 'happy_hour_replaces_other_offers'.tr),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _buildBullet(context, 'pro_member_discount_will_stay'.tr),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Expanded(child: Text(
                    'you_will_bear_full_happy_hour_cost'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  )),

                ]),
              ),

            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Row(children: [

            Expanded(child: CustomButtonWidget(
              buttonText: 'reset'.tr,
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              height: 50,
              onPressed: () => Get.back(),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: CustomButtonWidget(
              buttonText: 'okay'.tr,
              height: 50,
              onPressed: () {
                Get.back();
                onConfirm?.call();
              },
            )),

          ]),

        ]),
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
        child: Container(
          height: 4, width: 4,
          decoration: BoxDecoration(color: Theme.of(context).hintColor, shape: BoxShape.circle),
        ),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(child: Text(
        text,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
      )),

    ]);
  }
}
