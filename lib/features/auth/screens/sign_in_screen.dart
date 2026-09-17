import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/restaurant_registartion_success_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
    if(Get.find<AuthController>().getUserType() == 'employee'){
      Get.find<AuthController>().changeOwnerType(1, isUpdate: false);
    }else{
      Get.find<AuthController>().changeOwnerType(0, isUpdate: false);
    }
    _showRegistrationSuccessBottomSheet();
  }

  void _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet = Get.find<AuthController>().getIsRestaurantRegistrationSharedPref();
    if(canShowBottomSheet){
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const RestaurantRegistrationSuccessBottomSheet(),
        ).then((value) {
          Get.find<AuthController>().saveIsRestaurantRegistrationSharedPref(false);
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeOverLarge),
        child: GetBuilder<AuthController>(builder: (authController) {

          return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

            const SizedBox(height: 50),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(Images.logo, width: 50, height: 50),
              const SizedBox(width: 3),

              Image.asset(Images.logoName, width: 150),
            ]),
            const SizedBox(height: 50),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(children: [

                Expanded(
                  child: InkWell(
                    onTap: () => authController.changeOwnerType(0),
                    child: Column(children: [

                      Expanded(
                        child: Center(child: Text(
                          'owner_login'.tr,
                          style: robotoMedium.copyWith(color: authController.ownerTypeIndex == 0
                              ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                        )),
                      ),

                      Container(
                        height: 2,
                        color: authController.ownerTypeIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                      ),

                    ]),
                  ),
                ),

                Expanded(
                  child: InkWell(
                    onTap: () => authController.changeOwnerType(1),
                    child: Column(children: [

                      Expanded(
                        child: Center(child: Text(
                          'employee_login'.tr,
                          style: robotoMedium.copyWith(color: authController.ownerTypeIndex == 1
                              ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
                        )),
                      ),

                      Container(
                        height: 2,
                        color: authController.ownerTypeIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                      ),

                    ]),
                  ),
                ),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeOverLarge),

            CustomTextFieldWidget(
              hintText: 'email'.tr,
              labelText: 'email'.tr,
              required: true,
              controller: _emailController,
              focusNode: _emailFocus,
              nextFocus: _passwordFocus,
              inputType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            CustomTextFieldWidget(
              hintText: 'password'.tr,
              labelText: 'password'.tr,
              required: true,
              controller: _passwordController,
              focusNode: _passwordFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.visiblePassword,
              prefixIcon: Icons.lock,
              isPassword: true,
            ),
            SizedBox(height: authController.ownerTypeIndex == 1 ? 11 : 0),

            Row(children: [

              Expanded(
                child: InkWell(
                  onTap: () => authController.toggleRememberMe(),
                  child: Row(children: [
                    SizedBox(
                      width: 24, height: 24,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: BorderSide(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.3), width: 1,
                        ),
                        activeColor: Theme.of(context).primaryColor,
                        value: authController.isActiveRememberMe,
                        onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                      ),
                    ),
                    const SizedBox(width: 7),

                    Text('remember_me'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ]),
                ),
              ),

              authController.ownerTypeIndex == 1 ? const SizedBox() : TextButton(
                onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                child: Text('${'forgot_password'.tr}?', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
              ),

            ]),
            SizedBox(height: authController.ownerTypeIndex == 1 ? Dimensions.paddingSizeOverLarge + 3 : Dimensions.paddingSizeLarge),

            CustomButtonWidget(
              buttonText: 'login'.tr,
              isLoading: authController.isLoading,
              onPressed: () => _login(authController),
            ),
            SizedBox(height: Get.find<SplashController>().configModel!.toggleRestaurantRegistration! ? Dimensions.paddingSizeExtraSmall : 0),

            Get.find<SplashController>().configModel!.toggleRestaurantRegistration! ? TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(1, 40),
              ),
              onPressed: () async {
                Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
              },
              child: RichText(text: TextSpan(children: [
                TextSpan(text: '${'join_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                TextSpan(text: 'restaurant'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
              ])),
            ) : const SizedBox(),

          ]);
        }),
      ),
    );
  }

  void _login(AuthController authController) async {

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String type = authController.ownerTypeIndex == 0 ? 'owner' : 'employee';

    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(email, password, type).then((status) async {
        if (status != null) {
          if (status.isSuccess) {
            if (authController.isActiveRememberMe) {
              authController.saveUserCredentials(email, password, type);
            } else {
              authController.clearUserCredentials();
            }
            Get.offAllNamed(RouteHelper.getInitialRoute());
            await Permission.ignoreBatteryOptimizations.request();
          } else {
            if (status.message != 'no') {
              showCustomSnackBar(status.message);
            }
          }
        }
      });
    }

  }
}