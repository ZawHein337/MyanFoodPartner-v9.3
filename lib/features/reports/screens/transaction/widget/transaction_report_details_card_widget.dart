import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/widget/transaction_details_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionReportDetailsCardWidget extends StatelessWidget {
  final OrderTransactions orderTransactions;
  const TransactionReportDetailsCardWidget({super.key, required this.orderTransactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width, height: 145,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
      ),
      child: Column(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: -3, blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text('${'order'.tr} # ${orderTransactions.orderId}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true, useRootNavigator: true, context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                      topRight: Radius.circular(Dimensions.radiusExtraLarge),
                    ),
                  ),
                  builder: (context) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                      child: TransactionDetailsBottomSheetWidget(orderTransactions: orderTransactions),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault + 2),
                child: Text('view_details'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor)),
              ),
            ),

          ]),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [
                    Text('${'payment_status'.tr} - ' , style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                    Text(orderTransactions.paymentStatus.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: orderTransactions.paymentStatus.toString() == 'Completed' ?  Colors.green : Colors.red)),
                  ]),

                  Text('${'payment_method'.tr} -', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                  Text(orderTransactions.paymentMethod.toString(), style: robotoMedium),

                ]),
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                Text('net_income'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(PriceConverter.convertPrice(orderTransactions.restaurantNetIncome ?? 0), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),

              ]),
            ]),
          ),
        ),

      ]),
    );
  }
}