import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AdsSectionWidget extends StatelessWidget {
  const AdsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Row(children: [
        Image.asset(Images.adsIcon, height: 40, width: 40, color: Theme.of(context).primaryColor,),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'want_to_get_highlighted'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),

              Text(
                'create_ads_to_reach_more_customers'.tr,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        TextButton(
          onPressed: (){
            if(Get.find<ProfileController>().modulePermission!.newAds!){
              Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
                if(trialEnd) {
                  Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
                }
              });
            }else{
              showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
          ),
          child: Text('create_ads'.tr),
        ),
      ]),
    );
  }
}

