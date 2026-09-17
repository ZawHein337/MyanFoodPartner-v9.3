import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/add_coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/widgets/coupon_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponCardDialogueWidget extends StatelessWidget {
  final CouponBodyModel couponBody;
  final int index;
  const CouponCardDialogueWidget({super.key, required this.couponBody, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [

                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: Icon(Icons.close, color: Theme.of(context).hintColor, size: 20),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        child: Row(children: [

                          SizedBox(
                            height: 50, width: 50,
                            child: Image.asset(couponBody.discountType == 'percent' ? Images.couponVertical : Images.cashIcon),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              '${couponBody.title}',
                              style: robotoMedium.copyWith(fontSize: 20), textDirection: TextDirection.ltr,
                            ),
                            Text(
                              '${DateConverter.stringToLocalDateOnly(couponBody.startDate!)} - ${DateConverter.stringToLocalDateOnly(couponBody.expireDate!)}',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6)),
                            ),
                          ]),
                          const Spacer(),

                          GetBuilder<CouponController>(builder: (couponController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                border: Border.all(color: Theme.of(context).disabledColor, width: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: Theme.of(context).primaryColor,
                                  value: couponController.couponList![index].status == 1 ? true : false,
                                  onChanged: (bool status){
                                    couponController.changeStatus(couponController.couponList![index].id, status).then((success) {
                                      if(success){
                                        couponController.getCouponList();
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }),

                        ]),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                border: Border.all(color: Theme.of(context).disabledColor, width: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Column(children: [
                                Text('discount'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5))),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text('${'${couponBody.couponType == 'free_delivery' ? 'free_delivery'.tr : couponBody.discountType != 'percent' ?
                                PriceConverter.convertPrice(double.parse(couponBody.discount.toString())) :
                                couponBody.discount}'} ${couponBody.couponType == 'free_delivery' ? '' : couponBody.discountType == 'percent' ? '% ' : ''}'
                                    '${couponBody.couponType == 'free_delivery' ? '' : 'off'.tr}',
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                                border: Border.all(color: Theme.of(context).disabledColor, width: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(children: [
                                      Text('coupon_code'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5))),
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                      Text(
                                        '${couponBody.code}',
                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                                      ),
                                    ]),
                                  ),

                                  IconButton(
                                    onPressed: (){
                                      Clipboard.setData(ClipboardData(text: couponBody.code!)).then((value) {
                                        showCustomSnackBar('coupon_code_copied'.tr);
                                      });
                                    },
                                    icon: Icon(Icons.copy, color: Colors.blue, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Column(children: [
                          section('total_user'.tr, '${couponBody.totalUses??0}'),
                          section('limit_for_same_user'.tr, '${couponBody.limit??0}'),
                          couponBody.discountType == 'percent' ? section('maximum_discount'.tr, PriceConverter.convertPrice(double.parse(couponBody.maxDiscount.toString()))) : const SizedBox.shrink(),
                          section('minimum_order_amount'.tr, PriceConverter.convertPrice(double.parse(couponBody.minPurchase.toString())), showDivider: false),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                    ]),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))]
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: GetBuilder<CouponController>(
                  builder: (couponController) {
                    return Row(children: [
                      Expanded(
                        child: CustomButtonWidget(
                          onPressed: () {
                            Get.back();
                            showCustomBottomSheet(
                              child: CouponDeleteBottomSheet(
                                couponId: couponController.couponList![index].id!,
                              ),
                            );
                          },
                          buttonText: 'delete'.tr,
                          color: Theme.of(context).disabledColor,
                          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(
                        child: CustomButtonWidget(
                          onPressed: () {
                            Get.back();
                            Get.to(()=> AddCouponScreen(coupon: couponController.couponList![index]));
                          },
                          buttonText: 'edit'.tr,
                        ),
                      ),
                    ]);
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget section(String title, String value, {bool showDivider = true}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text(
            title,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(Get.context!).hintColor),
          ),

          Text(
            value,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
        ]),
      ),
      if(showDivider)
        const Divider(height: 5),
    ]);
  }
}