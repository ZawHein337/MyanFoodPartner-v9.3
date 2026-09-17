import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/readmore_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/controllers/bogo_offer_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/models/bogo_offer_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/leave_bogo_offer_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/offer_not_visible_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/reject_admin_request_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/setup_screen_widgets/bogo_food_details_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

part '../widgets/setup_screen_widgets/item_dropdown_widget.dart';
part '../widgets/setup_screen_widgets/offer_details_view_widget.dart';
part '../widgets/setup_screen_widgets/selected_food_card_widget.dart';
part '../widgets/setup_screen_widgets/selected_items_quantity_widgets.dart';
part '../widgets/setup_screen_widgets/status_app_bar_widget.dart';

class BogoOfferStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
}

// Used to decide the admin-request edit form's action button: unchanged from what the admin
// pre-filled -> "Approve" (respond); anything different -> "Submit" (resubmit with the new items).
String _selectionKey(BogoSelectedFoodResult item) {
  final List<String> variationKeys = item.variationSummaries.map((line) => '${line.groupName}:${line.selectedLabels}').toList()..sort();
  final List<String> addOnKeys = item.addOns.map((addOn) => '${addOn.id}:${addOn.quantity}').toList()..sort();
  return '${item.product.id}|${item.quantity}|${variationKeys.join(',')}|${addOnKeys.join(',')}';
}

bool _isSameSelection(List<BogoSelectedFoodResult> a, List<BogoSelectedFoodResult> b) {
  if(a.length != b.length) return false;
  final List<String> aKeys = a.map(_selectionKey).toList()..sort();
  final List<String> bKeys = b.map(_selectionKey).toList()..sort();
  for(int i = 0; i < aKeys.length; i++) {
    if(aKeys[i] != bKeys[i]) return false;
  }
  return true;
}

Map<String, dynamic> _toJoinItem(BogoSelectedFoodResult item) {
  return {
    'food_id': item.product.id,
    'quantity': item.quantity,
    'variations': item.variations.map((variation) => variation.toJson()).toList(),
    'variation_options': item.variationOptionIds,
    'add_on_ids': item.addOns.map((addOn) => addOn.id).toList(),
    'add_on_qtys': item.addOns.map((addOn) => addOn.quantity).toList(),
  };
}

class BogoOfferInfo {
  final String bannerImage;
  final String title;
  final String description;
  final String createdAt;
  final int usageLimitPerPerson;
  final int usageLimitTotal;
  final String validity;
  final List<BogoSelectedFoodResult> buyItems;
  final List<BogoSelectedFoodResult> getItems;
  final String? rejectionReason;

  const BogoOfferInfo({
    required this.bannerImage, required this.title, required this.description, required this.createdAt,
    required this.usageLimitPerPerson, required this.usageLimitTotal, required this.validity,
    required this.buyItems, required this.getItems, this.rejectionReason,
  });
}

class BogoOfferSetupScreen extends StatefulWidget {
  final int? buyQuantity;
  final int? getQuantity;
  final int? offerId;
  final String? status;
  final bool fromNotification;
  /// Known up front from the list, for the not-joined case where the screen never
  /// fetches details and so would otherwise have no way to tell the offer is over.
  final bool isExpired;
  const BogoOfferSetupScreen({
    super.key, this.buyQuantity, this.getQuantity,
    this.offerId, this.status, this.fromNotification = false, this.isExpired = false,
  });

  @override
  State<BogoOfferSetupScreen> createState() => _BogoOfferSetupScreenState();
}

class _BogoOfferSetupScreenState extends State<BogoOfferSetupScreen> {
  final GlobalKey<_SelectItemFieldState> _buyItemKey = GlobalKey<_SelectItemFieldState>();
  final GlobalKey<_SelectItemFieldState> _getItemKey = GlobalKey<_SelectItemFieldState>();

  bool _isResubmitting = false;
  bool _isApprovingAdminRequest = false;
  bool _isApprovingRequest = false;
  String? _lastKnownEnrollmentState;
  bool _hasShownVisibilityNotice = false;

