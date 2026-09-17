import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final bool isPrivacyPolicy;
  const HtmlViewerScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {

    String? data = isPrivacyPolicy ? Get.find<SplashController>().configModel!.privacyPolicy
      : Get.find<SplashController>().configModel!.termsAndConditions;

    return Scaffold(

      appBar: CustomAppBarWidget(title: isPrivacyPolicy ? 'privacy_policy'.tr : 'terms_condition'.tr),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [

            Image.asset(
              isPrivacyPolicy ? Images.privacyPolicyBg : Images.refundPolicyBg,
              height: 80, width: context.width, fit: BoxFit.cover,
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: HtmlWidget(
                data ?? '',
                key: Key(isPrivacyPolicy ? 'privacy_policy' : 'terms_condition'),
                onTapUrl: (String url) {
                  return launchUrlString(url, mode: LaunchMode.externalApplication);
                },
              ),
            ),

          ]),
        ),
      ),

    );
  }
}