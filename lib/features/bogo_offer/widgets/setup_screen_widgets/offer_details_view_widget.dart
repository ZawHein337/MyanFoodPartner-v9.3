part of '../../screen/bogo_offer_setup_screen.dart';

class _OfferDetailsView extends StatelessWidget {
  final BogoOfferInfo info;
  const _OfferDetailsView({required this.info});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        _OfferSummaryCard(info: info),

        // if(info.rejectionReason != null) ...[
        //   const SizedBox(height: Dimensions.paddingSizeDefault),
        //   _RejectionReasonBanner(reason: info.rejectionReason!),
        // ],
        const SizedBox(height: Dimensions.paddingSizeDefault),

        _OfferItemsCard(label: 'buy_item'.tr, items: info.buyItems),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        _OfferItemsCard(label: 'get_item'.tr, items: info.getItems),

      ]),
    );
  }
}

class _OfferSummaryCard extends StatelessWidget {
  final BogoOfferInfo info;
  const _OfferSummaryCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall+2),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusMedium)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          child: CustomImageWidget(image: info.bannerImage, height: 110, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(info.title, style: robotoSemiBold),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ReadMoreText(
          info.description,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
          trimMode: TrimMode.Line,
          trimLines: 2,
          colorClickableText: Colors.blueAccent,
          lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blueAccent),
          moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blueAccent),
          trimCollapsedText: 'see_more'.tr,
          trimExpandedText: ' ${'see_less'.tr}',
        ),
        const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

        _InfoRow(label: 'offer_created'.tr, value: info.createdAt),
        _InfoRow(label: 'usage_limit'.tr, value: '${'per_person'.tr} ${info.usageLimitPerPerson} ${'order'.tr}'),
        _InfoRow(label: 'usage_limit_total'.tr, value: '${info.usageLimitTotal} ${'order'.tr}'),
        _InfoRow(label: 'validity'.tr, value: info.validity, showDivider: false),

      ]),
    );
  }
}

// class _RejectionReasonBanner extends StatelessWidget {
//   final String reason;
//   const _RejectionReasonBanner({required this.reason});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 12),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.error.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//       ),
//       child: Text.rich(
//         TextSpan(children: [
//           TextSpan(text: '${'rejection_reason'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.colorScheme.error)),
//           TextSpan(text: reason, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.colorScheme.error)),
//         ]),
//       ),
//     );
//   }
// }

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  const _InfoRow({required this.label, required this.value, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor)),
          Text(value, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
        ]),
      ),
      if(showDivider) Divider(height: 1, color: theme.disabledColor.withValues(alpha: 0.6)),
    ]);
  }
}

class _OfferItemsCard extends StatelessWidget {
  final String label;
  final List<BogoSelectedFoodResult> items;
  const _OfferItemsCard({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall+2),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusMedium)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text(label, style: robotoSemiBold),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall+1),

        Text(
          'customers_must_buy_the_selected_items_with_the_specific_quantities_to_qualify_for_the_bogo_offer'.tr,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge-1),

        ...List.generate(items.length * 2 - 1, (i) {
          if(i.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Divider(height: 10, color: theme.disabledColor.withValues(alpha: 0.4)),
            );
          }
          return _SelectedFoodCardWidget(result: items[i ~/ 2], onRemove: null);
        }),

      ]),
    );
  }
}
