import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

/// Shown for an approved BOGO offer the customer app is still holding back, listing
/// the server's reasons so the vendor knows what to fix rather than assuming a bug.
class OfferNotVisibleBottomSheet extends StatelessWidget {
  final List<String> reasons;
  const OfferNotVisibleBottomSheet({super.key, required this.reasons});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color noticeColor = Color(0xFFE8A13A);

    return Container(
      width: context.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.close, color: theme.textTheme.bodyLarge!.color, size: 22),
            ),
          ),

          Image.asset(Images.warning, height: 60, width: 60),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'offer_not_visible_to_customers'.tr, textAlign: TextAlign.center,
            style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text(
            'this_bogo_offer_is_approved_but_customers_can_not_see_or_order_it_right_now'.tr,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: theme.hintColor),
          ),

          if(reasons.isNotEmpty) ...[
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              width: context.width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: noticeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'reasons_the_bogo_offer_is_on_hold'.tr,
                  style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: noticeColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ...reasons.map((reason) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: Dimensions.paddingSizeSmall),
                      child: Container(
                        height: 5, width: 5,
                        decoration: const BoxDecoration(color: noticeColor, shape: BoxShape.circle),
                      ),
                    ),

                    Expanded(child: Text(
                      reason,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: noticeColor),
                    )),

                  ]),
                )),

              ]),
            ),
          ],
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'the_bogo_offer_returns_to_the_customer_app_automatically_once_these_are_resolved'.tr,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: theme.hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomButtonWidget(
            buttonText: 'okay'.tr,
            onPressed: () => Get.back(),
          ),

        ]),
      ),
    );
  }
}
