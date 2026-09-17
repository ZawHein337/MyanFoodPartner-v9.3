import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/tax_report_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/extensions_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class TaxReportBottomSheet extends StatelessWidget {
  final OrdersModel? orderList;
  const TaxReportBottomSheet({super.key, this.orderList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(width: 40),

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          InkWell(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.highlight_remove, color: Theme.of(context).disabledColor, size: 25),
            ),
          ),

        ]),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Text('${'order_id'.tr} #${orderList?.id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

            Text(DateConverter.dateTimeToDayMonthAndTime(orderList!.createdAt!), style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

            orderList!.orderTaxes!.isNotEmpty ? Wrap(
              alignment: WrapAlignment.end,
              children: List.generate(
                orderList!.orderTaxes?.length ?? 0,
                    (i) => Padding(
                  padding: EdgeInsets.only(right: i == (orderList!.orderTaxes?.length ?? 0) - 1 ? 0 : Dimensions.paddingSizeSmall),
                  child: Text(
                    '${orderList!.orderTaxes?[i].taxName?.toTitleCase()} ${i == (orderList!.orderTaxes?.length ?? 0) - 1 ? '' : ','}',
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6)),
                  ),
                ),
              ),
            ) : Text('no_tax'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6))),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(children: [

                Text('${'payment'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(PriceConverter.convertPrice(orderList?.orderAmount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(orderList!.paymentStatus?.toTitleCase() ?? '', style: robotoBold.copyWith(color: Colors.green)),
                ),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(children: [

                Column(
                  children: List.generate(
                    orderList?.orderTaxes?.length ?? 0,
                    (index) => Column(children: [

                      Row(children: [
                        Text(orderList!.orderTaxes?[index].taxName?.toTitleCase() ?? '', style: robotoRegular),
                        const Spacer(),

                        Text(PriceConverter.convertPrice(orderList!.orderTaxes?[index].taxAmount ?? 0), style: robotoRegular),
                      ]),

                      if (index != (orderList?.orderTaxes?.length ?? 0) - 1) const SizedBox(height: Dimensions.paddingSizeDefault),
                    ]),
                  ),
                ),

                /*Row(children: [
                  Text('vat'.tr, style: robotoRegular),
                  const Spacer(),

                  Text(PriceConverter.convertPrice(1333), style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(children: [
                  Text('GST'.tr, style: robotoRegular),
                  const Spacer(),

                  Text(PriceConverter.convertPrice(1333), style: robotoRegular),
                ]),*/

                Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  height: Dimensions.paddingSizeLarge,
                ),

                Row(children: [
                  Text('total_vat_amount'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const Spacer(),

                  Text(PriceConverter.convertPrice(orderList?.totalTaxAmount ?? 0), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),

              ]),
            ),

          ]),
        ),


      ]),
    );
  }
}
