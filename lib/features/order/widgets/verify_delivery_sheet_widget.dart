import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDeliverySheetWidget extends StatefulWidget {
  final int? orderID;
  final bool? verify;
  final bool cod;
  final double? orderAmount;
  const VerifyDeliverySheetWidget({super.key, required this.orderID, required this.verify, required this.orderAmount, required this.cod});

  @override
  State<VerifyDeliverySheetWidget> createState() => _VerifyDeliverySheetWidgetState();
}

class _VerifyDeliverySheetWidgetState extends State<VerifyDeliverySheetWidget> {

  @override
  void initState() {
    super.initState();

    Get.find<OrderController>().setOtp('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).hintColor,
              ),
            ),

            widget.verify! ? Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('otp_verification'.tr, style: robotoBold, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('enter_otp_number'.tr, style: robotoRegular, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              SizedBox(
                width: 200,
                child: MaterialPinField(
                  length: 4,
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  onChanged: (String text) => orderController.setOtp(text),
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.underlined,
                    cellSize: const Size(30, 30),
                    spacing: 0,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderWidth: 2,
                    focusedBorderWidth: 2,
                    fillColor: Theme.of(context).cardColor,
                    focusedFillColor: Colors.white,
                    filledFillColor: Theme.of(context).cardColor,
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    focusedBorderColor: Theme.of(context).primaryColor,
                    filledBorderColor: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    entryAnimation: MaterialPinAnimation.slide,
                    animationDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('collect_otp_from_customer'.tr, style: robotoRegular, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

            ]) : const SizedBox(),

            !orderController.isLoading ? CustomButtonWidget(
              buttonText: widget.verify! ? 'verify'.tr : 'ok'.tr,
              radius: Dimensions.radiusDefault,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              onPressed: (widget.verify! && orderController.otp.length != 4) ? null : () {
                if(widget.cod){
                  Get.find<OrderController>().updateOrderStatus(widget.orderID, 'delivered').then((success) {
                    if(success) {
                      Get.find<ProfileController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                    }
                  });
                } else {
                  Get.find<OrderController>().updateOrderStatus(widget.orderID, 'delivered').then((success) {
                    if(success) {
                      Get.find<ProfileController>().getProfile();
                      Get.find<OrderController>().getCurrentOrders();
                      Get.offAllNamed(RouteHelper.getInitialRoute());
                    }
                  });
                }

              },
            ) : const Center(child: CircularProgressIndicator()),

            widget.verify! ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'did_not_receive_user_notification'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
              ),

              orderController.hideNotificationButton ? const SizedBox() : InkWell(
                onTap: () => orderController.sendDeliveredNotification(widget.orderID),
                child: Text(
                  'resend_it'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                ),
              ),

            ]) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),

          ]),
        );
      }),
    );
  }
}