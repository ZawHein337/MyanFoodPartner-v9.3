import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VegFilterWidget extends StatelessWidget {
  final String? type;
  final Function(String value)? onSelected;
  const VegFilterWidget({super.key, required this.type, required this.onSelected});

  @override
  Widget build(BuildContext context) {

    //final bool ltr = Get.find<LocalizationController>().isLtr;

    return Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Align(alignment: Alignment.center, child: Container(
      height: 37,
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Get.find<RestaurantController>().productTypeList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onSelected!(Get.find<RestaurantController>().productTypeList[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Get.find<RestaurantController>().productTypeList[index] == type ? Theme.of(context).primaryColor : null,
              ),
              child: Text(
                Get.find<RestaurantController>().productTypeList[index].tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                    color: Get.find<RestaurantController>().productTypeList[index] == type ? Theme.of(context).cardColor : Theme.of(context).hintColor),
              ),
            ),
          );
        },
      ),
    )) : const SizedBox();
  }
}