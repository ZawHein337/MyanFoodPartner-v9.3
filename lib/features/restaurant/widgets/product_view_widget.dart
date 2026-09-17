import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/product_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final String? type;
  final Function(String type)? onVegFilterTap;
  const ProductViewWidget({super.key, required this.scrollController, this.type, this.onVegFilterTap});

  @override
  Widget build(BuildContext context) {

    Get.find<RestaurantController>().setOffset(1);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<RestaurantController>().productList != null
          && !Get.find<RestaurantController>().isLoading) {
        int pageSize = (Get.find<RestaurantController>().pageSize! / 10).ceil();
        if (Get.find<RestaurantController>().offset < pageSize) {
          Get.find<RestaurantController>().setOffset(Get.find<RestaurantController>().offset+1);
          customPrint('end of the page');
          Get.find<RestaurantController>().showBottomLoader();
          Get.find<RestaurantController>().getProductList(
            offset: Get.find<RestaurantController>().offset.toString(), foodType: Get.find<RestaurantController>().selectedFoodType,
            stockType: Get.find<RestaurantController>().selectedStockType, categoryId: Get.find<RestaurantController>().categoryId,
          );
        }
      }
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if(Get.find<RestaurantController>().isFabVisible){
          Get.find<RestaurantController>().hideFab();
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if(!Get.find<RestaurantController>().isFabVisible){
          Get.find<RestaurantController>().showFab();
        }
      }
    });

    return GetBuilder<RestaurantController>(builder: (restController) {
      return Column(children: [

        restController.productList != null ? restController.productList!.isNotEmpty ? GridView.builder(
          key: UniqueKey(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeDefault,
            mainAxisSpacing:Dimensions.paddingSizeDefault,
            mainAxisExtent: 111,
            crossAxisCount: 1,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restController.productList!.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          itemBuilder: (context, index) {
            return ProductWidget(
              product: restController.productList![index],
              index: index, length: restController.productList!.length, isCampaign: false,
              inRestaurant: true,
            );
          },
        ) : Center(child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Text('no_food_available'.tr),
        )) : GridView.builder(
          key: UniqueKey(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeDefault,
            mainAxisSpacing:Dimensions.paddingSizeDefault,
            mainAxisExtent: 112,
            crossAxisCount: 1,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return const ProductShimmerWidget();
          },
        ),

        restController.isLoading ? Center(child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        )) : const SizedBox(),

      ]);
    });
  }
}