import 'dart:async';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String? email;
  const VerificationScreen({super.key, required this.email});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {

  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    Get.find<ForgotPasswordController>().updateVerificationCode('', canUpdate: false);

    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'otp_verification'.tr),

      body: GetBuilder<ForgotPasswordController>(builder: (forgotPasswordController) {
        return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Flexible(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [

                  const CustomAssetImageWidget(
                    image: Images.otpVerificationBg,
                    height: 145, width: 160,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  SizedBox(
                    width: context.width * 0.75,
                    child: Text('submit_the_otp_code_sent_to_your_registered_mail_address_and_verify'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5)), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: MaterialPinField(
                      length: 4,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      onChanged: forgotPasswordController.updateVerificationCode,
                      theme: MaterialPinTheme(
                        shape: MaterialPinShape.outlined,
                        cellSize: const Size(55, 60),
                        spacing: 0,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderWidth: 1,
                        focusedBorderWidth: 1,
                        fillColor: Colors.white,
                        focusedFillColor: Colors.white,
                        filledFillColor: Colors.white,
                        borderColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
                        focusedBorderColor: Theme.of(context).primaryColor,
                        filledBorderColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
                        entryAnimation: MaterialPinAnimation.slide,
                        animationDuration: const Duration(milliseconds: 300),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Text(
                      'did_not_receive_the_code'.tr,
                      style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                    ),

                    !forgotPasswordController.isForgotLoading ? TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      onPressed: _seconds < 1 ? () {
                        forgotPasswordController.forgotPassword(widget.email).then((value) {
                          if (value.isSuccess) {
                            _startTimer();
                            showCustomSnackBar('resend_code_successful'.tr, isError: false);
                          } else {
                            showCustomSnackBar(value.message);
                          }
                        });
                      } : null,
                      child: Text('${_seconds > 0 ? '' : ' ${'resend'.tr}'}${_seconds > 0 ? '(${_seconds}s)' : ''}', style: TextStyle(color: Theme.of(context).primaryColor)),
                    ): const Row(children: [
                      SizedBox(width: 5),
                      SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2)),
                    ]),
                  ]),

                ]),
              ),
            ),
          ),

          GetBuilder<ForgotPasswordController>(builder: (forgotPasswordController) {
            return forgotPasswordController.verificationCode.length == 4 ? Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: forgotPasswordController.verificationCode.length == 4 ? !forgotPasswordController.isLoading ? CustomButtonWidget(
                buttonText: 'verify'.tr,
                onPressed: () {
                  forgotPasswordController.verifyToken(widget.email).then((value) {
                    if(value.isSuccess) {
                      Get.toNamed(RouteHelper.getResetPasswordRoute(widget.email, forgotPasswordController.verificationCode, 'reset-password'));
                    }else {
                      showCustomSnackBar(value.message);
                    }
                  });
                },
              ) : const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
            ) : const SizedBox.shrink();
          }),

        ]);
      }),
    );
  }
}