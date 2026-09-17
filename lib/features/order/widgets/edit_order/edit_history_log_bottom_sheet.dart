import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class EditHistoryLogBottomSheet extends StatelessWidget {
  const EditHistoryLogBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
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

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.highlight_remove, color: Theme.of(context).hintColor.withValues(alpha: 0.8), size: 27),
              ),
            ),
          ),

          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Text('edit_history_log'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            SizedBox(height: Dimensions.paddingSizeSmall),

            RichText(text: TextSpan(children: [
              TextSpan(text: '${'order_id'.tr}: ', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
              TextSpan(text: '# ${orderController.orderModel?.id}', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ])),

          ]),

          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
              child: SingleChildScrollView(
                child: ListView.builder(
                  itemCount: orderController.orderModel?.orderEditLogs?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(children: [

                        Text('${index + 1}'),
                        SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: Text(
                            orderController.orderModel?.orderEditLogs?[index].log?.tr ?? '',
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(
                          DateConverter.dateTimeToDayMonthAndTime(orderController.orderModel!.orderEditLogs![index].createdAt!),
                          style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                        ),

                      ]),
                    );
                  },
                ),
              ),
            ),
          ),

        ]),
      );
    });
  }
}
