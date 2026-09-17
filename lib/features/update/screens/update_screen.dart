import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/dotted_divider.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatelessWidget {
  final bool willUpdate;
  const UpdateScreen({super.key, required this.willUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        
              Image.asset(
                willUpdate ? Images.update : Images.maintenance,
                width: 280, height: 180,
              ),
              const SizedBox(height: 50),
        
              Text(
                willUpdate ? 'update'.tr : splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.maintenanceMessage ?? 'we_are_cooking_up_something_special'.tr,
                style: robotoBold.copyWith(fontWeight: FontWeight.w600, fontSize: willUpdate ? MediaQuery.of(context).size.height*0.023 : Dimensions.fontSizeDefault),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
        
              Text(
                willUpdate ? 'your_app_is_deprecated'.tr : splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.messageBody ?? 'maintenance_mode'.tr,
                style: robotoRegular.copyWith(fontSize: willUpdate ? MediaQuery.of(context).size.height*0.0175 : Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: willUpdate ? MediaQuery.of(context).size.height*0.04 : Dimensions.paddingSizeLarge),
        
              willUpdate ? const SizedBox() : Column(children: [
        
                splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.businessEmail == 1
                || splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.businessNumber == 1 ? Column(
                  children: [

                    DottedDivider(dashWidth: 10, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text(
                      'any_query_feel_free_to_contact_us'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
        
                    splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.businessNumber == 1 ? InkWell(
                      onTap: () async {
                        if(await canLaunchUrlString('tel:${splashController.configModel?.phone}')) {
                          launchUrlString('tel:${splashController.configModel?.phone}', mode: LaunchMode.externalApplication);
                        }else {
                          showCustomSnackBar('${'can_not_launch'.tr} ${splashController.configModel?.phone}');
                        }
                      },
                      child: Text(
                        splashController.configModel?.phone ?? '',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                      ),
                    ) : const SizedBox(),
                    SizedBox(height: splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.businessNumber == 1 ? Dimensions.paddingSizeExtraSmall : 0),
        
                    splashController.configModel!.maintenanceModeData?.maintenanceMessageSetup?.businessEmail == 1 ? InkWell(
                      onTap: () async {
                        if(await canLaunchUrlString('mailto:${splashController.configModel?.email}')) {
                          launchUrlString('mailto:${splashController.configModel?.email}', mode: LaunchMode.externalApplication);
                        }else {
                          showCustomSnackBar('${'can_not_launch'.tr} ${splashController.configModel?.email}');
                        }
                      },
                      child: Text(
                        splashController.configModel?.email ?? '',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline, decorationColor: Theme.of(context).primaryColor),
                      ),
                    ) : const SizedBox(),
                  ],
                ) : const SizedBox(),
        
              ]),
        
              willUpdate ? CustomButtonWidget(buttonText: 'update_now'.tr, onPressed: () async {
                String? appUrl = 'https://google.com';
                if(GetPlatform.isAndroid) {
                  appUrl = splashController.configModel!.appUrlAndroidRestaurant;
                }else if(GetPlatform.isIOS) {
                  appUrl = splashController.configModel!.appUrlIosRestaurant;
                }
                if(await canLaunchUrlString(appUrl!)) {
                  launchUrlString(appUrl, mode: LaunchMode.externalApplication);
                }else {
                  showCustomSnackBar('${'can_not_launch'.tr} $appUrl');
                }
              }) : const SizedBox(),
        
            ]),
          ),
        );
      }),
    );
  }
}