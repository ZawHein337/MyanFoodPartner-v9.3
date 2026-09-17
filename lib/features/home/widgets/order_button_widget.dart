import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class OrderButtonWidget extends StatelessWidget {
  final String title;
  final int index;
  final OrderController orderController;
  final bool fromHistory;
  final int? orderCount;
  const OrderButtonWidget({super.key, required this.title, required this.index, required this.orderController, required this.fromHistory, this.orderCount});

  @override
  Widget build(BuildContext context) {

    int selectedIndex;
    int length = 0;

    if(fromHistory) {
      selectedIndex = orderController.historyIndex;
      length = 0;
    }else {
      selectedIndex = orderController.orderIndex;
      length = orderController.getRunningOrderCount(index);
    }

    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => fromHistory ? orderController.setHistoryIndex(index) : orderController.setOrderIndex(index),
      child: Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.1),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                title,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: isSelected ? Theme.of(context).cardColor.withValues(alpha: 0.2) : Theme.of(context).cardColor.withValues(alpha: 0.4),
                ),
                child: Text(
                  fromHistory ? orderCount.toString() : length.toString(),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}