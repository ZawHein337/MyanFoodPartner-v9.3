import 'package:stackfood_multivendor_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/widgets/withdraw_method_attention_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementHelper {

  Future<bool> enableDisbursementWarningMessage(bool fromDashboard, {bool canShowDialog = true}) async {

    bool showWarning = false;

    await Get.find<DisbursementController>().getDisbursementMethodList().then((success) {
      if(success){
        if(Get.find<DisbursementController>().disbursementMethodBody!.methods!.isNotEmpty){
          for (var method in Get.find<DisbursementController>().disbursementMethodBody!.methods!) {
            if(method.isDefault == 1){
              showWarning = false;
              break;
            } else {
              showWarning = true;
            }
          }
        }else {
          showWarning = true;
        }
      }
    });

    if(showWarning && canShowDialog) {
      Get.dialog(
        Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: const Color(0xfffff1f1),
          insetPadding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)), //this right here
          child: WithdrawMethodAttentionDialogWidget(isFromDashboard: fromDashboard),
        ),
      );
    }

    return showWarning;
  }

}