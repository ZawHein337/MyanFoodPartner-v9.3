part of '../screens/home_screen.dart';

class _BogoOfferCard extends StatelessWidget {
  const _BogoOfferCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      height: 80,
      child: CustomInkWellWidget(
        onTap: (){
          Get.toNamed(RouteHelper.getBogoOfferRoute());
        },
        radius: Dimensions.radiusLarge,
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: theme.disabledColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: Row(children: [
            const CustomAssetImageWidget(image: Images.bogoOfferIcon, height: 40, width: 40),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('hurry_up_bogo_offer_is_live'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('buy_more_and_enjoy_exclusive_free_items'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            // Not swapped by hand: Icons.arrow_forward carries matchTextDirection, so
            // Flutter already mirrors it under an RTL Directionality. Picking arrow_back
            // for Arabic flipped it a second time and left it pointing the wrong way.
            Icon(
              Icons.arrow_forward,
              color: theme.hintColor,
              size: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
