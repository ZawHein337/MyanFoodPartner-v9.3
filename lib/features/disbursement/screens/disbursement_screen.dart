import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/widgets/payment_information_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/widgets/disbursement_status_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementScreen extends StatefulWidget {
  const DisbursementScreen({super.key});

  @override
  State<DisbursementScreen> createState() => _DisbursementScreenState();
}

class _DisbursementScreenState extends State<DisbursementScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<DisbursementController>().getDisbursementReport(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(
        title: 'disbursement'.tr,
        isBackButtonExist: true,
        menuWidget: Container(
          height: 35, width: 35,
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
            ),
          child: GetBuilder<ProfileController>(builder: (profileController) {
            return Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Theme.of(context).cardColor)),
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CustomImageWidget(
                  image: (profileController.profileModel != null && Get.find<AuthController>().isLoggedIn()) ? profileController.profileModel!.imageFullUrl ?? '' : '',
                  width: 35, height: 35, fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
      ),

      body: GetBuilder<DisbursementController>(builder: (disbursementController) {
        return disbursementController.disbursementReportModel != null ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            SizedBox(
              height: 160,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [

                  DisbursementStatusCardWidget(
                    amount: disbursementController.disbursementReportModel!.pending!,
                    text: 'pending_disbursements'.tr,
                    isPending: true,
                  ),

                  DisbursementStatusCardWidget(
                    amount: disbursementController.disbursementReportModel!.completed!,
                    text: 'completed_disbursements'.tr,
                    isCompleted: true,
                  ),

                  DisbursementStatusCardWidget(
                    amount: disbursementController.disbursementReportModel!.canceled!,
                    text: 'canceled_transactions'.tr,
                    isCanceled: true,
                  ),

                ]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(
                "disbursement_history".tr,
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),

            (disbursementController.disbursementReportModel!.disbursements != null && disbursementController.disbursementReportModel!.disbursements!.isNotEmpty) ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: disbursementController.disbursementReportModel!.disbursements!.length,
              itemBuilder: (context, index) {

                Disbursements disbursement = disbursementController.disbursementReportModel!.disbursements![index];

                return Column(children: [

                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)), //this right here
                            child: PaymentInformationDialogWidget(disbursement: disbursement),
                          );
                        }
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(PriceConverter.convertPrice(disbursement.disbursementAmount), style: robotoMedium),
                      subtitle: Text(disbursement.withdrawMethod != null ? '${"payment_method".tr} : ${disbursement.withdrawMethod!.methodName}' : 'payment_method_deleted'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Text(
                          DateConverter.dateTimeStringForDisbursement(disbursement.createdAt!),
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.blue.withValues(alpha: 0.1),
                          ),
                          child: Text(disbursement.status!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
                        ),

                      ]),
                    ),
                  ),

                  const Divider(height: 2, thickness: 1),

                ]);
              },
            ) : Padding(padding: const EdgeInsets.only(top: 200), child: Center(child: Text('no_history_available'.tr, style: robotoMedium))),

          ]),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}