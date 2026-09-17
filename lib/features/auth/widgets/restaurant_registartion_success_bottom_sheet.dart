import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class RestaurantRegistrationSuccessBottomSheet extends StatelessWidget {
  const RestaurantRegistrationSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius : const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
          topRight : Radius.circular(Dimensions.paddingSizeExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Center(
          child: Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
          ),
        ),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const CustomAssetImageWidget(image: Images.storeRegistrationSuccess, height: 100, width: 130),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('${'welcome_to'.tr} ${AppConstants.appName}!', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeOverLarge, right: Dimensions.paddingSizeOverLarge),
                child: Text(
                  'thanks_for_joining_us_your_registration_is_under_review_hang_tight_we_ll_notify_you_once_approved'.tr,
                  textAlign: TextAlign.center,
                  style: robotoRegular,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

              SizedBox(
                width: 100,
                child: CustomButtonWidget(
                  buttonText: 'okay'.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.fontSizeLarge,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]),
          ),
        ),
      ]),
    );
  }
}
