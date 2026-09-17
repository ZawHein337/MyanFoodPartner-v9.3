import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class BillingInfoWidget extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String value;
  const BillingInfoWidget({super.key, required this.imageIcon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
      ),
      child: Row(children: [
        CustomAssetImageWidget(
          image: imageIcon,
          width: 30, height: 30,
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(value, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ]),
        ),
      ]),
    );
  }
}