import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/report_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'reports'.tr),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: GetBuilder<ProfileController>(builder: (profileController) {
          return Column(children: [

            profileController.modulePermission!.expenseReport! ? ReportCardWidget(
              title: 'earning_report'.tr,
              subtitle: 'revenue_overview'.tr,
              image: Images.earningIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getEarningRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.expenseReport! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.expenseReport! ? ReportCardWidget(
              title: 'expense_report'.tr,
              subtitle: 'track_business_spending_and_cost_entries'.tr,
              image: Images.expenseIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getExpenseRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.expenseReport! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.transaction! ? ReportCardWidget(
              title: 'transaction_report'.tr,
              subtitle: 'view_all_incoming_and_outgoing_payment_records'.tr,
              image: Images.transactionIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getTransactionReportRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.transaction! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.orderReport! ? ReportCardWidget(
              title: 'order_report'.tr,
              subtitle: 'review_order_history_and_order_performance'.tr,
              image: Images.orderIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getOrderReportRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.orderReport! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.foodReport! ? ReportCardWidget(
              title: 'food_report'.tr,
              subtitle: 'check_detailed_reports_on_food_items_sold'.tr,
              image: Images.foodIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getFoodReportRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.foodReport! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.campaign! ? ReportCardWidget(
              title: 'campaign_report'.tr,
              subtitle: 'view_campaign_performance_and_effectiveness'.tr,
              image: Images.campaignIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getCampaignReportRoute());
              },
            ) : const SizedBox(),
            SizedBox(height: profileController.modulePermission!.campaign! ? Dimensions.paddingSizeDefault : 0),

            profileController.modulePermission!.taxReport! ? ReportCardWidget(
              title: 'vat_report'.tr,
              subtitle: 'see_vat_collected_and_applied_on_transactions'.tr,
              image: Images.taxReportIcon,
              onTap: () {
                Get.toNamed(RouteHelper.getTaxReportRoute());
              },
            ) : const SizedBox(),

          ]);
        }),
      ),
    );
  }
}