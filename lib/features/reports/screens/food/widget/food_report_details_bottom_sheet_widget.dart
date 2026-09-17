import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/title_with_amount_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodOrderDetailsBottomSheetWidget extends StatelessWidget {
  final Foods foods;
  const FoodOrderDetailsBottomSheetWidget({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge),
          topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Column(children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('item_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6))),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    SizedBox(width: context.width * 0.8, child: Text(foods.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('${'average_ratings'.tr} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                      Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: 18),

                      Text('${foods.averageRatings!.toStringAsFixed(1)}' ' ', style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),

                    ]),
                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                /*ExportButton(
                  onTap: () {

                  },
                ),*/


              ]),
            ),

          ]),
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('total_order'.tr, style: robotoRegular),

                  Text(foods.totalOrderCount.toString(), style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'order_amount'.tr, amount: foods.unitPrice ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_discount'.tr, amount: foods.totalDiscountGiven ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'average_sales_value'.tr, amount: foods.averageSaleValue ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_amount'.tr, amount: foods.totalAmountSold ?? 0),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}