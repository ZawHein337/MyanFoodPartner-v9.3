import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/withdraw_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawWidget extends StatelessWidget {
  final WithdrawModel withdrawModel;
  final bool showDivider;
  const WithdrawWidget({super.key, required this.withdrawModel, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(PriceConverter.convertPrice(withdrawModel.amount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textDirection: TextDirection.ltr,),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text('${'transferred_to'.tr} ${withdrawModel.bankName}', style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall, color: const Color(0xff9DA7BC),
            )),

          ])),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
              decoration: BoxDecoration(
                color: withdrawModel.status == 'Pending' ? Colors.blue.withValues(alpha: 0.1) : withdrawModel.status == 'Approved' ? Colors.green.withValues(alpha: 0.1) : withdrawModel.status == 'Denied' ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1) : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(withdrawModel.status!.tr, style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: withdrawModel.status == 'Pending' ? Colors.blue : withdrawModel.status == 'Approved' ? Colors.green : withdrawModel.status == 'Denied' ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor,
              )),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              DateConverter.convertDateToDate(withdrawModel.requestedAt!),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xff9DA7BC)),
            ),

          ]),

        ]),
      ),

      Divider(color: showDivider ? Theme.of(context).hintColor : Colors.transparent),

    ]);
  }
}