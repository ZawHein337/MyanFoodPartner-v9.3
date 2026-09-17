import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_request_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletCardWidget extends StatelessWidget {
  final ProfileController profileController;
  final PaymentController paymentController;
  const WalletCardWidget({super.key, required this.profileController, required this.paymentController});

  @override
  Widget build(BuildContext context) {
    return (profileController.profileModel!.adjustable! && (((profileController.profileModel!.balance! > 0) && (profileController.profileModel!.balance! > profileController.profileModel!.cashInHands!)
        && (Get.find<SplashController>().configModel!.disbursementType == 'manual')) || (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!))) ? Container(
      padding: const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).primaryColor,
      ),
      alignment: Alignment.center,
      child: Column(children: [

        ShowBalanceWidget(profileController: profileController),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Row(children: [

          profileController.profileModel!.adjustable! ? Expanded(child: AdjustPaymentButton(paymentController: paymentController)) : const SizedBox(),
          SizedBox(width: profileController.profileModel!.adjustable! ? Dimensions.paddingSizeSmall : 0),

          ((profileController.profileModel!.balance! > 0) && (profileController.profileModel!.balance! > profileController.profileModel!.cashInHands!)
              && (Get.find<SplashController>().configModel!.disbursementType == 'manual')) ? Expanded(child: WithdrawButton(
            paymentController: paymentController, profileController: profileController,
          )) : const SizedBox(),

          SizedBox(width: (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!) ? Dimensions.paddingSizeSmall : 0),

          (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!) ? Expanded(
            child: PayNowButton(
              profileController: profileController,
            ),
          ) : const SizedBox(),

        ]),

      ]),
    ) : Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).primaryColor,
      ),
      alignment: Alignment.center,
      child: Row(children: [

        Image.asset(Images.wallet, width: 60, height: 60),
        const SizedBox(width: Dimensions.paddingSizeLarge),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(profileController.profileModel!.dynamicBalanceType!, style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            PriceConverter.convertPrice(profileController.profileModel!.dynamicBalance!),
            style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
            textDirection: TextDirection.ltr,
          ),

        ])),

        Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          profileController.profileModel!.adjustable! ? AdjustPaymentButton(paymentController: paymentController, width: 115) : const SizedBox(),
          SizedBox(height: profileController.profileModel!.adjustable! ? Dimensions.paddingSizeLarge : 0),

          ((profileController.profileModel!.balance! > 0) && (profileController.profileModel!.balance! > profileController.profileModel!.cashInHands!)
              && (Get.find<SplashController>().configModel!.disbursementType == 'manual')) ? WithdrawButton(
            paymentController: paymentController, profileController: profileController,
            width: profileController.profileModel!.adjustable! ? 115 : null,
          ) : const SizedBox(),

          SizedBox(height: (profileController.profileModel!.balance! > 0 && profileController.profileModel!.balance! > profileController.profileModel!.cashInHands!
              && Get.find<SplashController>().configModel!.disbursementType == 'manual') ? Dimensions.paddingSizeSmall : 0),

          (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!) ? PayNowButton(
            profileController: profileController,
            width: profileController.profileModel!.adjustable! ? 115 : null,
          ) : const SizedBox(),

        ]),

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
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: profileController.profileModel!.showPayNowButton! ? Theme.of(context).cardColor : Theme.of(context).hintColor.withValues(alpha: 0.8),
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
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        child: Text('withdraw'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
      ),
    );
  }
}

class AdjustPaymentButton extends StatelessWidget {
  final PaymentController paymentController;
  final double? width;
  const AdjustPaymentButton({super.key, required this.paymentController, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) {
          return GetBuilder<PaymentController>(builder: (controller) {
            return AlertDialog(
              title: Center(child: Text('cash_adjustment'.tr)),
              content: Text('cash_adjustment_description'.tr, textAlign: TextAlign.center),
              actions: [
    
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
    
                    Expanded(
                      child: CustomButtonWidget(
                        onPressed: () => Get.back(),
                        color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        buttonText: 'cancel'.tr,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
    
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          paymentController.makeWalletAdjustment();
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: !controller.adjustmentLoading ? Text('ok'.tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),)
                              : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                        ),
                      ),
                    ),
    
                  ]),
                ),
    
              ],
            );
          });
        });
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        child: Text('adjust_payments'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: 13, color: Theme.of(context).primaryColor)),
      ),
    );
  }
}

class ShowBalanceWidget extends StatelessWidget {
  const ShowBalanceWidget({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
    
      Image.asset(Images.wallet, width: 60, height: 60),
      const SizedBox(width: Dimensions.paddingSizeLarge),
    
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    
        Text(profileController.profileModel!.dynamicBalanceType!, style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor, fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
    
        Text(
          PriceConverter.convertPrice(profileController.profileModel!.dynamicBalance!),
          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
          textDirection: TextDirection.ltr,
        ),
    
      ])),
    
    ]);
  }
}
