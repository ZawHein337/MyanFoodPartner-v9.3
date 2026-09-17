import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;
  const OrderWidget({super.key, required this.orderModel, required this.hasDivider, required this.isRunning, this.showStatus = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(orderModel.id), arguments: OrderDetailsScreen(
        orderModel: orderModel, isRunningOrder: isRunning, orderId: orderModel.id!,
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
        ),
        child: Column(children: [

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text('order'.tr, style: robotoMedium),
                  Text(' # ${orderModel.id}', style: robotoBold),
                  Text(' (${orderModel.detailsCount} ${orderModel.detailsCount! < 2 ? 'item'.tr : 'items'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                ]),

                showStatus ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: orderModel.orderStatus == 'delivered' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    orderModel.orderType == 'dine_in' && orderModel.orderStatus == 'delivered' ? 'served'.tr : orderModel.orderStatus!.tr,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: orderModel.orderStatus == 'delivered' ? Colors.green : Colors.red,
                    ),
                  ),
                ) : const SizedBox(),

                const Spacer(),


              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  DateConverter.beforeTimeFormat(orderModel.createdAt!),
                  // getChatTime(orderModel.createdAt!),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  orderModel.orderType == 'delivery' ? 'home_delivery'.tr : orderModel.orderType!.tr,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: orderModel.orderType == 'delivery' ? Colors.blue : Theme.of(context).primaryColor,
                  ),
                ),

              ])),

              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  orderModel.paymentMethod == 'cash_on_delivery' ? 'amount'.tr
                      : orderModel.paymentMethod == 'wallet' ? 'wallet_payment'.tr : orderModel.paymentMethod == 'cash' ? 'cash'.tr
                      : orderModel.paymentMethod == 'digital_payment' ? 'digital_payment'.tr : orderModel.paymentMethod?.replaceAll('_', ' ')??'',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  PriceConverter.convertPrice(orderModel.orderAmount),
                  style: robotoBold,
                ),

              ]),

              // showStatus ? const SizedBox() : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),

            ]),
          ),

          // hasDivider ? Divider(color: Theme.of(context).hintColor) : const SizedBox(),

        ]),
      ),
    );
  }
}