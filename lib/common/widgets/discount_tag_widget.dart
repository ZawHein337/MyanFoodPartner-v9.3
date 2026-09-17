import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTagWidget extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool freeDelivery;
  final bool isColor;
  const DiscountTagWidget({super.key, required this.discount, required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false,
    this.isColor = true});

  @override
  Widget build(BuildContext context) {
    return (discount! > 0 || freeDelivery) ? Positioned(
      top: fromTop, left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: isColor ? Colors.green : null,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(Dimensions.radiusSmall)),
        ),
        child: Text(
          discount! > 0 ? '$discount${discountType == 'percent' ? '%'
              : Get.find<SplashController>().configModel!.currencySymbol} ${'off'.tr}' : 'free_delivery'.tr,
          style: robotoMedium.copyWith(
            color: Colors.white,
            fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 8 : 12),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ) : const SizedBox();
  }
}