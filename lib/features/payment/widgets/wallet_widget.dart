import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class WalletWidget extends StatelessWidget {
  final String title;
  final double? value;
  final String? image;
  const WalletWidget({super.key, required this.title, required this.value, this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      Container(
        height: 90, width: 150,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1), width: 1.5),
        ),
      ),

      Positioned(
        top: -5, right: -5,
        child: Image.asset(image!, opacity: const AlwaysStoppedAnimation(0.06), height: 65, width: 65),
      ),

      Positioned(
        left: 0, right: 0, top: 0, bottom: 0,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              PriceConverter.convertPrice(value), textDirection: TextDirection.ltr,
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              title, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6)),
            ),

          ]),
        ),
      ),
        
    ]);
  }
}