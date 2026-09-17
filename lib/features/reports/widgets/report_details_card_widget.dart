import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/order/widget/order_transaction_details_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/extensions_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDetailsCardWidget extends StatelessWidget {
  final Orders orders;
  final bool isCampaign;
  const ReportDetailsCardWidget({super.key, required this.orders, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showCustomBottomSheet(
          child: OrderTransactionDetailsBottomSheetWidget(orders: orders),
        );
      },
      child: Container(
        width: context.width, height: 145,
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

              Text('${'order'.tr} # ${orders.orderId}', style: robotoBold),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('view_details'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline, decorationColor: Colors.blue)),
              ),

            ]),
          ),

          Divider(height: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.6)),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Row(children: [
                      Text('${'payment_status'.tr} - ' , style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                      Text(orders.paymentStatus!.replaceAll('_', ' ').toCapitalized(),
                        style: robotoMedium.copyWith(color: orders.paymentStatus == 'paid' ? Colors.green : orders.paymentStatus == 'unpaid' ? Colors.red : Colors.blue),
                      ),
                    ]),

                    Text('${'payment_method'.tr} -', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                    Text(orders.paymentMethod.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),

                  ]),
                ),

                Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text('order_amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(PriceConverter.convertPrice(orders.orderAmount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.blue)),

                ]),
              ]),
            ),
          ),

        ]),
      ),
    );
  }
}