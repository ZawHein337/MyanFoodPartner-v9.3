import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final bool success;
  final bool isWalletPayment;
  const PaymentSuccessfulScreen({super.key, required this.success, required this.isWalletPayment});

  @override
  State<PaymentSuccessfulScreen> createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {

  @override
  void initState() {
    _loadTrialWidgetShow();
    super.initState();
  }

  Future<void> _loadTrialWidgetShow() async {
    await Get.find<ProfileController>().trialWidgetShow(route: RouteHelper.success);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        Get.find<ProfileController>().trialWidgetShow(route: '');
        if(widget.isWalletPayment) {
          Future.delayed(const Duration(milliseconds: 2), () => Get.offAllNamed(RouteHelper.getInitialRoute()));
        }else {
          Future.delayed(const Duration(milliseconds: 2), () => Get.offAllNamed(RouteHelper.getSignInRoute()));
        }
      },
      child: Scaffold(

        appBar: const CustomAppBarWidget(title: '', isBackButtonExist: false),

        body: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Image.asset(widget.success ? Images.checked : Images.warning, width: 100, height: 100, color: widget.success ? Theme.of(context).primaryColor : null),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            widget.success ? 'your_payment_is_successfully_done'.tr : 'your_payment_is_not_done'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(buttonText: 'okay'.tr, onPressed: () {

              Get.find<ProfileController>().trialWidgetShow(route: '');

              if(widget.isWalletPayment) {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }else {
                Get.offAllNamed(RouteHelper.getSignInRoute());
              }
            }),
          ),

        ])),
      ),
    );
  }
}