import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/screen/bogo_offer_setup_screen.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class BogoCampaignRequestBottomSheet extends StatelessWidget {
  final int? offerId;
  final String? status;
  final int buyQuantity;
  final int getQuantity;
  const BogoCampaignRequestBottomSheet({super.key, this.offerId, this.status, required this.buyQuantity, required this.getQuantity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(children: [
      Container(
        width: context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: Dimensions.paddingSizeOverLarge),
        
          Image.asset(Images.alertIcon, height: 44, width: 44),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        
          Text('bogo_campaign_request'.tr, textAlign: TextAlign.center, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        
          Text(
            'the_admin_has_invited_you_to_join_a_bogo_offer'.tr, textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverExtraLarge*2),
            child: CustomButtonWidget(
              buttonText: 'view_details'.tr,
              onPressed: () {
                Get.back();
                Get.to(() => BogoOfferSetupScreen(
                  buyQuantity: buyQuantity, getQuantity: getQuantity, offerId: offerId, status: status,
                ));
              },
              radius: Dimensions.radiusDefault,
            ),
          ),
        
        ]),
      ),

      Positioned(
        top: 10, right: 10,
        child: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.close, size: 20, color: theme.hintColor.withValues(alpha: 0.5)),
        ),
      ),
    ]);
  }
}
