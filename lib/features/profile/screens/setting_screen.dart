import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/details_custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/switch_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool _isOwner;

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().getProfile();
    _isOwner = Get.find<AuthController>().getUserType() == 'owner';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'account_settings'.tr),
      body: GetBuilder<ProfileController>(
        builder: (profileController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [
              SwitchButtonWidget(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SwitchButtonWidget(
                icon: Icons.notifications, title: 'system_notification'.tr,
                isButtonActive: profileController.notification, onTap: () {
                profileController.setNotificationActive(!profileController.notification);
              },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              GetPlatform.isAndroid ? InkWell(
                onTap: () {
                  showBgNotificationBottomSheet(context, profileController.backgroundNotification);
                },
                child: DetailsCustomCard(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [

                    const Icon(Icons.notifications_active_rounded, size: 25),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Text('background_notification'.tr, style: robotoRegular)),

                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        value: profileController.backgroundNotification,
                        onChanged: (bool isActive) {
                          showBgNotificationBottomSheet(context, profileController.backgroundNotification);
                        },
                      ),
                    ),
                  ]),
                ),
              ) : const SizedBox(),
              SizedBox(height: GetPlatform.isAndroid ? Dimensions.paddingSizeSmall : 0),

              _isOwner ? SwitchButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeSmall : 0),

            ]),
          );
        }
      ),
    );
  }

  void showBgNotificationBottomSheet(BuildContext context, bool allow) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          height: 5, width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          '${!allow ? 'allow'.tr : 'disable'.tr} ${AppConstants.appName} ${'to_run_notification_in_background'.tr}',
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),

        Text(
          allow ? '(${AppConstants.appName} -> Battery -> Select Optimized or any Recommended)' : 'Or (${AppConstants.appName} ->  Battery -> No restriction)',
          textAlign: TextAlign.center,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        _buildInfoText("you_will_be_able_to_get_order_notification_even_if_you_are_not_in_the_app".tr),
        _buildInfoText("${AppConstants.appName} ${!allow ? 'will_run_notification_service_in_the_background_always'.tr : 'will_not_run_notification_service_in_the_background_always'.tr}"),
        _buildInfoText(!allow ? "notification_will_always_send_alert_from_the_background".tr : 'notification_will_not_always_send_alert_from_the_background'.tr),
        const SizedBox(height: 20.0),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr, style: robotoMedium),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            ElevatedButton(
              onPressed: () async {
                if(await Permission.ignoreBatteryOptimizations.status.isGranted) {
                  openAppSettings();
                } else {
                  await Permission.ignoreBatteryOptimizations.request();
                }
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "okay".tr,
                style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
              ),
            ),
          ],
        ),
      ]),
    ), isScrollControlled: true).then((value) {
      checkBatteryPermission();
    });
  }

  void checkBatteryPermission() async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if(await Permission.ignoreBatteryOptimizations.status.isDenied) {
        Get.find<ProfileController>().setBackgroundNotificationActive(false);
      } else {
        Get.find<ProfileController>().setBackgroundNotificationActive(true);
      }
    });
  }

  Widget _buildInfoText(String text) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: robotoRegular,
      ),
    );
  }
}
