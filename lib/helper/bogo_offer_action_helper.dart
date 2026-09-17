import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/controllers/bogo_offer_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/models/bogo_offer_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/bogo_campaign_request_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class BogoOfferActionHelper {

  /// Raised once when the app opens, from the home screen, so an invitation waiting
  /// from before start-up is not missed.
  static Future<void> showAdminRequest() async {
    if(!Get.find<AuthController>().isLoggedIn()) {
      return;
    }

    final BogoOfferController bogoOfferController = Get.find<BogoOfferController>();
    if(bogoOfferController.adminRequestSheetShown) {
      customPrint('BOGO admin request: already announced this session');
      return;
    }

    final BogoOffer? offer = await bogoOfferController.getAdminRequestedBogoOffer();
    if(offer == null) {
      customPrint('BOGO admin request: none outstanding');
      return;
    }
    if(bogoOfferController.adminRequestSheetShown) {
      customPrint('BOGO admin request: announced while the lookup was in flight');
      return;
    }

    /// Deliberately not tied to the route it was asked from. The lookup runs behind
    /// three other start-up calls, and GetX pushes every sheet and dialog as a route,
    /// so any of them opening in that window would otherwise silently swallow this.
    _show(offer, offerId: offer.id);
  }

  /// Raised by a push, which is the admin asking right now — so unlike
  /// [showAdminRequest] this is not held back by the once-per-session flag and is not
  /// tied to any one screen. It still marks the flag, so a screen opening afterwards
  /// does not ask the same thing again.
  ///
  /// The push only says "bogo_offer" — the same type carries approvals and rejections
  /// too — so the offer is read back and the sheet is raised only for an invitation
  /// still waiting on an answer.
  static Future<void> showAdminRequestForOffer(dynamic dataId) async {
    if(!Get.find<AuthController>().isLoggedIn()) {
      return;
    }

    final int? offerId = int.tryParse(dataId?.toString() ?? '');
    if(offerId == null) {
      return;
    }

    final BogoOffer? offer = await Get.find<BogoOfferController>().fetchBogoOffer(offerId);
    if(offer == null || !offer.isPendingAdminRequest) {
      return;
    }

    _show(offer, offerId: offerId);
  }

  /// Shown straight from the caller's async continuation rather than from a post-frame
  /// callback: a push lands on an otherwise idle app, which schedules no frames, so a
  /// post-frame callback would sit queued until the restaurant happened to touch the
  /// screen. Both callers await first, so we are already outside any build phase.
  static void _show(BogoOffer offer, {int? offerId}) {
    final BuildContext? context = Get.context;
    if(context == null || !context.mounted) {
      customPrint('BOGO admin request: no live context to show from');
      return;
    }

    /// Already reading this very offer, so the "view details" prompt would only be
    /// in the way.
    if(offerId != null && _isViewingOffer(offerId)) {
      customPrint('BOGO admin request: already viewing offer $offerId');
      return;
    }

    /// Something is already asking for an answer — a new-order dialog, another
    /// sheet. Stacking on top of it would bury whichever loses. A snackbar is not
    /// counted: it sits alongside a sheet rather than competing with it, and one
    /// left over from a start-up API error would otherwise suppress this entirely.
    if((Get.isDialogOpen ?? false) || (Get.isBottomSheetOpen ?? false)) {
      customPrint('BOGO admin request: a dialog or sheet is already open');
      return;
    }

    customPrint('BOGO admin request: showing sheet for offer ${offer.id}');
    Get.find<BogoOfferController>().markAdminRequestSheetShown();

    showCustomBottomSheet(child: BogoCampaignRequestBottomSheet(
      offerId: offer.id, status: offer.enrollmentState,
      buyQuantity: offer.buyQty ?? 0, getQuantity: offer.getQty ?? 0,
    ));
  }

  static bool _isViewingOffer(int offerId) {
    final String route = Get.currentRoute;

    /// Pushed by name from a notification, carrying the id as a query parameter.
    if(route.startsWith(RouteHelper.bogoOfferDetails)) {
      return Get.parameters['id'] == offerId.toString();
    }

    /// Pushed as a widget from the list, where GetX names the route after the class
    /// and no id is exposed — fall back to the details the screen is holding.
    if(route.contains('BogoOfferSetupScreen')) {
      return Get.find<BogoOfferController>().bogoOfferDetails?.id == offerId;
    }

    return false;
  }
}
