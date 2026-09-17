import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/title_with_amount_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/extensions_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTransactionDetailsBottomSheetWidget extends StatelessWidget {
  final Orders orders;
  const OrderTransactionDetailsBottomSheetWidget({super.key, required this.orders});

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
                    Text('transaction_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6))),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Row(
                      children: [
                        Text('${'order'.tr} # ${orders.orderId}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text('(${orders.orderStatus?.replaceAll('_', ' ').toCapitalized()})', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('${'payment_status'.tr} - ' , style: robotoRegular),
                      Text(orders.paymentStatus!.replaceAll('_', ' ').toCapitalized(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: orders.paymentStatus == 'paid' ? Colors.green : orders.paymentStatus == 'unpaid' ? Colors.red : Colors.blue)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('${'payment_method'.tr} - ', style: robotoRegular),
                      Text(orders.paymentMethod!.replaceAll('_', ' ').toCapitalized(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('${'amount_received_by'.tr} - ', style: robotoRegular),
                      Text(orders.amountReceivedBy.toString(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
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

                TitleWithAmountWidget(title: 'item_amount'.tr, amount: (orders.tax ?? 0) + (orders.totalItemAmount ?? 0)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'item_discount'.tr, amount: orders.itemDiscount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'coupon_discount'.tr, amount: orders.couponDiscount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_discount'.tr, amount: orders.discountedAmount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: '${'vat_tax'.tr} (${Get.find<SplashController>().configModel!.taxIncluded == 1 ? 'included'.tr : 'exclude'.tr})', amount: orders.tax ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'delivery_charge'.tr, amount: orders.deliveryCharge ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'deliveryman_tips'.tr, amount: orders.deliverymanTips ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'additional_charge'.tr, amount: orders.additionalCharge ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_order_amount'.tr, amount: orders.orderAmount ?? 0),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}