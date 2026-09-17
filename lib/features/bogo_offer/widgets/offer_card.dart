part of "../screen/bogo_campaign_list_screen.dart";

class _OfferCard extends StatefulWidget {
  final BogoOffer offer;
  const _OfferCard({required this.offer});

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard> {
  bool _isLeaving = false;
  bool _isApproving = false;

  Future<void> _leaveOffer() async {
    final BogoOfferController bogoOfferController = Get.find<BogoOfferController>();
    setState(() => _isLeaving = true);

    final bool isSuccess = await bogoOfferController.leaveBogoOffer(widget.offer.id!);
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
    }
    if(mounted) {
      setState(() => _isLeaving = false);
    }
  }

  Future<void> _approveOffer() async {
    final BogoOfferController bogoOfferController = Get.find<BogoOfferController>();
    setState(() => _isApproving = true);

    final bool isSuccess = await bogoOfferController.respondToBogoOffer(widget.offer.id!, status: BogoOfferStatus.approved);
    if(isSuccess) {
      bogoOfferController.getBogoOfferList(offset: '1');
    }
    if(mounted) {
      setState(() => _isApproving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final BogoOffer offer = widget.offer;
    final bool isExpired = offer.isExpired ?? false;
    final bool isJoined = offer.enrollmentState != 'not_joined';
    final bool isAdminRequested = offer.enrollmentState == 'admin_requested';
    final bool isApproved = offer.enrollmentState == 'approved';
    final bool isRejected = offer.enrollmentState == 'rejected';
    final Color statusBackgroundColor = isApproved ? theme.secondaryHeaderColor : isRejected ? theme.colorScheme.error : theme.disabledColor;
    final Color statusTextColor = isApproved ? theme.secondaryHeaderColor : isRejected ? theme.colorScheme.error : theme.hintColor;
    final int buyQuantity = offer.buyQty ?? 0;
    final int getQuantity = offer.getQty ?? 0;
    final String dateRange = '${offer.startDate != null ? DateConverter.convertDateToDate(offer.startDate!) : ''} - ${offer.endDate != null ? DateConverter.convertDateToDate(offer.endDate!) : ''}';

    return CustomInkWellWidget(
      onTap: () {
        Get.to(() => BogoOfferSetupScreen(
          buyQuantity: buyQuantity, getQuantity: getQuantity, isExpired: isExpired,
          offerId: offer.id, status: offer.enrollmentState == 'not_joined' ? null : offer.enrollmentState,
        ));
      },
      radius: Dimensions.radiusMedium,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          boxShadow: [BoxShadow(color: theme.shadowColor, spreadRadius: 0, blurRadius: 5)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CustomImageWidget(image: offer.imageFullUrl ?? '', height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [
            Expanded(
              child: Text(offer.title ?? '', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),

            if(offer.isNotVisibleToCustomers)
              _VisibilityWarningTooltip(reasons: offer.visibilityReasons ?? const []),

            if(isJoined)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: statusBackgroundColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  (offer.enrollmentState ?? '').tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: statusTextColor),
                ),
              ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [
            Icon(Icons.calendar_today_outlined, size: 14, color: theme.hintColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Expanded(
              child: Text(
                dateRange, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: theme.textTheme.bodySmall!.color),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            isExpired ? CustomButtonWidget(
              buttonText: 'expired'.tr,
              onPressed: null,
              width: 78, height: 32,
              radius: Dimensions.radiusSmall,
              fontSize: Dimensions.fontSizeSmall,
              buttonDisabledColor: theme.disabledColor,
            ) : CustomButtonWidget(
              buttonText: isAdminRequested ? 'approve'.tr : isJoined ? 'leave'.tr : 'join'.tr,
              isLoading: isAdminRequested ? _isApproving : isJoined && _isLeaving,
              loadingTextVisible: false,
              onPressed: () {
                if(isAdminRequested) {
                  _approveOffer();
                } else if(isJoined) {
                  showCustomBottomSheet(child: LeaveBogoOfferConfirmationBottomSheet(onConfirm: _leaveOffer));
                } else {
                  Get.to(() => BogoOfferSetupScreen(
                    buyQuantity: buyQuantity, getQuantity: getQuantity, offerId: offer.id,
                  ));
                }
              },
              width: 78, height: 32,
              radius: Dimensions.radiusSmall,
              fontSize: Dimensions.fontSizeSmall,
              color: isAdminRequested ? theme.primaryColor : isJoined ? theme.colorScheme.error : theme.primaryColor,
            ),
          ]),

        ]),
      ),
    );
  }
}


class _VisibilityWarningTooltip extends StatefulWidget {
  final List<String> reasons;
  const _VisibilityWarningTooltip({required this.reasons});

  @override
  State<_VisibilityWarningTooltip> createState() => _VisibilityWarningTooltipState();
}

class _VisibilityWarningTooltipState extends State<_VisibilityWarningTooltip> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     Color noticeColor = context.theme.primaryColor;

    final String message = widget.reasons.isEmpty
        ? 'offer_not_visible_to_customers'.tr
        : '${'reasons_the_bogo_offer_is_on_hold'.tr}\n${widget.reasons.map((reason) => '•  $reason').join('\n')}';

    return Tooltip(
      key: _tooltipKey,
      message: message,
      triggerMode: TooltipTriggerMode.manual,
      preferBelow: false,
      verticalOffset: 15,
      showDuration: const Duration(seconds: 8),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: theme.textTheme.bodyLarge!.color,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      textStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: theme.cardColor),
      child: GestureDetector(
        onTap: () => _tooltipKey.currentState?.ensureTooltipVisible(),
        child: Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
          child: Icon(Icons.warning_amber_rounded, size: 18, color: noticeColor),
        ),
      ),
    );
  }
}
