import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? email;
  final bool fromPasswordChange;
  const NewPassScreen({super.key, required this.resetToken, required this.email, required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'change_password'.tr),

      body: GetBuilder<AuthController>(builder: (authController) {
        return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Flexible(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [

                  const CustomAssetImageWidget(
                    image: Images.changePasswordBgImage,
                    height: 145, width: 160,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  widget.fromPasswordChange ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text('please_set_your_new_password'.tr, style: robotoBold),
                  ) : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text('number_verification_is_successful'.tr, style: robotoBold.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),

                    Text('please_set_your_new_password'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5))),
                  ]),
                  SizedBox(height: widget.fromPasswordChange ? Dimensions.paddingSizeLarge : 35),

                  CustomTextFieldWidget(
                    hintText: '7_characters'.tr,
                    labelText: 'password'.tr,
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    nextFocus: _confirmPasswordFocus,
                    inputType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    onChanged: (value){
                      if(value != null && value.isNotEmpty){
                        if(!authController.showPassView){
                          authController.showHidePass();
                        }
                        authController.validPassCheck(value);
                      }else{
                        if(authController.showPassView){
                          authController.showHidePass();
                        }
                      }
                    },
                  ),

                  authController.showPassView ? const Align(alignment: Alignment.centerLeft, child: PassViewWidget()) : const SizedBox(),
                  const SizedBox(height: 35),

                  CustomTextFieldWidget(
                    labelText: 'confirm_password'.tr,
                    hintText: '7_characters'.tr,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    onChanged: (String text) => setState(() {}),
                  ),

                ]),
              ),
            ),
          ),

          GetBuilder<ForgotPasswordController>(builder: (forgotPasswordController) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: !forgotPasswordController.isLoading ? CustomButtonWidget(
                buttonText: widget.fromPasswordChange ? 'save'.tr : 'update'.tr,
                color: _newPasswordController.text.trim().isEmpty || _confirmPasswordController.text.trim().isEmpty ? const Color(0xff9DA7BC).withValues(alpha: 0.7) : Theme.of(context).primaryColor,
                onPressed: () {
                  _newPasswordController.text.trim().isNotEmpty || _confirmPasswordController.text.trim().isNotEmpty ?_resetPassword() : null;
                },
              ) : const Center(child: CircularProgressIndicator()),

            );
          }),

        ]);
      }),
    );
  }

  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 8) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(password != confirmPassword) {
      showCustomSnackBar('password_and_confirm_password_does_not_match'.tr);
    }else {
      if(widget.fromPasswordChange) {
        ProfileModel user = Get.find<ProfileController>().profileModel!;
        Get.find<ForgotPasswordController>().changePassword(user, password).then((value) {
          if (value.isSuccess) {
            showDialog(
              context: Get.context!,
              builder: (context) => Dialog(
                child: Container(
                  width: context.width * 0.9,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [

                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.close, size: 25),
                      ),
                    ),

                    Flexible(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                        const CustomAssetImageWidget(
                          image: Images.passwordUpdateIcon, height: 60, width: 60,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Text('password_successfully_updated'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),

                      ]),
                    ),

                  ]),
                ),
              ),
            );
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }else {
        Get.find<ForgotPasswordController>().resetPassword(widget.resetToken, widget.email, password, confirmPassword).then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login(widget.email, password, 'owner').then((value) async {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }

}