part of '../../screen/bogo_offer_setup_screen.dart';

class _ItemDropdownOverlay extends StatelessWidget {
  final ThemeData theme;
  final LayerLink layerLink;
  final double width;
  final bool showAbove;
  final double maxHeight;
  final BogoOfferController bogoOfferController;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final String searchQuery;
  final Set<int> selectedIds;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onDismiss;
  final Future<void> Function(BuildContext context, Product item) onItemTap;

  const _ItemDropdownOverlay({
    required this.theme, required this.layerLink, required this.width, required this.showAbove, required this.maxHeight,
    required this.bogoOfferController, required this.searchController, required this.scrollController, required this.searchQuery,
    required this.selectedIds, required this.onSearchChanged, required this.onDismiss, required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Product>? productList = bogoOfferController.bogoFoods;
    final List<Product> filteredItems = productList == null ? [] : searchQuery.isEmpty
        ? productList
        : productList.where((item) => (item.name ?? '').toLowerCase().contains(searchQuery)).toList();

    return Stack(children: [

      Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onDismiss,
        ),
      ),

      CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
        followerAnchor: showAbove ? Alignment.bottomLeft : Alignment.topLeft,
        offset: Offset(0, showAbove ? -4 : 4),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: theme.cardColor,
          child: Container(
            width: width,
            constraints: BoxConstraints(maxHeight: maxHeight),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              TextField(
                controller: searchController,
                autofocus: false,
                onChanged: onSearchChanged,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                decoration: InputDecoration(
                  hintText: 'search_by_food_name'.tr,
                  hintStyle: robotoRegular.copyWith(color: theme.hintColor),
                  prefixIcon: Icon(Icons.search, color: theme.hintColor, size: 20),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge*2),
                    borderSide: BorderSide(color: theme.disabledColor.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge*2),
                    borderSide: BorderSide(color: theme.disabledColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge*2),
                    borderSide: BorderSide(color: theme.primaryColor),
                  ),
                ),
              ),

              Flexible(
                child: productList == null ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child: Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                ) : filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                        child: Text('no_food_found'.tr, style: robotoRegular.copyWith(color: theme.hintColor)),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: filteredItems.length,
                        separatorBuilder: (context, index) => SizedBox(height: Dimensions.paddingSizeSmall),
                        itemBuilder: (context, index) {
                          final Product item = filteredItems[index];
                          // Already picked once doesn't block re-selection — the vendor can add the
                          // same food again with a different size/add-ons combination. Exact-duplicate
                          // combinations are rejected after the variation picker, not here.
                          final bool isAlreadyAdded = item.id != null && selectedIds.contains(item.id);
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              border:  Border.all(color: theme.disabledColor.withValues(alpha: 0.2), width: 1),
                            ),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImageWidget(image: item.imageFullUrl ?? '', height: 40, width: 40, fit: BoxFit.cover),
                              ),
                              title: Text(
                                item.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                              subtitle: Text(item.restaurantCategoryName ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor)),
                              trailing: isAlreadyAdded ? Icon(Icons.check_circle_outline, color: theme.primaryColor, size: 18) : null,
                              onTap: () => onItemTap(context, item),
                            ),
                          );
                        },
                      ),
              ),

            ]),
          ),
        ),
      ),

    ]);
  }
}
