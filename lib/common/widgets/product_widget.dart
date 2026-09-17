import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  const ProductWidget({super.key, required this.product, required this.index, required this.length, this.inRestaurant = false,
    this.isCampaign = false});

  @override
  Widget build(BuildContext context) {

    double? discount;
    String? discountType;
    bool isAvailable;
    bool isOutOfStock = false;

    discount = (product.restaurantDiscount == 0 || isCampaign) ? product.discount : product.restaurantDiscount;
    discountType = (product.restaurantDiscount == 0 || isCampaign) ? product.discountType : 'percent';
    isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds)
        && DateConverter.isAvailable(product.restaurantOpeningTime, product.restaurantClosingTime);

    if(product.variations != null && product.variations!.isNotEmpty) {
      for(int i=0; i<product.variations!.length; i++) {
        for(int j=0; j<product.variations![i].variationValues!.length; j++) {
          if(_stringToInt(product.variations![i].variationValues![j].currentStock)! > 0) {
            isOutOfStock = false;
          }else {
            isOutOfStock = true;
            break;
          }
        }
      }
    }


    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Slidable(
        key: UniqueKey(),
        enabled: !restaurantController.isLoading,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: context.width > 400 ? 0.2 : 0.21,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 13),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(Dimensions.radiusDefault)),
              ),
              child: Column(children: [

                InkWell(
                  onTap: () {
                    if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                      showCustomBottomSheet(
                        child: ProductDeleteBottomSheet(productId: product.id!),
                      );
                    }else {
                      showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Icon(CupertinoIcons.delete_solid, color: Theme.of(context).colorScheme.error, size: 15),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  height: 1, width: 50,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                ),

                InkWell(
                  onTap: () {
                    if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                      Get.find<RestaurantController>().getProductDetails(product.id!, productClear: false).then((itemDetails) {
                        if(itemDetails != null){
                          Get.toNamed(RouteHelper.getAddProductRoute(itemDetails));
                        }
                      });
                    }else {
                      showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Image.asset(Images.penIcon, height: 15, width: 15, color: Colors.blue),
                  ),
                ),

              ]),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Get.toNamed(RouteHelper.getProductDetailsRoute(productId: product.id!, isCampaign: isCampaign)),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: Row(children: [

              Stack(children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: CustomImageWidget(
                    image: '${product.imageFullUrl}',
                    height: double.infinity, width: 90, fit: BoxFit.cover,
                  ),
                ),

                DiscountTagWidget(
                  discount: discount, discountType: discountType,
                  freeDelivery: false,
                ),

                isAvailable ? const SizedBox() : const NotAvailableWidget(isRestaurant: false),

              ]),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Row(children: [

                    Flexible(
                      child: Text(
                        product.name ?? '',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    CustomAssetImageWidget(
                      image: product.veg == 0 ? Images.nonVegImage : Images.vegImage,
                      height: 11, width: 11,
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    product.categoryIds?[0].categoryName != null ? Text(
                      '${'category'.tr}: ${product.categoryIds?[0].categoryName ?? ''}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ) : const SizedBox(),

                    product.categoryIds?[0].categoryName != null ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall + 3),
                      height: 10, width: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor,
                      ),
                    ) : const SizedBox(),

                    Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                    const SizedBox(width: 3),

                    Text(
                      product.avgRating!.toStringAsFixed(1),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(width: 3),

                    Text(
                      '(${product.ratingCount})',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    discount! > 0 ? Text(
                      PriceConverter.convertPrice(product.price), textDirection: TextDirection.ltr,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).hintColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ) : const SizedBox(),
                    SizedBox(width: discount > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                    Text(
                      PriceConverter.convertPrice(product.price, discount: discount, discountType: discountType),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                    ),
                    const Spacer(),

                    ((product.stockType == 'unlimited' || product.itemStock! > 0) && (product.stockType == 'unlimited' || !isOutOfStock)) ? Text(
                      '${'stock'.tr} : ${product.stockType == 'unlimited' ? 'unlimited'.tr : product.itemStock}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                    ) : Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'out_of_stock'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          CustomToolTip(
                            message: (product.stockType == 'unlimited' || product.itemStock! <= 0) ? 'your_main_stock_is_out_of_stock'.tr : 'one_or_more_variations_are_out_of_stock'.tr,
                            preferredDirection: AxisDirection.down,
                            child: Icon(Icons.info_outline, color: Theme.of(context).primaryColor, size: 15),
                          ),

                        ],
                      ),
                    ),

                  ]),

                ]),
              ),

            ]),
          ),
        ),
      );
    });
  }

  int? _stringToInt(String? value) {
    if (value == null) return 0;
    return int.parse(value);

  }

}