import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/widgets/language_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/domain/models/menu_model.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/widgets/profile_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuButtonWidget extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  final double height;
  const MenuButtonWidget({super.key, required this.menu, required this.isProfile, required this.isLogout, required this.height});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.only( bottom:  Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: () async {
          if(menu.isBlocked) {
            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
          }else if(menu.isNotSubscribe){
            showCustomSnackBar('you_have_no_available_subscription'.tr);
          } else if(menu.isLanguage){
            Get.back();
            _manageLanguageFunctionality();
          }else {
            if (isLogout) {
              Get.back();
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () async {
                  Get.find<AuthController>().clearSharedData();
                  await Get.find<ProfileController>().trialWidgetShow(route: RouteHelper.payment);
                  Get.offAllNamed(RouteHelper.getSignInRoute());
                }), useSafeArea: false);
              } else {
                await Get.find<ProfileController>().trialWidgetShow(route: RouteHelper.payment);
                Get.find<AuthController>().clearSharedData();
                Get.toNamed(RouteHelper.getSignInRoute());
              }
            } else {
              if(menu.route.contains(RouteHelper.mySubscription)) {
                Get.offNamed(menu.route);
              } else {
                if (!Get.find<SubscriptionController>().isTrialEndModalShown) {
                  Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
                    if(trialEnd) {
                      Get.offNamed(menu.route);
                    }else {
                      Get.find<SubscriptionController>().setTrialEndModalShown(true);
                    }
                  });
                }
              }
            }
          }
        },
        child: Column(children: [

          Container(
            height: height,
            padding: MediaQuery.of(context).size.width < 600 ? EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: isLogout ? Get.find<AuthController>().isLoggedIn() ? Theme.of(context).colorScheme.error : Colors.green : Theme.of(context).primaryColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            alignment: Alignment.center,
            child: isProfile ? ProfileImageWidget(size: height) : CustomAssetImageWidget(image: menu.icon, width: height, height: height, color: menu.iconColor , fit: BoxFit.contain),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(menu.title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center, maxLines: 2,),

        ]),
      ),
    );
  }

  void _manageLanguageFunctionality() {
    Get.find<LocalizationController>().saveCacheLanguage(null);
    Get.find<LocalizationController>().searchSelectedLanguage();

    showModalBottomSheet(
      isScrollControlled: true, useRootNavigator: true, context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const LanguageBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<LocalizationController>().setLanguage(Get.find<LocalizationController>().getCacheLocaleFromSharedPref()));
  }

}