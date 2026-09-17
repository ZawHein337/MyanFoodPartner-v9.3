import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class JoinCampaignBottomSheetWidget extends StatelessWidget {
  final bool isJoined;
  final int? campaignID;
  const JoinCampaignBottomSheetWidget({super.key, required this.isJoined, required this.campaignID});

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
      child: GetBuilder<CampaignController>(builder: (campaignController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: 50),

          const CustomAssetImageWidget(
            image: Images.confirmCampaignIcon, height: 70, width: 70,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(isJoined ? 'want_to_leave_from_this_campaign'.tr : 'want_to_join_the_campaign'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text('join_campaign_description'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 50),

          Row(children: [

            Expanded(
              child: !campaignController.isLoading ? CustomButtonWidget(
                onPressed: () {
                  if(isJoined) {
                    campaignController.leaveCampaign(campaignID, true);
                  }else {
                    campaignController.joinCampaign(campaignID, true);
                  }
                },
                buttonText: 'yes'.tr,
                color: Theme.of(context).primaryColor,
              ) : const Center(child: CircularProgressIndicator()),
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
