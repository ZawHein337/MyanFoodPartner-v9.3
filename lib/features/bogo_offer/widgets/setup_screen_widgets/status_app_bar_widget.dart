part of '../../screen/bogo_offer_setup_screen.dart';

/// App bar for an already-submitted BOGO offer: "BOGO Offer #id" plus a
/// colored status pill (pending / approved / rejected).
class _StatusAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final int? offerId;
  final String status;
  final VoidCallback? onBackPressed;
  const _StatusAppBarWidget({required this.offerId, required this.status, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Row(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
          child: Text(
            offerId != null ? '${'bogo_offer'.tr} #$offerId' : 'bogo_offer'.tr,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge!.color),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        _StatusPill(status: status),
      ]),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: theme.textTheme.bodyLarge!.color,
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      backgroundColor: theme.cardColor,
      surfaceTintColor: theme.cardColor,
      shadowColor: theme.hintColor.withValues(alpha: 0.5),
      elevation: 2,
      scrolledUnderElevation: 2,
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = switch(status) {
      BogoOfferStatus.approved => theme.secondaryHeaderColor,
      BogoOfferStatus.rejected => theme.colorScheme.error,
      _ => theme.disabledColor,
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Text(status.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: color)),
    );
  }
}
