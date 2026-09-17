import 'package:intl/intl.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TransactionStatusCardWidget extends StatelessWidget {
  final bool isCompleted;
  final bool isOnHold;
  final double amount;
  final JustTheController? completedToolTip;
  final JustTheController? onHoldToolTip;
  final JustTheController? canceledToolTip;
  const TransactionStatusCardWidget({super.key, this.isCompleted = false, this.isOnHold = false, required this.amount, this.completedToolTip, this.onHoldToolTip, this.canceledToolTip });

  @override
  Widget build(BuildContext context) {

    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';

    return Container(
      height: 240, width: 180,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(  children: [

        Align(alignment: Alignment.topRight, child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: isCompleted? Colors.green : isOnHold ? Colors.blue : Colors.red, shape: BoxShape.circle),
          child: JustTheTooltip(
            backgroundColor: Colors.black87,
            controller: isCompleted? completedToolTip : isOnHold ? onHoldToolTip : canceledToolTip,
            preferredDirection: AxisDirection.right,
            tailLength: 14,
            tailBaseWidth: 20,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isCompleted ? 'completed_tool_tip'.tr : isOnHold ? 'on_hold_tool_tip'.tr : 'canceled_tool_tip'.tr,
                style: robotoRegular.copyWith(color: Colors.white),
              ),
            ),
            child: InkWell(
              onTap: () {
                if(isCompleted) {
                  completedToolTip!.showTooltip();
                } else if(isOnHold) {
                  onHoldToolTip!.showTooltip();
                } else {
                  canceledToolTip!.showTooltip();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                child: Icon(Icons.info, color: isCompleted? Colors.green : isOnHold ? Colors.blue : Colors.red, size: 15,),
              ),
            ),
          ),

        )),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Stack(children: [

              Container(
                height: 50, width: 50,
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(color: isCompleted? Colors.green : isOnHold ? Colors.blue : Colors.red, shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(Images.transactionReportIcon),
                ),
              ),

              Positioned(
                right: 10, top: 10,
                child: Image.asset(
                  isOnHold ? Images.onHoldTransactionIcon : isCompleted ? Images.completeTransactionIcon : Images.cancelTransactionIcon,
                  height: 15, width: 15,
                ),
              ),

            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(
              '${isRightSide ? '' : '${Get.find<SplashController>().configModel!.currencySymbol!} '}'
                  '${NumberFormat.compact().format(amount)}''${isRightSide ? ' ${Get.find<SplashController>().configModel!.currencySymbol!}' : ''}',
              style: robotoBold.copyWith(
                fontSize: 20, color: isCompleted? Colors.green : isOnHold ? Colors.blue : Colors.red,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Text(
                isCompleted? "completed_transactions".tr : isOnHold? "on_hold_transactions".tr : "canceled_transactions".tr,
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),

          ]),
        ),
      ]),
    );
  }
}