  BogoOffer? get _details {
    if(!_needsOfferDetails) {
      return null;
    }
    final BogoOffer? details = Get.find<BogoOfferController>().bogoOfferDetails;
    return details?.id == widget.offerId ? details : null;
  }

  int get _buyQuantity => _details?.buyQty ?? widget.buyQuantity ?? 0;
  int get _getQuantity => _details?.getQty ?? widget.getQuantity ?? 0;

  String? get _status {
    final String? enrollmentState = _details?.enrollmentState;
    if(enrollmentState == null) {
      return widget.status;
    }
    return enrollmentState == 'not_joined' ? null : enrollmentState;
  }

  /// The server's word once details are in, falling back to what the list already knew.
  bool get _isExpired => _details?.isExpired ?? widget.isExpired;

  bool get _isEditable => _status == null || _isResubmitting || _isApprovingAdminRequest;
  bool get _needsOfferDetails => widget.offerId != null && (widget.status != null || widget.fromNotification);

  @override
  void initState() {
    super.initState();
    final BogoOfferController bogoOfferController = Get.find<BogoOfferController>();
    bogoOfferController.getBogoOfferFoods(isUpdate: false);
    if(_needsOfferDetails) {
      bogoOfferController.getBogoOfferDetails(widget.offerId!, isUpdate: false);
    }
  }

