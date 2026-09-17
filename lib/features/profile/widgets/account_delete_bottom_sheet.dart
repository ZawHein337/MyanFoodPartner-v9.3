import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AccountDeleteBottomSheet extends StatelessWidget {
  const AccountDeleteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: GetBuilder<ProfileController>(builder: (profileController) {

        bool payTheDue = false;
        if(profileController.profileModel != null) {
          payTheDue = (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!);
        }

        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 35),

          CustomAssetImageWidget(
            image: payTheDue ? Images.accountDeleteWarningIcon : Images.accountDeleteIcon, height: 60, width: 60,
          ),
          const SizedBox(height: 35),

          Text(payTheDue ? 'sorry_you_can_not_delete_your_account'.tr : 'delete_your_account'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(payTheDue ? 'account_delete_warning'.tr : 'account_delete_description'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 50),

          payTheDue ? CustomButtonWidget(
            onPressed: () {
              Get.back();
              Get.toNamed(RouteHelper.getWalletRoute());
            },
            buttonText: 'pay_the_due'.tr,
            color: Theme.of(context).colorScheme.error,
          ) : Row(children: [

            Expanded(
              child: !profileController.isLoading ? CustomButtonWidget(
                onPressed: () {
                  profileController.deleteVendor();
                },
                buttonText: 'yes'.tr,
                color: Theme.of(context).colorScheme.error,
              ) : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.error)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: CustomButtonWidget(
                onPressed: () {
                  Get.back();
                },
                buttonText: 'no'.tr,
                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),

          ]),

        ]);
      }),
    );
  }
}
