import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Bottom sheet shown when the restaurant taps the action button of a happy
/// hour the admin has invited them to.
class HappyHourRequestBottomSheetWidget extends StatelessWidget {
  final HappyHourModel happyHourModel;
  final Function()? onViewDetails;
  const HappyHourRequestBottomSheetWidget({super.key, required this.happyHourModel, this.onViewDetails});

  static Future<T?> show<T>({required HappyHourModel happyHourModel, Function()? onViewDetails}) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HappyHourRequestBottomSheetWidget(happyHourModel: happyHourModel, onViewDetails: onViewDetails),
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
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Image.asset(Images.warning, height: 45, width: 45),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Text(
            'happy_hour_campaign_request'.tr, textAlign: TextAlign.center,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            'happy_hour_campaign_request_description'.tr, textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          SizedBox(
            width: 170,
            child: CustomButtonWidget(
              buttonText: 'view_details'.tr,
              radius: Dimensions.radiusDefault,
              height: 50,
              onPressed: () {
                Get.back();
                onViewDetails?.call();
              },
            ),
          ),

        ]),
      ),
    );
  }
}
