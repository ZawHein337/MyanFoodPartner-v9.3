part of "../../screen/bogo_offer_setup_screen.dart";

class _ItemQuantitySection extends StatelessWidget {
  final String label;
  final int quantity;
  final String hintSuffixKey;
  final GlobalKey<_SelectItemFieldState> selectItemKey;
  final bool allowRemoveSelection;
  final List<BogoSelectedFoodResult> initialItems;
  final VoidCallback? onChanged;
  const _ItemQuantitySection({
    required this.label, required this.quantity, required this.hintSuffixKey,
    required this.selectItemKey, required this.allowRemoveSelection, this.initialItems = const [], this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: theme.disabledColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text(label, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          'customers_must_buy_the_selected_items_with_the_specific_quantities_to_qualify_for_the_bogo_offer'.tr,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E7),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 16, width: 16,
              decoration: const BoxDecoration(color: Color(0xFFFFA726), shape: BoxShape.circle),
              child: const Icon(Icons.priority_high, color: Colors.white, size: 12),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Expanded(
              child: Text(
                '${'you_must_add'.tr} $quantity ${quantity == 1 ? 'food'.tr : 'foods'.tr} ${hintSuffixKey.tr}',
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF7A5C00)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),

        _SelectItemField(
          key: selectItemKey, maxCount: quantity, allowRemoveSelection: allowRemoveSelection,
          initialItems: initialItems, onChanged: onChanged,
        ),

      ]),
    );
  }
}

class _SelectItemField extends StatefulWidget {
  final int maxCount;
  final bool allowRemoveSelection;
  final List<BogoSelectedFoodResult> initialItems;
  final VoidCallback? onChanged;
  const _SelectItemField({
    super.key, required this.maxCount, required this.allowRemoveSelection, this.initialItems = const [], this.onChanged,
  });

  @override
  State<_SelectItemField> createState() => _SelectItemFieldState();
}

class _SelectItemFieldState extends State<_SelectItemField> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _dropdownScrollController = ScrollController();
  late final List<BogoSelectedFoodResult> _selectedItems = List.of(widget.initialItems);
  String _searchQuery = '';

  bool get _isFull => _selectedItems.length >= widget.maxCount;
  List<BogoSelectedFoodResult> get selectedItems => _selectedItems;

  @override
  void dispose() {
    _dropdownScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value.trim().toLowerCase());
  }

  void _toggleOverlay() {
    if(_isFull) return;

    if(_overlayController.isShowing) {
      _overlayController.hide();
    } else {
      setState(() {
        _searchController.clear();
        _searchQuery = '';
      });
      _overlayController.show();
    }
  }

  Future<void> _openFoodDetails(BuildContext context, Product item) async {
    final BogoSelectedFoodResult? result = await showModalBottomSheet<BogoSelectedFoodResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BogoFoodDetailsBottomSheet(product: item),
    );

    if(result == null) return;

    setState(() => _selectedItems.add(result));
    _overlayController.hide();
    widget.onChanged?.call();
  }

  void _removeSelectedItem(int index) {
    setState(() => _selectedItems.removeAt(index));
    widget.onChanged?.call();
  }

  void reset() {
    if(_overlayController.isShowing) {
      _overlayController.hide();
    }
    setState(() {
      _selectedItems.clear();
      _selectedItems.addAll(widget.initialItems);
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (overlayContext) {
              final RenderBox? fieldBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
              final double width = fieldBox?.size.width ?? 280;
              final double fieldHeight = fieldBox?.size.height ?? 0;
              final double fieldTop = fieldBox?.localToGlobal(Offset.zero).dy ?? 0;
              final double screenHeight = MediaQuery.of(context).size.height;

              const double preferredDropdownHeight = 280;
              final double spaceBelow = screenHeight - (fieldTop + fieldHeight);
              final double spaceAbove = fieldTop;
              final bool showAbove = spaceBelow < preferredDropdownHeight && spaceAbove > spaceBelow;
              final double maxDropdownHeight = (showAbove ? spaceAbove : spaceBelow) - Dimensions.paddingSizeDefault;

              return _ItemDropdownOverlay(
                theme: theme,
                layerLink: _layerLink,
                width: width,
                showAbove: showAbove,
                maxHeight: maxDropdownHeight.clamp(150, preferredDropdownHeight),
                bogoOfferController: bogoOfferController,
                searchController: _searchController,
                scrollController: _dropdownScrollController,
                searchQuery: _searchQuery,
                selectedIds: _selectedItems.map((e) => e.product.id).whereType<int>().toSet(),
                onSearchChanged: _onSearchChanged,
                onDismiss: _overlayController.hide,
                onItemTap: _openFoodDetails,
              );
            },
            child: Opacity(
              opacity: _isFull ? 0.5 : 1,
              child: Container(
                key: _fieldKey,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border.all(color: theme.disabledColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  onTap: _toggleOverlay,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'select_item'.tr,
                            style: robotoRegular.copyWith(color: theme.hintColor),
                            children: [
                              TextSpan(text: ' *', style: robotoRegular.copyWith(color: theme.colorScheme.error)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Icon(Icons.arrow_drop_down, color: theme.hintColor),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      SizedBox(height: Dimensions.paddingSizeExtraSmall),

      if(_selectedItems.isNotEmpty)
        ...List.generate(_selectedItems.length * 2 - 1, (i) {
          if(i.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Expanded(child: Divider(color: theme.disabledColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text('and'.tr.toUpperCase(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor)),
                ),
                Expanded(child: Divider(color: theme.disabledColor)),
              ]),
            );
          }

          final int index = i ~/ 2;
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? Dimensions.paddingSizeSmall : 0),
            child: _SelectedFoodCardWidget(
              result: _selectedItems[index],
              onRemove: widget.allowRemoveSelection ? () => _removeSelectedItem(index) : null,
            ),
          );
        }),

    ]);
  }
}
