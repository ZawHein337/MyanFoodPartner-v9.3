import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_request_bottom_sheet_widget.dart';

class WithdrawalWidget extends StatelessWidget {
  final ProfileController profileController;
  final PaymentController paymentController;
  const WithdrawalWidget({super.key, required this.profileController, required this.paymentController});

  @override
  Widget build(BuildContext context) {

    bool isPayNow = (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Row(children: [
        Image.asset(Images.walletBold, color: Theme.of(context).cardColor, scale: 1.5,),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isPayNow ? 'payable_balance'.tr : 'withdrawal_balance'.tr, style: robotoRegular.copyWith(color: Theme.of(context).cardColor)),

            Text(PriceConverter.convertPrice(isPayNow ? profileController.profileModel!.cashInHands : profileController.profileModel!.balance), style: robotoBold.copyWith(color: Theme.of(context).cardColor)),
          ]),
        ),

        isPayNow ? PayNowButton(profileController: profileController) : WithdrawButton(
          paymentController: paymentController, profileController: profileController,
        ),
      ]),
    );
  }
}

class PayNowButton extends StatelessWidget {
  final ProfileController profileController;
  final double? width;
  const PayNowButton({super.key, required this.profileController, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(profileController.profileModel!.showPayNowButton!){
          showCustomBottomSheet(child: const PaymentMethodBottomSheetWidget(isWalletPayment: true));
        }else {
          if(Get.find<SplashController>().configModel!.activePaymentMethodList!.isEmpty || !Get.find<SplashController>().configModel!.digitalPayment!){
            showCustomSnackBar('currently_there_are_no_payment_options_available_please_contact_admin_regarding_any_payment_process_or_queries'.tr);
          }else if(Get.find<SplashController>().configModel!.minAmountToPayRestaurant! > profileController.profileModel!.cashInHands!){
            showCustomSnackBar('${'you_do_not_have_sufficient_balance_to_pay_the_minimum_payable_balance_is'.tr} ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.minAmountToPayRestaurant)}');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: profileController.profileModel!.showPayNowButton! ? Theme.of(context).cardColor : Theme.of(context).hintColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Text('pay_now'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
      ),
    );
  }
}

class WithdrawButton extends StatelessWidget {
  final PaymentController paymentController;
  final ProfileController profileController;
  final double? width;
  const WithdrawButton({super.key, required this.paymentController, required this.profileController, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(paymentController.widthDrawMethods != null && paymentController.widthDrawMethods!.isNotEmpty) {
          Get.bottomSheet(const WithdrawRequestBottomSheetWidget(), isScrollControlled: true);
        }else {
          showCustomSnackBar('currently_no_bank_account_added'.tr);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Text('withdraw'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
      ),
    );
  }
}