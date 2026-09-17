import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/export_button.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/title_with_amount_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailsBottomSheetWidget extends StatelessWidget {
  final OrderTransactions orderTransactions;

  const TransactionDetailsBottomSheetWidget({super.key, required this.orderTransactions});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
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
            color: Theme.of(context).hintColor.withValues(alpha: 0.1),
            child: Column(children: [

              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Expanded(child: Text('transaction_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6)))),
                      ExportButton(
                        onTap: reportController.isLoading ? null : () => reportController.getTransactionReportStatementVew(orderTransactions.orderId!),
                        isLoading: reportController.isLoading,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text('${'order'.tr} # ${orderTransactions.orderId}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text('${'payment_status'.tr} - ', style: robotoRegular),
                    Text(orderTransactions.paymentStatus.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                        color: orderTransactions.paymentStatus.toString() == 'Completed' ? Colors.green : Colors.red)),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text('${'payment_method'.tr} - ', style: robotoRegular),
                    Text(orderTransactions.paymentMethod.toString(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Wrap(alignment: WrapAlignment.start, children: [
                    Text('${'amount_received_by'.tr} - ', style: robotoRegular),
                    Text(orderTransactions.amountReceivedBy.toString(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ]),

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

                  TitleWithAmountWidget(title: 'total_food_amount'.tr, amount: orderTransactions.totalItemAmount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'food_discount'.tr, amount: orderTransactions.itemDiscount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'coupon_discount'.tr, amount: orderTransactions.couponDiscount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'total_discount'.tr, amount: orderTransactions.discountedAmount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'vat_tax'.tr, amount: orderTransactions.vat ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'delivery_charge'.tr, amount: orderTransactions.deliveryCharge ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'order_amount'.tr, amount: orderTransactions.orderAmount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'admin_discount'.tr, amount: orderTransactions.adminDiscount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'restaurant_discount'.tr, amount: orderTransactions.restaurantDiscount ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'admin_commission'.tr, amount: orderTransactions.adminCommission ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'commission_on_delivery_charge'.tr, amount: orderTransactions.commissionOnDeliveryCharge ?? 0),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  TitleWithAmountWidget(title: 'restaurant_net_income'.tr, amount: orderTransactions.restaurantNetIncome ?? 0),

                ]),
              ),
            ),
          ),

        ]),
      );
    });
  }
}