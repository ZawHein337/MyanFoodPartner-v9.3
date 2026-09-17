import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/controllers/happy_hour_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/widgets/happy_hour_deny_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/widgets/happy_hour_join_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/widgets/happy_hour_request_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HappyHourActionHelper {

  static bool run(HappyHourModel happyHour, {String? actionKey}) {
    final String action = actionKey ?? HappyHourHelper.actionKey(happyHour);
    final int? id = happyHour.id;

    if(id == null || action == 'view') {
      return false;
    }

    final HappyHourController happyHourController = Get.find<HappyHourController>();

    if(action == 'leave' || action == 'cancel') {
      final bool isLeaving = action == 'leave';
      Get.dialog(ConfirmationDialogWidget(
        icon: Images.warning,
        title: isLeaving ? 'leave_happy_hour'.tr : 'cancel_happy_hour_request'.tr,
        description: isLeaving ? 'are_you_sure_to_leave_happy_hour'.tr : 'are_you_sure_to_cancel_happy_hour_request'.tr,
        onYesPressed: () {
          Get.back();
          happyHourController.leaveHappyHour(id);
        },
      ));
      return true;
    }

    HappyHourJoinBottomSheetWidget.show(
      happyHourModel: happyHour,
      onConfirm: () {
        if(action == 'approve') {
          happyHourController.respondToHappyHour(id, 'approved');
        } else {
          happyHourController.joinHappyHour(id);
        }
      },
    );
    return true;
  }

  static Future<void> showAdminRequest() async {
    final HappyHourController happyHourController = Get.find<HappyHourController>();
    if(happyHourController.adminRequestSheetShown) {
      return;
    }

    /// The lookup below is a network round trip, and the restaurant may well have
    /// navigated on before it lands. The prompt belongs to the screen that asked for
    /// it — without this it opens over whatever route happens to be on top by then.
    final String requestedFromRoute = Get.currentRoute;

    final HappyHourModel? requested = await happyHourController.getAdminRequestedHappyHour();
    if(requested?.id == null || happyHourController.adminRequestSheetShown) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = Get.context;
      if(context == null || !context.mounted || happyHourController.adminRequestSheetShown) {
        return;
      }
      if(Get.currentRoute != requestedFromRoute) {
        return;
      }
      if((Get.isDialogOpen ?? false) || (Get.isBottomSheetOpen ?? false) || Get.isSnackbarOpen) {
        return;
      }

      happyHourController.markAdminRequestSheetShown();

      HappyHourRequestBottomSheetWidget.show(
        happyHourModel: requested!,
        onViewDetails: () => Get.toNamed(RouteHelper.getHappyHourDetailsRoute(id: requested.id!)),
      );
    });
  }

  static void deny(HappyHourModel happyHour) {
    final int? id = happyHour.id;
    if(id == null) {
      return;
    }
    HappyHourDenyDialogWidget.show(
      onSubmit: (String? reason) => Get.find<HappyHourController>().respondToHappyHour(id, 'rejected', rejectionReason: reason),
    );
  }
}
