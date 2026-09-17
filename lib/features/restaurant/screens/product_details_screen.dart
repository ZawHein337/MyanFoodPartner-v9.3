import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/readmore_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/rating_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/update_stock_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final bool? isCampaign;
  const ProductDetailsScreen({super.key, required this.productId, this.isCampaign});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  bool haveSubscription = false;


  @override
  void initState() {
    super.initState();

    _getProductDetails();

    if(Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'){
      haveSubscription = Get.find<ProfileController>().profileModel!.subscription!.review == 1;
    }else{
      haveSubscription = true;
    }

    if(Get.find<ProfileController>().profileModel!.restaurants![0].reviewsSection!) {
      Get.find<RestaurantController>().getProductReviewList(widget.productId);
    }

  }

  Future<void> _getProductDetails() async{
    await Get.find<RestaurantController>().getProductDetails(widget.productId, willUpdate: false).then((itemDetails) {
      if(itemDetails != null){
        Get.find<RestaurantController>().setAvailability(itemDetails.status == 1);
        Get.find<RestaurantController>().setRecommended(itemDetails.recommendedStatus == 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: CustomAppBarWidget(title: 'food_details'.tr),

        body: SafeArea(
          child: GetBuilder<RestaurantController>(builder: (restController) {
            return restController.product != null ? Column(children: [

              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).hintColor,
                labelStyle: robotoBold,
                unselectedLabelStyle: robotoMedium,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: 'product_overview'.tr),
                  Tab(text: 'reviews'.tr),
                ],
              ),

              Expanded(child: TabBarView(
                children: [
                  productOverview(restController),
                  reviewsSection(restController),
                ],
              )),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                ),
                child: Row(
                  children: [

                    restController.product?.stockType != 'unlimited' && ((restController.product?.variations != null && restController.product!.variations!.isNotEmpty)) ? Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: CustomButtonWidget(
                          transparent: true,
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            Get.bottomSheet(
                              UpdateStockBottomSheet(product: restController.product!),
                            );
                          },
                          buttonText: 'update_stock'.tr,
                        ),
                      ),
                    ) : const SizedBox(),
                    SizedBox(width: restController.product?.stockType != 'unlimited' && ((restController.product?.variations != null && restController.product!.variations!.isNotEmpty)) ? Dimensions.paddingSizeDefault : 0),

                    Expanded(
                      child: CustomButtonWidget(
                        isLoading: restController.isProductLoading,
                        onPressed: () {
                          if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                            restController.getProductDetails(widget.productId, productClear: false).then((itemDetails) {
                              if(itemDetails != null){
                                Get.toNamed(RouteHelper.getAddProductRoute(itemDetails));
                              }
                            });
                          }else {
                            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                          }
                        },
                        buttonText: 'edit'.tr,
                      ),
                    ),

                  ],
                ),
              ),

            ]) : const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

  Widget productOverview(RestaurantController restController) {
    double? discount = (restController.product?.restaurantDiscount == 0 || (widget.isCampaign ?? false)) ? restController.product?.discount : restController.product?.restaurantDiscount;
    String? discountType = (restController.product?.restaurantDiscount == 0 || (widget.isCampaign ?? false)) ? restController.product?.discountType : 'percent';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          isBorder: false,
          borderRadius: Dimensions.radiusDefault,
          child: Row(children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: CustomImageWidget(
                    image: '${restController.product?.imageFullUrl}',
                    height: 80, width: 85, fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  right: 0, bottom: 0, left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.radiusDefault),
                        bottomRight: Radius.circular(Dimensions.radiusDefault),
                      ),
                    ),
                    child: Text(
                      '${restController.product?.discount} ${restController.product?.discountType == 'percent' ? '% ${'off'.tr}' : Get.find<SplashController>().configModel!.currencySymbol}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [

                Flexible(
                  child: Text(
                    restController.product?.name ?? '',
                    style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [
                Text(
                  PriceConverter.convertPrice(restController.product?.price, discount: discount, discountType: discountType),
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textDirection: TextDirection.ltr,
                ),
                SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                discount > 0 ? Text(
                  PriceConverter.convertPrice(restController.product?.price), textDirection: TextDirection.ltr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall- 3, color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough, decorationColor: Theme.of(context).hintColor),
                ) : const SizedBox(),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: 16),
                const SizedBox(width: 2),

                Text(
                  restController.product!.avgRating!.toStringAsFixed(1),
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  height: 12, width: 1, color: Theme.of(context).disabledColor,
                ),

                Text(
                  '${restController.product?.ratingCount ?? 0} ${'review'.tr}',
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: Colors.blue,
                    decoration: TextDecoration.underline, decorationColor: Colors.blue,
                    height: 1.3, fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [

                Icon(Icons.access_time_filled, color: Theme.of(context).disabledColor, size: 16),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(
                  '${DateConverter.convertStringTimeToTime(restController.product!.availableTimeStarts!)} - ${DateConverter.convertStringTimeToTime(restController.product!.availableTimeEnds!)}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

              ]),
            ])),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          isBorder: false,
          borderRadius: Dimensions.radiusDefault,
          child: Column(children: [
            Row(children: [

              Expanded(
                child: Text('available'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              ),

              FlutterSwitch(
                width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall,
                activeColor: Theme.of(context).primaryColor,
                value: restController.isAvailable, onToggle: (bool isActive) {
                restController.toggleAvailable(restController.product!.id);
              },
              ),

            ]),

            Divider(color: Theme.of(context).disabledColor, height: 40),

            Row(children: [

              Expanded(
                child: Text('recommended'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              ),

              FlutterSwitch(
                width: 60, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall,
                activeColor: Theme.of(context).primaryColor,
                value: restController.isRecommended, onToggle: (bool isActive) {
                restController.toggleRecommendedProduct(restController.product!.id);
              },
              ),

            ]),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          isBorder: false,
          borderRadius: Dimensions.radiusDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('description'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              ReadMoreText(
                restController.product!.description ?? '',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                trimMode: TrimMode.Line,
                trimLines: 3,
                colorClickableText: Colors.blue,
                lessStyle: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                trimCollapsedText: 'see_more'.tr,
                trimExpandedText: ' ${'see_less'.tr}',
                moreStyle: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline, decorationColor: Colors.blue),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          isBorder: false,
          borderRadius: Dimensions.radiusDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('general_info'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              restController.product!.categoryIds?[0].categoryName != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'category'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.categoryIds?[0].categoryName ?? '',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]) : const SizedBox(),
              restController.product!.categoryIds?[0].categoryName != null ? Divider(color: Theme.of(context).disabledColor, height: 30) : SizedBox(),

              restController.product!.categoryIds != null && restController.product!.categoryIds!.length > 1 && restController.product!.categoryIds?[1].categoryName != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'sub_category'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.categoryIds?[1].categoryName ?? '',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]) : const SizedBox(),
              restController.product!.categoryIds != null && restController.product!.categoryIds!.length > 1 && restController.product!.categoryIds?[1].categoryName != null ? Divider(color: Theme.of(context).disabledColor, height: 30) : SizedBox(),

              (Get.find<SplashController>().configModel?.restaurantCategoryStatus ?? false) && restController.product!.restaurantCategoryId != null && restController.product!.restaurantCategoryName != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'restaurant_category'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.restaurantCategoryName ?? '',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]) : const SizedBox(),
              (Get.find<SplashController>().configModel?.restaurantCategoryStatus ?? false) && restController.product!.restaurantCategoryId != null && restController.product!.restaurantCategoryName != null ? Divider(color: Theme.of(context).disabledColor, height: 30) : SizedBox(),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'food_type'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              (restController.product!.isHalal! == 1) && (restController.product!.halalTagStatus == 1) ? Divider(color: Theme.of(context).disabledColor, height: 30) : SizedBox(),

              (restController.product!.isHalal! == 1) && (restController.product!.halalTagStatus == 1) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'halal_tag'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  'yes'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]) : SizedBox(),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          isBorder: false,
          borderRadius: Dimensions.radiusDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('price_information'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'price'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  PriceConverter.convertPrice(restController.product!.price),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              Divider(color: Theme.of(context).disabledColor, height: 30),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'discount_type'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.discountType!.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              Divider(color: Theme.of(context).disabledColor, height: 30),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'discount_amount'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text(
                  restController.product!.discountType == 'percent' ? '${restController.product!.discount} %' : PriceConverter.convertPrice(restController.product!.discount),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        (restController.product!.variations != null && restController.product!.variations!.isNotEmpty) ? Column(children: [
          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('variations'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),

                restController.product!.stockType == 'unlimited' ? CustomToolTip(
                  message: 'your_main_stock_is_empty_variations_stock_will_not_work_if_the_main_stock_is_empty'.tr,
                  preferredDirection: AxisDirection.down,
                ) : const SizedBox(),

              ]),
              const SizedBox(height:Dimensions.paddingSizeSmall),

              ListView.builder(
                itemCount: restController.product!.variations!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      ListView.builder(
                        itemCount: restController.product!.variations![index].variationValues!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {

                          return Column(children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  '${restController.product!.variations![index].name!} - ${restController.product!.variations![index].variationValues![i].level}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text(PriceConverter.convertPrice(_convertStringToDouble(restController.product!.variations![index].variationValues![i].optionPrice!)), textDirection: TextDirection.ltr,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                ),
                              ]),

                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                                restController.product?.itemStock != 0 ?  Text(
                                    'stock'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _convertStringToInt(restController.product!.variations![index].variationValues![i].currentStock!)! > 0
                                    ? Theme.of(context).hintColor : restController.product!.stockType == 'unlimited' ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.error)
                                ) :SizedBox.shrink(),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                restController.product?.itemStock != 0 ? Text(
                                  restController.product!.stockType == 'unlimited' ? 'unlimited'.tr : _convertStringToInt(restController.product!.variations![index].variationValues![i].currentStock!)! > 0
                                      ? restController.product!.variations![index].variationValues![i].currentStock! : '00',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _convertStringToInt(restController.product!.variations![index].variationValues![i].currentStock!)! > 0
                                      ? Theme.of(context).textTheme.bodyLarge?.color : restController.product!.stockType == 'unlimited' ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.error),
                                ) : SizedBox.shrink(),

                              ]),


                            ]),

                            i != restController.product!.variations![index].variationValues!.length - 1 ? const Divider() : const SizedBox(),
                          ]);
                        },
                      ),
                      index != restController.product!.variations!.length - 1 ? const Divider() : const SizedBox(),
                    ]),
                  );
                },
              ),
            ]),
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]) : const SizedBox(),

        restController.product!.addOns!.isNotEmpty ? Column(children: [
          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('addons'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Wrap(children: restController.product!.addOns!.map((addOn) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [

                    Text('${addOn.name!}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(
                      PriceConverter.convertPrice(addOn.price), textDirection: TextDirection.ltr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),

                  ]),
                );
              }).toList(),
              ),

            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]) : const SizedBox(),

        restController.product!.tags != null && restController.product!.tags!.isNotEmpty ? Column(children: [
          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('tags'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(
                height: 35,
                child: ListView.builder(
                  itemCount: restController.product!.tags!.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index == restController.product!.tags!.length-1 ? 0 : Dimensions.paddingSizeSmall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(restController.product!.tags?[index].tag ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      ),
                    );
                  },
                ),
              ),

            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]) : const SizedBox(),

        restController.product!.nutrition != null && restController.product!.nutrition!.isNotEmpty ? Column(children: [
          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('nutrition'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                restController.product!.nutrition!.join(', '),
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),

            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]) : const SizedBox(),

        restController.product!.allergies != null && restController.product!.allergies!.isNotEmpty ? Column(children: [
          CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('allergies'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                restController.product!.allergies!.join(', '),
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]) : const SizedBox(),

        if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise')
          (restController.product!.taxData != null && restController.product!.taxData!.isNotEmpty) ? CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            isBorder: false,
            borderRadius: Dimensions.radiusDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('vat_tax'.tr, style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                ListView.builder(
                  itemCount: restController.product!.taxData!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [

                        Text('${restController.product!.taxData?[index].name}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(
                          '(${restController.product!.taxData![index].taxRate} %)',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                      ]),
                    );
                  },
                ),
              ],
            ),
          ) : const SizedBox(),
        if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise')
          SizedBox(height: restController.product!.taxData != null && restController.product!.taxData!.isNotEmpty ? Dimensions.paddingSizeDefault : 0),


      ]),
    );
  }

  Widget reviewsSection(RestaurantController restController) {
    if(!Get.find<ProfileController>().profileModel!.restaurants![0].reviewsSection!) {
      return Center(child: Text('this_feature_is_blocked_by_admin'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)));
    }
    return GetBuilder<RestaurantController>(builder: (restController) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            RatingWidget(
              averageRating: restController.productReview?.avgRating ?? 0,
              ratingCount: restController.productReview?.ratingCount ?? 0,
              reviewCommentCount: 0,
              ratings: restController.productReview?.rating ?? [0,0,0,0,0,0],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('review_list'.tr, style: robotoBold),
            ),

            haveSubscription ? restController.productReview != null && restController.productReview!.reviews != null ? restController.productReview!.reviews!.isNotEmpty ? ListView.builder(
              itemCount: restController.productReview!.reviews!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ReviewModel review = restController.productReview!.reviews![index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Colors.black12.withValues(alpha: 0.05), blurRadius: 5, spreadRadius: 1)],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomImageWidget(image: review.customer?.imageFullUrl??'', height: 40, width: 40, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(review.customer != null ? '${review.customer?.fName??''} ${review.customer?.lName??''}' : 'customer_not_found'.tr, style: robotoMedium),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          RatingBarWidget(rating: review.rating!.toDouble(), ratingCount: null),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        ])),

                        Column(children: [
                          Text('${'order'.tr} #${review.orderId}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(DateConverter.convertDateToDate(review.createdAt!), style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),

                        ]),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      ReadMoreText(
                        review.comment ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        trimMode: TrimMode.Line,
                        trimLines: 4,
                        colorClickableText: Colors.blue,
                        lessStyle: robotoRegular.copyWith(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                        trimCollapsedText: 'see_more'.tr,
                        trimExpandedText: ' ${'see_less'.tr}',
                        moreStyle: robotoRegular.copyWith(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                      ),
                    ],
                  ),
                );
              },
            ) : Center(child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
            ))
                : Center(child: SizedBox(width: context.width * 0.6, child: const LinearProgressIndicator()))
                : Center(child: Text('not_available_subscription_for_reviews'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall))),

          ],
        ),
      );
    });
  }

  double? _convertStringToDouble(String? price) {
    if (price == null) return null;
    try {
      return double.parse(price);
    } catch (e) {
      return null;
    }
  }

  int? _convertStringToInt(String? value) {
    if (value == null) return null;
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }

}