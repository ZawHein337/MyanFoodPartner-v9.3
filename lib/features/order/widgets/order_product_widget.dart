import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProductWidget extends StatelessWidget {
  final OrderModel? order;
  final OrderDetailsModel orderDetails;
  const OrderProductWidget({super.key, required this.order, required this.orderDetails});
  
  @override
  Widget build(BuildContext context) {

    String addOnText = '';
    String variationText = '';

    for (var addOn in orderDetails.addOns!) {
      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    }

    if(orderDetails.variation!.isNotEmpty) {
      for(Variation variation in orderDetails.variation!) {
        variationText = '$variationText${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        for(VariationOption value in variation.variationValues!) {
          variationText = '$variationText${variationText.endsWith('(') ? '' : ', '}${value.level}';
        }
        variationText = '$variationText)';
      }
    }else if(orderDetails.oldVariation!.isNotEmpty) {
      variationText = orderDetails.oldVariation?[0].type ?? '';
    }
    
    return Row(children: [

      (orderDetails.foodDetails!.imageFullUrl != null && orderDetails.foodDetails!.imageFullUrl!.isNotEmpty) ? ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: CustomImageWidget(
          height: 60, width: 60, fit: BoxFit.cover,
          image: '${orderDetails.foodDetails!.imageFullUrl}',
        ),
      ) : const SizedBox(),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(children: [

            Expanded(
              child: Row(children: [
                Flexible(
                  child: Text(
                    orderDetails.foodDetails?.name ?? '',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Get.find<SplashController>().configModel!.toggleVegNonVeg! ? CustomAssetImageWidget(
                  image: orderDetails.foodDetails!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                  height: 12, width: 12,
                ) : SizedBox(),

              ]),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Text('${'qty'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

            Text(
              orderDetails.quantity.toString(),
              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
            ),

          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            PriceConverter.convertPrice(orderDetails.price),
            style: robotoMedium, textDirection: TextDirection.ltr,
          ),

          addOnText.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              Text('${'addons'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

              Flexible(child: Text(
                addOnText,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              )),

            ]),
          ) : const SizedBox(),

          variationText.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              Text('${'variations'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

              Flexible(child: Text(
                variationText,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              )),
            ]),
          ) : const SizedBox(),

        ]),
      ),
    ]);
  }
}