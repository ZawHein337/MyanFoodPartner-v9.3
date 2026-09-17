import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/filter_data_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
    Get.find<RestaurantController>().resetCategorySelection();
    Get.find<RestaurantController>().getProductList(offset: '1', foodType: 'all', stockType: 'all', categoryId: 0, isUpdate: false);
    Get.find<RestaurantController>().getRestaurantCategories(isUpdate: false);

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!Get.find<RestaurantController>().isTitleVisible && _scrollController.offset > 100) {
        Get.find<RestaurantController>().showTitle();
      }
    } else if(_scrollController.position.userScrollDirection == ScrollDirection.forward && _scrollController.offset < 100) {
      if (Get.find<RestaurantController>().isTitleVisible) {
        Get.find<RestaurantController>().hideTitle();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<ProfileController>(builder: (profileController) {

        Restaurant? restaurant = profileController.profileModel != null ? profileController.profileModel!.restaurants![0] : null;
        bool isFilterActive = restController.selectedFoodType != 'all' || restController.selectedStockType != 'all';

        return Scaffold(
          floatingActionButton: GetBuilder<RestaurantController>(builder: (restaurantController) {

            return Column(mainAxisAlignment: MainAxisAlignment.end, children: [

              InkWell(
                onTap: () {
                  if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                    if(Get.find<ProfileController>().profileModel!.subscriptionOtherData != null && Get.find<ProfileController>().profileModel!.subscriptionOtherData!.maxProductUpload == 0
                        && Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'){
                      showCustomSnackBar('your_food_add_limit_is_over'.tr);
                    }else {
                      if (restaurant != null) {
                        Get.toNamed(RouteHelper.getAddProductRoute(null));
                      }
                    }
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 25),
                ),
              ),

            ]);
          }),

          body: Column(children: [

            Container(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge, top: 40),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: _isSearch ? Row(children: [

                InkWell(
                  onTap: () {
                    _isSearch = !_isSearch;
                    setState(() {});
                  },
                  child: Icon(Icons.close),
                ),
                SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: SizedBox(
                    height: 47,
                    child: SearchBar(
                      controller: _searchController,
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).disabledColor.withValues(alpha: 0.1)),
                      elevation: WidgetStatePropertyAll(0),
                      side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.3))),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusMedium))),
                      onChanged: (value) {
                        restController.getProductList(offset: '1', foodType: 'all', stockType: restController.selectedStockType, categoryId: restController.categoryId, search: value);
                      },
                      onSubmitted: (value) {
                        restController.getProductList(offset: '1', foodType: 'all', stockType: restController.selectedStockType, categoryId: restController.categoryId, search: value);
                      },
                      hintText: 'search_food'.tr,
                      hintStyle: WidgetStatePropertyAll(
                        robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
                      leading: Icon(CupertinoIcons.search, color: Theme.of(context).hintColor),
                      trailing: _searchController.text.isEmpty ? [const SizedBox()] : _searchController.text.isNotEmpty ? [InkWell(
                        child: Icon(Icons.clear, color: Theme.of(context).hintColor),
                        onTap: () {
                          _searchController.clear();
                          restController.clearSearch();
                          restController.update();
                        },
                      )] : [const SizedBox()],
                    ),
                  ),
                ),

              ]) : Row(children: [

                InkWell(
                  onTap: () {
                    restController.setCategory(index: 0, foodType: 'all', stockType: 'all');
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                SizedBox(width: 50),

                Expanded(child: Center(
                  child: Text('all_food'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color)),
                )),

                InkWell(
                  onTap: () {
                    _isSearch = !_isSearch;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Icon(CupertinoIcons.search),
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeSmall),


                InkWell(
                  onTap: () {
                    showCustomBottomSheet(child: const FilterDataBottomSheet());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                      color: isFilterActive ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Icon(Icons.tune, color: isFilterActive ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
                  ),
                ),

              ]),
            ),

            restaurant != null ? Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [

                  restController.categoryNameList != null ? SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restController.categoryNameList!.length,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () => restController.setCategory(index: index, foodType: 'all', stockType: 'all'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                              color: index == restController.categoryIndex ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.25),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                index == 0 ? 'all'.tr : restController.categoryNameList![index].trim(),
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: index == restController.categoryIndex ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                                  fontWeight: index == restController.categoryIndex ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ) : SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                              height: 10, width: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),

                  ProductViewWidget(
                    scrollController: _scrollController,
                    type: restController.selectedFoodType,
                    onVegFilterTap: (String type) {
                      Get.find<RestaurantController>().getProductList(offset: '1', foodType: type, stockType: restController.selectedStockType, categoryId: restController.categoryId);
                    },
                  ),
                ]),
              ),
            ) : const Center(child: CircularProgressIndicator()),
          ]),
        );
      });
    });
  }
}