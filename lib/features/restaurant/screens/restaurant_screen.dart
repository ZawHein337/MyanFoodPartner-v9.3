import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/announcement_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/filter_data_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    if(Get.find<ProfileController>().profileModel != null) {
      _initRestaurantData();
    } else {
      Get.find<ProfileController>().getProfile().then((_) {
        if(mounted && Get.find<ProfileController>().profileModel != null) {
          setState(_initRestaurantData);
        }
      });
    }
  }

  void _initRestaurantData() {
    final Restaurant restaurant = Get.find<ProfileController>().profileModel!.restaurants![0];

    _tabController = TabController(length: (restaurant.reviewsSection ?? false) ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController!.index);
    });
    Get.find<RestaurantController>().resetCategorySelection();
    Get.find<RestaurantController>().getProductList(offset: '1', foodType: 'all', stockType: 'all', categoryId: 0, isUpdate: false);
    Get.find<RestaurantController>().getRestaurantReviewList(restaurant.id, '');
    Get.find<RestaurantController>().getRestaurantCategories();
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
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        if(profileController.profileModel == null) {
          return Scaffold(
            appBar: CustomAppBarWidget(title: 'my_restaurant'.tr, isBackButtonExist: false),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        Restaurant restaurant = profileController.profileModel!.restaurants![0];
        bool isFilterActive = restController.selectedFoodType != 'all' || restController.selectedStockType != 'all';

        return (profileController.modulePermission?.myRestaurant ?? false) ? Scaffold(
          appBar: CustomAppBarWidget(title: 'my_restaurant'.tr, isBackButtonExist: false),

          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverToBoxAdapter(
                child: Stack(children: [

                  Container(
                    margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    padding: EdgeInsets.all(3),
                    height: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(children: [

                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault), topRight: Radius.circular(Dimensions.radiusDefault)),
                          child: CustomImageWidget(
                            fit: BoxFit.cover, placeholder: Images.restaurantCover,
                            image: '${restaurant.coverPhotoFullUrl}',
                            width: context.width,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Column(children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 105, top: 12, right: 12, bottom: 5),
                            child: Row(children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Row(children: [
                                    Flexible(
                                      child: Text(
                                        restaurant.name ?? '', style: robotoBold,
                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (restaurant.verifiedSeller == true) ...[
                                      const SizedBox(width: 4),
                                      Tooltip(
                                        message: 'verified_restaurant'.tr,
                                        preferBelow: false,
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: const Icon(Icons.verified, color: Color(0xFF1DA1F2), size: 18),
                                      ),
                                    ],
                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    '${'created_at'.tr} ${DateConverter.utcToDate(restaurant.createdAt ?? '')}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),

                                ]),
                              ),
                              SizedBox(width: Dimensions.paddingSizeSmall),

                              InkWell(
                                onTap: () {
                                  Get.toNamed(RouteHelper.getRestaurantEditRoute(restaurant));
                                },
                                child: CustomAssetImageWidget(image:Images.editIcon, height: 30, width: 30),
                              ),
                            ]),
                          ),

                          SizedBox(
                            height: 103,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(children: [
                                  CountCardWidget(title: 'products'.tr, icon: Images.productCountIcon, count: profileController.profileModel?.productCount ?? 0, color: Color(0xFF2196F3)),
                                  SizedBox(width: Dimensions.paddingSizeSmall),

                                  CountCardWidget(title: 'orders'.tr, icon: Images.orderCountIcon, count: profileController.profileModel?.orderCount ?? 0),
                                  SizedBox(width: Dimensions.paddingSizeSmall),

                                  CountCardWidget(title: 'reviews'.tr, icon: Images.reviewCountIcon, count: profileController.profileModel?.reviewCount ?? 0, color: Color(0xFF528C41)),
                                ]),
                              ),
                            ),
                          ),


                        ]),
                      ),

                    ]),
                  ),

                  Positioned(
                    top: 80, left: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          image: '${restaurant.logoFullUrl}',
                          height: 70, width: 70, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                ]),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Image.asset(Images.announcementIcon, height: 40, width: 40),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'make_an_announcement'.tr,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          ),

                          Text(
                            'this_will_be_shown_in_the_user_app_web'.tr,
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    TextButton(
                      onPressed: () {
                        showCustomBottomSheet(child: AnnouncementBottomSheet(announcementStatus: restaurant.isAnnouncementActive!, announcementMessage: restaurant.announcementMessage ?? ''));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), side: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.5))),
                      ),
                      child: Text('create'.tr, style: robotoRegular),
                    ),
                  ]),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeDefault)),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  restaurant.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(
                        '${restaurant.discount!.discount}% ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),

                      Text(
                        '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(height: (restaurant.discount!.minPurchase != 0 || restaurant.discount!.maxDiscount != 0) ? 5 : 0),

                      restaurant.discount!.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                      restaurant.discount!.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                    ]),
                  ) : const SizedBox(),

                  (restaurant.delivery! && restaurant.freeDelivery!) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ) : const SizedBox(),

                ]),
              ))),

              (profileController.modulePermission?.food ?? false) ? SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Column(children: [
                      SizedBox(height: restController.isTitleVisible ? 10 : 0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text('all_foods'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 20),

                          InkWell(
                            onTap: () {
                              showCustomBottomSheet(child: const FilterDataBottomSheet());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                color: isFilterActive ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.tune, color:isFilterActive ? Theme.of(context).cardColor : Theme.of(context).primaryColor),
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      restController.categoryNameList != null ? SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restController.categoryNameList!.length,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
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
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
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

                    ]),
                  ),
                ),
              ) : const SliverToBoxAdapter(child: SizedBox()),

              (profileController.modulePermission?.food ?? false) ? SliverToBoxAdapter(
                child: ProductViewWidget(scrollController: _scrollController, type: restController.selectedFoodType, onVegFilterTap: (String type) {
                  Get.find<RestaurantController>().getProductList(offset: '1', foodType: type, stockType: restController.selectedStockType, categoryId: restController.categoryId);
                }),
              ) : const SliverToBoxAdapter(child: SizedBox()),

            ],
          ),
        ) : Scaffold(
          body: Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)),
        );
      });
    });
  }
}

class CountCardWidget extends StatelessWidget {
  final String title;
  final String icon;
  final int count;
  final Color? color;
  const CountCardWidget({super.key, required this.title, required this.icon, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),

          CustomAssetImageWidget(image: icon, height: 20, width: 20),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(count.toString(), style: robotoBold.copyWith(fontSize: 20, color: color ?? Theme.of(context).primaryColor)),
      ]),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 100 || oldDelegate.minExtent != 100 || child != oldDelegate.child;
  }
}