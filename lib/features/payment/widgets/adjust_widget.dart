import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AdjustWidget extends StatelessWidget {
  final ProfileController profileController;
  final PaymentController paymentController;
  const AdjustWidget({super.key, required this.profileController, required this.paymentController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        border: Border.all(color: Colors.red, width: 0.1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Row(children: [
        Image.asset(Images.moneyButton, color: Colors.red, scale: 3.5),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(profileController.profileModel!.dynamicBalanceType!, style: robotoRegular.copyWith()),

            Text(PriceConverter.convertPrice(profileController.profileModel!.dynamicBalance!), style: robotoBold.copyWith()),
          ]),
        ),

        InkWell(
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
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeSmall,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Text(
              'adjust'.tr,
              style: robotoMedium.copyWith(color: Colors.red),
            ),
          ),
        ),
      ]),
    );
  }
}
