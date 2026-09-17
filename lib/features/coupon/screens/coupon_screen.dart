import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/widgets/coupon_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/add_coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/widgets/coupon_card_dialogue_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<CouponController>().getCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'coupon_list'.tr),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: InkWell(
          focusColor: Colors.transparent,
          onTap: () => Get.to(() => const AddCouponScreen()),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
              border: Border.all(color: Theme.of(context).cardColor, width: 4),
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 25),
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          await Get.find<CouponController>().getCouponList();
        },
        child: GetBuilder<CouponController>(builder: (couponController) {
          return couponController.couponList != null ? couponController.couponList!.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            itemCount: couponController.couponList!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: InkWell(
                onTap: (){
                  Get.bottomSheet(CouponCardDialogueWidget(couponBody: couponController.couponList![index], index: index), isScrollControlled: true);
                },
                child: SizedBox(
                  height: 150,
                  child: Stack(children: [

                    Transform.rotate(
                      angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                        ),
                        child: Image.asset(Images.couponBgDark, fit: BoxFit.fill, color: Get.isDarkMode ? Colors.black : null),
                      ),
                    ),

                    Row(children: [

                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            Center(child: Image.asset(couponController.couponList![index].discountType == 'percent' ? Images.couponVertical : Images.cashIcon, height: 35, width: 35)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text('${'${couponController.couponList![index].couponType == 'free_delivery' ? 'free_delivery'.tr : couponController.couponList![index].discountType != 'percent' ?
                            PriceConverter.convertPrice(double.parse(couponController.couponList![index].discount.toString())) :
                            couponController.couponList![index].discount}'} ${couponController.couponList![index].couponType == 'free_delivery' ? '' : couponController.couponList![index].discountType == 'percent' ? '% ' : ''}'
                                '${couponController.couponList![index].couponType == 'free_delivery' ? '' : 'off'.tr}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text('on ${Get.find<ProfileController>().profileModel!.restaurants?[0].name ?? ''}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

                          ]),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                            Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton(
                                itemBuilder: (context) {
                                  bool status = couponController.couponList![index].status == 1 ? true : false;
                                  return <PopupMenuEntry>[

                                    PopupMenuItem(
                                      value: 'status',
                                      child: Column(
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text('status'.tr, style: robotoMedium),

                                            Container(
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: status ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                              ),
                                              padding: const EdgeInsets.all(1),
                                              child: Align(
                                                alignment: status ? Alignment.centerRight : Alignment.centerLeft,
                                                child: Container(
                                                  height: 20, width: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context).cardColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),
                                          const Divider(height: 1),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: 'view',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('view'.tr, style: robotoMedium),

                                          const Icon(Icons.remove_red_eye, size: 20),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('edit_coupon'.tr, style: robotoMedium),

                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                                          ),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('delete_coupon'.tr, style: robotoMedium),

                                          Icon(CupertinoIcons.trash_fill, color: Theme.of(context).colorScheme.error, size: 20),
                                        ],
                                      ),
                                    ),

                                  ];
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                offset: const Offset(-20, 20),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Icon(Icons.more_vert, size: 20, color: Theme.of(context).primaryColor),
                                ),
                                onSelected: (dynamic value) {
                                  if(value == 'status'){
                                    bool status = couponController.couponList![index].status == 1 ? true : false;
                                    couponController.changeStatus(couponController.couponList![index].id, !status).then((success) {
                                      if(success){
                                        Get.find<CouponController>().getCouponList();
                                      }
                                    });
                                  }
                                  else if(value == 'view') {
                                    Get.bottomSheet(CouponCardDialogueWidget(couponBody: couponController.couponList![index], index: index), isScrollControlled: true);
                                  }
                                  else if(value == 'delete') {
                                    showCustomBottomSheet(
                                      child: CouponDeleteBottomSheet(
                                        couponId: couponController.couponList![index].id!,
                                      ),
                                    );
                                  }else{
                                    Get.dialog(const CustomLoaderWidget());
                                    couponController.getCouponDetails(couponController.couponList![index].id!).then((couponDetails) {
                                      Get.back();
                                      if(couponDetails != null) {
                                        Get.to(() => AddCouponScreen(coupon: couponDetails));
                                      }
                                    });
                                  }
                                }
                              ),
                            ),

                            Text(couponController.couponList![index].code!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            const SizedBox(height: 5),

                            FittedBox(
                              child: Text('${DateConverter.stringToLocalDateOnly(couponController.couponList![index].startDate!)}  ${'to'.tr} ${DateConverter.stringToLocalDateOnly(couponController.couponList![index].expireDate!)}',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            const SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('*', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                                Text('min_purchase'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6))),
                                Text(' ${PriceConverter.convertPrice(double.parse(couponController.couponList![index].minPurchase.toString()))}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                                ),
                              ],
                            ),

                          ]),
                        ),
                      ),

                    ]),

                  ]),
                ),
              ),
            );
          }) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CustomAssetImageWidget(image: Images.noCouponIcon, height: 50, width: 50),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('no_coupon_available'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),
          ])) : const Center(child: CircularProgressIndicator());
        }),
      ),

    );
  }
}
