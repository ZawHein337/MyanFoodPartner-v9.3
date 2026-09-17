import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletAttentionAlertWidget extends StatelessWidget {
  final bool isOverFlowBlockWarning;
  const WalletAttentionAlertWidget({super.key, required this.isOverFlowBlockWarning});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.95,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: const Color(0xfffff1f1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [

          Image.asset(Images.attentionWarningIcon, width: 20, height: 20),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('attention_please'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black)),

        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        isOverFlowBlockWarning ? RichText(
          text: TextSpan(
            text: '${'over_flow_block_warning_message'.tr}  ',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {
                  showCustomBottomSheet(child: const PaymentMethodBottomSheetWidget(isWalletPayment: true));
                },
                text: 'pay_the_due'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ],
          ),
        ) : Text('over_flow_warning_message'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
      ]),
    );
  }
}