  void _syncEditingState(BogoOffer? details) {
    final String? enrollmentState = details?.enrollmentState;
    if(enrollmentState == null || enrollmentState == _lastKnownEnrollmentState) {
      return;
    }

    final bool hadPreviousState = _lastKnownEnrollmentState != null;
    _lastKnownEnrollmentState = enrollmentState;

    if(!hadPreviousState || (!_isResubmitting && !_isApprovingAdminRequest)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!mounted) return;
      setState(() {
        _isResubmitting = false;
        _isApprovingAdminRequest = false;
      });
    });
  }

  void _maybeShowVisibilityNotice(BogoOffer? details) {
    if(details == null) {
      return;
    }

    if(!details.isNotVisibleToCustomers) {
      _hasShownVisibilityNotice = false;
      return;
    }

    if(_hasShownVisibilityNotice) {
      return;
    }
    _hasShownVisibilityNotice = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!mounted) return;
      showCustomBottomSheet(child: OfferNotVisibleBottomSheet(reasons: details.visibilityReasons ?? const []));
    });
  }

  void _resetSelections() {
    _buyItemKey.currentState?.reset();
    _getItemKey.currentState?.reset();
  }

  BogoOfferInfo _mapOfferInfo(BogoOffer offer) {
    List<BogoSelectedFoodResult> mapItems(List<BogoEnrollmentItem>? items) {
      return (items ?? []).map((item) {
        final List<BogoVariationSummaryLine> variationSummaries = [];
        final List<OrderVariation> orderVariations = [];
        for(final dynamic rawVariation in item.variations ?? []) {
          if(rawVariation is! Map<String, dynamic>) continue;
          final OrderVariation orderVariation = OrderVariation.fromJson(rawVariation);
          final List<String> labels = (orderVariation.values?.label ?? []).whereType<String>().toList();
          if(labels.isNotEmpty) {
            variationSummaries.add(BogoVariationSummaryLine(groupName: orderVariation.name ?? '', selectedLabels: labels.join(', ')));
          }
          orderVariations.add(orderVariation);
        }

        final List<AddOn> selectedAddOns = [];
        final List<dynamic> rawAddOns = item.addOns ?? [];
        for(int i = 0; i < rawAddOns.length; i++) {
          if(rawAddOns[i] is! Map<String, dynamic>) continue;
          final AddOns addOnDetails = AddOns.fromJson(rawAddOns[i] as Map<String, dynamic>);
          final int quantity = (item.addOnQtys != null && item.addOnQtys!.length > i) ? item.addOnQtys![i] : 1;
          selectedAddOns.add(AddOn(id: addOnDetails.id, quantity: quantity));
          variationSummaries.add(BogoVariationSummaryLine(groupName: 'addons'.tr, selectedLabels: '${addOnDetails.name ?? ''} x$quantity'));
        }

        return BogoSelectedFoodResult(
          product: Product(id: item.foodId, name: item.foodName ?? '', imageFullUrl: item.foodImageFullUrl ?? ''),
          quantity: item.quantity ?? 1,
          variationSummaries: variationSummaries,
          variations: orderVariations,
          variationOptionIds: (item.variationOptions ?? []).map((v) => int.parse(v.toString())).toList(),
          addOns: selectedAddOns,
        );
      }).toList();
    }

    return BogoOfferInfo(
      bannerImage: offer.imageFullUrl ?? '',
      title: offer.title ?? '',
      description: offer.description ?? '',
      createdAt: offer.enrollment?.joinedAt != null ? DateConverter.dateTimeToDayMonthAndTime(offer.enrollment!.joinedAt!) : '',
      usageLimitPerPerson: offer.usageLimitPerCustomer ?? 0,
      usageLimitTotal: offer.usageLimitTotal ?? 0,
      validity: '${offer.startDate != null ? DateConverter.convertDateToDate(offer.startDate!) : ''} - ${offer.endDate != null ? DateConverter.convertDateToDate(offer.endDate!) : ''}',
      buyItems: mapItems(offer.enrollment?.buyItems),
      getItems: mapItems(offer.enrollment?.getItems),
      rejectionReason: offer.enrollment?.rejectionReason,
    );
  }

  void _onBack() {
    if(widget.fromNotification) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
    }else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !widget.fromNotification,
      onPopInvokedWithResult: (didPop, result) {
        if(!didPop && widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }
      },
      child: GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
        final BogoOffer? details = _details;
        _syncEditingState(details);
        _maybeShowVisibilityNotice(details);
        final bool isLoadingDetails = _needsOfferDetails && (bogoOfferController.isDetailsLoading || details == null);
        final String? status = _status;

        return Scaffold(
          backgroundColor: Color.alphaBlend(theme.disabledColor.withValues(alpha: 0.1), theme.scaffoldBackgroundColor),
          appBar: status == null
              ? CustomAppBarWidget(title: 'bogo_offer'.tr, onBackPressed: _onBack)
              : _StatusAppBarWidget(offerId: widget.offerId, status: status, onBackPressed: _onBack),

          body: !_needsOfferDetails ? _buildEditView(theme, null) : isLoadingDetails
              ? const Center(child: CircularProgressIndicator())
              : _isEditable ? _buildEditView(theme, _mapOfferInfo(details!)) : _OfferDetailsView(info: _mapOfferInfo(details!)),

          bottomNavigationBar: _isExpired ? const SizedBox()
              : !_needsOfferDetails ? _buildEditableBottomBar(theme) : isLoadingDetails
              ? const SizedBox()
              : _buildBottomBar(theme, details!) ?? const SizedBox(),
        );
      }),
    );
  }

  Widget _buildEditView(ThemeData theme, BogoOfferInfo? info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text('select_items_for_bogo_offer'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          _ItemQuantitySection(
            label: 'buy_item'.tr,
            quantity: _buyQuantity,
            hintSuffixKey: 'as_the_buy_quantity_for_this_bogo_offer',
            selectItemKey: _buyItemKey,
            allowRemoveSelection: true,
            initialItems: (_isResubmitting || _isApprovingAdminRequest) ? (info?.buyItems ?? const []) : const [],
            onChanged: _isApprovingAdminRequest ? () => setState(() {}) : null,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          _ItemQuantitySection(
            label: 'get_item'.tr,
            quantity: _getQuantity,
            hintSuffixKey: 'as_the_buy_get_for_this_bogo_offer',
            selectItemKey: _getItemKey,
            allowRemoveSelection: true,
            initialItems: (_isResubmitting || _isApprovingAdminRequest) ? (info?.getItems ?? const []) : const [],
            onChanged: _isApprovingAdminRequest ? () => setState(() {}) : null,
          ),

        ]),
      ),
    );
  }


  Widget _buildActionBar(ThemeData theme, {required Widget left, required Widget right}) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: theme.shadowColor, spreadRadius: 0, blurRadius: 5)],
      ),
      child: Row(children: [
        Expanded(child: left),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(child: right),
      ]),
    );
  }

  Widget? _buildBottomBar(ThemeData theme, BogoOffer details) {
    final String? requestedBy = details.enrollment?.requestedBy;
    final String? enrollmentStatus = details.enrollment?.status;

    if(enrollmentStatus == BogoOfferStatus.approved) {
      if(_isResubmitting) return _buildLeaveAndSubmitBar(theme);
      return _buildLeaveAndResubmitPromptBar(theme, buttonText: 'edit'.tr);
    }

    if(requestedBy == 'restaurant') {
      if(_isResubmitting) return _buildEditableBottomBar(theme);
      if(enrollmentStatus == BogoOfferStatus.rejected) {
        return _buildLeaveAndResubmitPromptBar(theme, isCancelRequest: true, buttonText: 'edit_and_resubmit'.tr);
      }
      if(enrollmentStatus == BogoOfferStatus.pending) {
        return _buildLeaveOnlyBottomBar(theme, 'cancel_request'.tr);
      }
    }

    if(requestedBy == 'admin') {
      if(enrollmentStatus == BogoOfferStatus.pending) {
        if(_isApprovingAdminRequest) return _buildApproveOrSubmitBar(theme, details);
        return _buildAdminRequestPromptBar(theme);
      }
      if(enrollmentStatus == BogoOfferStatus.rejected) {
        if(_isResubmitting) return _buildEditableBottomBar(theme);
        return _buildLeaveAndResubmitPromptBar(theme, buttonText: 'join'.tr);
      }
    }

    final bool canResubmit = details.actions?.canResubmit ?? false;
    final bool canRespond = details.actions?.canRespond ?? false;
    if(canResubmit && !_isResubmitting) return _buildResubmitPromptBottomBar(theme, canRespond);
    return _isEditable ? _buildEditableBottomBar(theme) : _buildApprovedBottomBar(theme);
  }

  Widget _buildLeaveAndResubmitPromptBar(ThemeData theme, {bool isCancelRequest = false, required String buttonText}) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: isCancelRequest ? 'cancel_request'.tr :'leave'.tr,
          color: theme.colorScheme.error,
          isLoading: bogoOfferController.isLeaveLoading,
          onPressed: () => showCustomBottomSheet(child: LeaveBogoOfferConfirmationBottomSheet(onConfirm: () => _leaveBogoOffer(bogoOfferController))),
        ),
        right: CustomButtonWidget(
          buttonText: buttonText,
          onPressed: () => setState(() => _isResubmitting = true),
        ),
      );
    });
  }

  /// An approved offer being edited: the new items go back for approval, or the
  /// restaurant steps out of the offer altogether. No Reset here — the form opens on
  /// the approved items, so there is nothing to reset back to that is not already
  /// on screen.
  Widget _buildLeaveAndSubmitBar(ThemeData theme) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'leave'.tr,
          color: theme.colorScheme.error,
          isLoading: bogoOfferController.isLeaveLoading,
          onPressed: () => showCustomBottomSheet(child: LeaveBogoOfferConfirmationBottomSheet(onConfirm: () => _leaveBogoOffer(bogoOfferController))),
        ),
        right: CustomButtonWidget(
          buttonText: 'resubmit'.tr,
          isLoading: bogoOfferController.isResubmitLoading,
          onPressed: () => _resubmitBogoOffer(bogoOfferController),
        ),
      );
    });
  }

  Widget _buildLeaveOnlyBottomBar(ThemeData theme, String title) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [BoxShadow(color: theme.shadowColor, spreadRadius: 0, blurRadius: 5)],
        ),
        child: CustomButtonWidget(
          buttonText: title.tr,
          color: theme.colorScheme.error,
          isLoading: bogoOfferController.isLeaveLoading,
          onPressed: () => showCustomBottomSheet(child: LeaveBogoOfferConfirmationBottomSheet(onConfirm: () => _leaveBogoOffer(bogoOfferController))),
        ),
      );
    });
  }

  
  Widget _buildAdminRequestPromptBar(ThemeData theme) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'reject'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          // Both buttons share the controller's respond flag, so the approve-side
          // marker keeps this one from spinning along with it.
          isLoading: bogoOfferController.isRespondLoading && !_isApprovingRequest,
          onPressed: () => showCustomBottomSheet(
            child: RejectAdminRequestBottomSheet(onSubmit: (reason) => _declineAdminRequest(bogoOfferController, reason: reason)),
          ),
        ),
        right: CustomButtonWidget(
          buttonText: 'approve'.tr,
          isLoading: _isApprovingRequest,
          onPressed: () => _approveAdminRequestAsIs(bogoOfferController),
        ),
      );
    });
  }

  Widget _buildApproveOrSubmitBar(ThemeData theme, BogoOffer details) {
    final BogoOfferInfo info = _mapOfferInfo(details);
    final List<BogoSelectedFoodResult> currentBuyItems = _buyItemKey.currentState?.selectedItems ?? info.buyItems;
    final List<BogoSelectedFoodResult> currentGetItems = _getItemKey.currentState?.selectedItems ?? info.getItems;
    final bool hasChanged = !_isSameSelection(currentBuyItems, info.buyItems) || !_isSameSelection(currentGetItems, info.getItems);

    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'reset'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          onPressed: _resetSelections,
        ),
        right: CustomButtonWidget(
          buttonText: hasChanged ? 'submit'.tr : 'approve'.tr,
          isLoading: hasChanged ? bogoOfferController.isResubmitLoading : bogoOfferController.isRespondLoading,
          onPressed: () => hasChanged ? _resubmitBogoOffer(bogoOfferController) : _approveAdminRequest(bogoOfferController),
        ),
      );
    });
  }

  Widget _buildEditableBottomBar(ThemeData theme) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'reset'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          onPressed: _resetSelections,
        ),
        right: CustomButtonWidget(
          buttonText: _isResubmitting ? 'resubmit'.tr : 'join'.tr,
          isLoading: _isResubmitting ? bogoOfferController.isResubmitLoading : bogoOfferController.isJoinLoading,
          onPressed: () => _isResubmitting ? _resubmitBogoOffer(bogoOfferController) : _joinBogoOffer(bogoOfferController),
        ),
      );
    });
  }

  Widget _buildResubmitPromptBottomBar(ThemeData theme, bool canRespond) {
    if(!canRespond) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'cancel'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          onPressed: () => Navigator.pop(context),
        ),
        right: CustomButtonWidget(
          buttonText: 'edit_and_resubmit'.tr,
          onPressed: () => setState(() => _isResubmitting = true),
        ),
      );
    }

    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'cancel'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          isLoading: bogoOfferController.isRespondLoading,
          onPressed: () => _declineAdminRequest(bogoOfferController),
        ),
        right: CustomButtonWidget(
          buttonText: 'edit_and_resubmit'.tr,
          onPressed: () => setState(() => _isResubmitting = true),
        ),
      );
    });
  }

  Future<void> _respondToAdminRequest(BogoOfferController bogoOfferController, {required String status, String? reason}) async {
    final bool isSuccess = await bogoOfferController.respondToBogoOffer(widget.offerId!, status: status, rejectionReason: reason);
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _declineAdminRequest(BogoOfferController bogoOfferController, {String? reason}) {
    return _respondToAdminRequest(bogoOfferController, status: BogoOfferStatus.rejected, reason: reason);
  }

  /// Approving the admin's request as it stands — the items are the admin's own, so
  /// there is nothing of the restaurant's to validate before answering.
  Future<void> _approveAdminRequestAsIs(BogoOfferController bogoOfferController) async {
    setState(() => _isApprovingRequest = true);

    await _respondToAdminRequest(bogoOfferController, status: BogoOfferStatus.approved);

    if(mounted) {
      setState(() => _isApprovingRequest = false);
    }
  }

  Future<void> _approveAdminRequest(BogoOfferController bogoOfferController) async {
    final List<BogoSelectedFoodResult> buyItems = _buyItemKey.currentState?.selectedItems ?? [];
    final List<BogoSelectedFoodResult> getItems = _getItemKey.currentState?.selectedItems ?? [];
    final int buyQtySum = buyItems.fold(0, (sum, item) => sum + item.quantity);
    final int getQtySum = getItems.fold(0, (sum, item) => sum + item.quantity);

    if(buyQtySum != _buyQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_buyQuantity ${_buyQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_quantity_for_this_bogo_offer'.tr}');
      return;
    }
    if(getQtySum != _getQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_getQuantity ${_getQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_get_for_this_bogo_offer'.tr}');
      return;
    }

    final bool isSuccess = await bogoOfferController.respondToBogoOffer(widget.offerId!, status: BogoOfferStatus.approved);
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _resubmitBogoOffer(BogoOfferController bogoOfferController) async {
    final List<BogoSelectedFoodResult> buyItems = _buyItemKey.currentState?.selectedItems ?? [];
    final List<BogoSelectedFoodResult> getItems = _getItemKey.currentState?.selectedItems ?? [];
    final int buyQtySum = buyItems.fold(0, (sum, item) => sum + item.quantity);
    final int getQtySum = getItems.fold(0, (sum, item) => sum + item.quantity);

    if(buyQtySum != _buyQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_buyQuantity ${_buyQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_quantity_for_this_bogo_offer'.tr}');
      return;
    }
    if(getQtySum != _getQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_getQuantity ${_getQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_get_for_this_bogo_offer'.tr}');
      return;
    }

    final bool isSuccess = await bogoOfferController.resubmitBogoOffer(
      widget.offerId!,
      buyItems.map(_toJoinItem).toList(),
      getItems.map(_toJoinItem).toList(),
    );
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _joinBogoOffer(BogoOfferController bogoOfferController) async {
    final List<BogoSelectedFoodResult> buyItems = _buyItemKey.currentState?.selectedItems ?? [];
    final List<BogoSelectedFoodResult> getItems = _getItemKey.currentState?.selectedItems ?? [];
    final int buyQtySum = buyItems.fold(0, (sum, item) => sum + item.quantity);
    final int getQtySum = getItems.fold(0, (sum, item) => sum + item.quantity);

    if(buyQtySum != _buyQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_buyQuantity ${_buyQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_quantity_for_this_bogo_offer'.tr}');
      return;
    }
    if(getQtySum != _getQuantity) {
      showCustomSnackBar('${'you_must_add'.tr} $_getQuantity ${_getQuantity == 1 ? 'food'.tr : 'foods'.tr} ${'as_the_buy_get_for_this_bogo_offer'.tr}');
      return;
    }

    final bool isSuccess = await bogoOfferController.joinBogoOffer(
      widget.offerId!,
      buyItems.map(_toJoinItem).toList(),
      getItems.map(_toJoinItem).toList(),
    );
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildApprovedBottomBar(ThemeData theme) {
    return GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
      return _buildActionBar(theme,
        left: CustomButtonWidget(
          buttonText: 'reset'.tr,
          color: theme.disabledColor.withValues(alpha: 0.2),
          textColor: theme.textTheme.bodyLarge!.color,
          onPressed: () {
          },
        ),
        right: CustomButtonWidget(
          buttonText: 'leave'.tr,
          color: theme.colorScheme.error,
          isLoading: bogoOfferController.isLeaveLoading,
          onPressed: () => showCustomBottomSheet(child: LeaveBogoOfferConfirmationBottomSheet(onConfirm: () => _leaveBogoOffer(bogoOfferController))),
        ),
      );
    });
  }

  Future<void> _leaveBogoOffer(BogoOfferController bogoOfferController) async {
    final bool isSuccess = await bogoOfferController.leaveBogoOffer(widget.offerId!);
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
      if(mounted) {
        Navigator.pop(context);
      }
    }
  }
}

