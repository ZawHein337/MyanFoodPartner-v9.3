import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/food/widget/food_report_details_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodReportDetailsCardWidget extends StatelessWidget {
  final Foods foods;
  const FoodReportDetailsCardWidget({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showCustomBottomSheet(
          child: FoodOrderDetailsBottomSheetWidget(foods: foods),
        );
      },
      child: Container(
        width: context.width, height: 120,
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
        ),
        child: Column(children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Flexible(child: Text(foods.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium)),
              const SizedBox(width: Dimensions.paddingSizeLarge),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('view_details'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline, decorationColor: Colors.blue)),
              ),

            ]),
          ),

          Divider(height: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: Row(children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Row(children: [
                      Text('${'total_order'.tr} : ' , style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6))),
                      Text(foods.totalOrderCount.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),

                  ]),
                ),

                Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text('price'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(PriceConverter.convertPrice(foods.unitPrice), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.blue)),

                ]),
              ]),
            ),
          ),

        ]),
      ),
    );
  }
}