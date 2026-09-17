part of '../../screen/bogo_offer_setup_screen.dart';

class _SelectedFoodCardWidget extends StatelessWidget {
  const _SelectedFoodCardWidget({required this.result, required this.onRemove});

  final BogoSelectedFoodResult result;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Product product = result.product;

    final List<BogoVariationSummaryLine> sizeLines = result.variationSummaries
        .where((line) => line.groupName.trim().toLowerCase() == 'size').toList();
    final BogoVariationSummaryLine? sizeLine = sizeLines.isEmpty ? null : sizeLines.first;
    final List<BogoVariationSummaryLine> otherLines = result.variationSummaries
        .where((line) => line.groupName.trim().toLowerCase() != 'size').toList();

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(image: product.imageFullUrl ?? '', height: 54, width: 54, fit: BoxFit.cover),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            product.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),

          if(sizeLine != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '${sizeLine.groupName} : ${sizeLine.selectedLabels}', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: theme.hintColor),
              ),
            ),

          if(otherLines.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: ReadMoreText.rich(
                TextSpan(children: [
                  for(int i = 0; i < otherLines.length; i++) ...[
                    TextSpan(
                      text: '${otherLines[i].groupName}: ',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: theme.hintColor),
                    ),
                    TextSpan(
                      text: otherLines[i].selectedLabels,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: theme.hintColor),
                    ),
                    if(i != otherLines.length - 1) const TextSpan(text: '   '),
                  ],
                ]),
                trimLines: sizeLine != null ? 1 : 2,
                trimMode: TrimMode.Line,
                colorClickableText: Colors.blueAccent,
                trimCollapsedText: 'see_more'.tr,
                trimExpandedText: ' ${'see_less'.tr}',
                moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.blueAccent),
                lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.blueAccent),
              ),
            ),
        ]),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall),
    
      Column(children: [
        if(onRemove != null) ...[
          InkWell(
            onTap: onRemove,
            child: Icon(Icons.close, size: 16, color: theme.hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        ],

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Text('${result.quantity}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        ),
      ]),
    ]);
  }
}
