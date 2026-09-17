import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/quantity_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class BogoVariationSummaryLine {
  final String groupName;
  final String selectedLabels;
  const BogoVariationSummaryLine({required this.groupName, required this.selectedLabels});
}

class BogoSelectedFoodResult {
  final Product product;
  final List<BogoVariationSummaryLine> variationSummaries;
  final int quantity;
  /// Raw, API-shaped selection — sent as-is in the join/resubmit request body.
  final List<OrderVariation> variations;
  final List<int> variationOptionIds;
  final List<AddOn> addOns;
  const BogoSelectedFoodResult({
    required this.product, this.variationSummaries = const [], required this.quantity,
    this.variations = const [], this.variationOptionIds = const [], this.addOns = const [],
  });
}

class BogoFoodDetailsBottomSheet extends StatefulWidget {
  final Product product;
  const BogoFoodDetailsBottomSheet({super.key, required this.product});

  @override
  State<BogoFoodDetailsBottomSheet> createState() => _BogoFoodDetailsBottomSheetState();
}

class _BogoFoodDetailsBottomSheetState extends State<BogoFoodDetailsBottomSheet> {
  Product? _product;
  int _quantity = 1;
  final Map<int, Set<int>> _selectedOptions = {};
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];

  @override
  void initState() {
    super.initState();
    // The dropdown list item already carries full variations/add-ons — no extra fetch needed.
    _product = widget.product;
    _addOnActiveList = List.filled(widget.product.addOns?.length ?? 0, false);
    _addOnQtyList = List.filled(widget.product.addOns?.length ?? 0, 1);
  }

  double get _variationPrice {
    double total = 0;
    _selectedOptions.forEach((groupIndex, optionIndexes) {
      final List<VariationOption>? options = _product?.variations?[groupIndex].variationValues;
      for(int optionIndex in optionIndexes) {
        if(options != null && options.length > optionIndex) {
          total += double.tryParse(options[optionIndex].optionPrice ?? '') ?? 0;
        }
      }
    });
    return total;
  }

  double get _addOnPrice {
    double total = 0;
    final List<AddOns> productAddOns = _product?.addOns ?? [];
    for(int index = 0; index < productAddOns.length; index++) {
      if(index < _addOnActiveList.length && _addOnActiveList[index]) {
        total += (productAddOns[index].price ?? 0) * _addOnQtyList[index];
      }
    }
    return total;
  }

  void _toggleOption(int groupIndex, int optionIndex, bool isMultiSelect) {
    setState(() {
      final Set<int> current = _selectedOptions.putIfAbsent(groupIndex, () => <int>{});
      if(isMultiSelect) {
        current.contains(optionIndex) ? current.remove(optionIndex) : current.add(optionIndex);
      } else {
        current..clear()..add(optionIndex);
      }
    });
  }

  void _toggleAddOn(int index) {
    setState(() => _addOnActiveList[index] = !_addOnActiveList[index]);
  }

  void _setAddOnQuantity(int index, bool isIncrement) {
    setState(() {
      if(isIncrement) {
        _addOnQtyList[index]++;
      } else if(_addOnQtyList[index] > 1) {
        _addOnQtyList[index]--;
      } else {
        _addOnActiveList[index] = false;
      }
    });
  }

  void _onAddPressed() {
    final List<Variation> variations = _product?.variations ?? [];
    for(int groupIndex = 0; groupIndex < variations.length; groupIndex++) {
      final bool isRequired = variations[groupIndex].required == 'on';
      final bool hasSelection = _selectedOptions[groupIndex]?.isNotEmpty ?? false;
      if(isRequired && !hasSelection) {
        showCustomSnackBar('${'choose_a_variation_from'.tr} ${variations[groupIndex].name}');
        return;
      }
    }

    final List<BogoVariationSummaryLine> variationSummaries = [];
    final List<OrderVariation> orderVariations = [];
    final List<int> variationOptionIds = [];
    for(int groupIndex = 0; groupIndex < variations.length; groupIndex++) {
      final Set<int>? optionIndexes = _selectedOptions[groupIndex];
      if(optionIndexes == null || optionIndexes.isEmpty) continue;

      final List<VariationOption>? options = variations[groupIndex].variationValues;
      final List<String> labels = [];
      for(int optionIndex in optionIndexes) {
        if(options == null || options.length <= optionIndex) continue;
        final VariationOption option = options[optionIndex];
        if(option.level != null && option.level!.trim().isNotEmpty) {
          labels.add(option.level!.trim());
        }
        final int? optionId = int.tryParse(option.optionId ?? '');
        if(optionId != null) {
          variationOptionIds.add(optionId);
        }
      }

      if(labels.isNotEmpty) {
        variationSummaries.add(BogoVariationSummaryLine(groupName: variations[groupIndex].name ?? '', selectedLabels: labels.join(', ')));
        orderVariations.add(OrderVariation(name: variations[groupIndex].name, values: OrderVariationValue(label: labels)));
      }
    }

    final List<AddOns> productAddOns = _product?.addOns ?? [];
    final List<AddOn> selectedAddOns = [];
    for(int index = 0; index < productAddOns.length; index++) {
      if(index < _addOnActiveList.length && _addOnActiveList[index]) {
        selectedAddOns.add(AddOn(id: productAddOns[index].id, quantity: _addOnQtyList[index]));
        variationSummaries.add(BogoVariationSummaryLine(
          groupName: 'addons'.tr, selectedLabels: '${productAddOns[index].name ?? ''} x${_addOnQtyList[index]}',
        ));
      }
    }

    Navigator.pop(context, BogoSelectedFoodResult(
      product: _product!, quantity: _quantity, variationSummaries: variationSummaries,
      variations: orderVariations, variationOptionIds: variationOptionIds, addOns: selectedAddOns,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _BuildContent(
      theme: theme,
      product: _product!,
      quantity: _quantity,
      selectedOptions: _selectedOptions,
      variationPrice: _variationPrice,
      addOnActiveList: _addOnActiveList,
      addOnQtyList: _addOnQtyList,
      addOnPrice: _addOnPrice,
      onIncrement: () => setState(() => _quantity++),
      onDecrement: () {
        if(_quantity > 1) setState(() => _quantity--);
      },
      onToggleOption: _toggleOption,
      onToggleAddOn: _toggleAddOn,
      onSetAddOnQuantity: _setAddOnQuantity,
      onAddPressed: _onAddPressed,
    );
  }
}

class _BuildContent extends StatelessWidget {
  final ThemeData theme;
  final Product product;
  final int quantity;
  final Map<int, Set<int>> selectedOptions;
  final double variationPrice;
  final List<bool> addOnActiveList;
  final List<int> addOnQtyList;
  final double addOnPrice;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final void Function(int groupIndex, int optionIndex, bool isMultiSelect) onToggleOption;
  final void Function(int index) onToggleAddOn;
  final void Function(int index, bool isIncrement) onSetAddOnQuantity;
  final VoidCallback onAddPressed;

  const _BuildContent({
    required this.theme, required this.product, required this.quantity, required this.selectedOptions,
    required this.variationPrice, required this.addOnActiveList, required this.addOnQtyList, required this.addOnPrice,
    required this.onIncrement, required this.onDecrement,
    required this.onToggleOption, required this.onToggleAddOn, required this.onSetAddOnQuantity, required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double basePrice = product.price ?? 0;
    final double discount = product.discount ?? 0;
    final String? discountType = product.discountType;
    final double priceWithDiscount = PriceConverter.convertWithDiscount(basePrice, discount, discountType) ?? basePrice;
    final double totalPrice = (priceWithDiscount + variationPrice + addOnPrice) * quantity;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
          ),
          child: Column(children: [

            _StickyHeader(scrollController: scrollController, theme: theme, productName: product.name ?? ''),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(image: product.imageFullUrl ?? '', height: 80, width: 80, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            product.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        product.isHalal == 1 ? Image.asset(Images.halalIcon, height: 18, width: 18) : const SizedBox(),
                      ]),
                      _RatingWidget(rating: product.avgRating ?? 0, ratingCount: product.ratingCount ?? 0),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(children: [
                        Expanded(
                          child: Row(children: [
                            discount > 0 ? Text(
                              PriceConverter.convertPrice(basePrice), textDirection: TextDirection.ltr,
                              style: robotoRegular.copyWith(color: theme.hintColor, decoration: TextDecoration.lineThrough, fontSize: Dimensions.fontSizeSmall),
                            ) : const SizedBox(),
                            SizedBox(width: discount > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                            Text(
                              PriceConverter.convertPrice(priceWithDiscount), textDirection: TextDirection.ltr,
                              style: robotoSemiBold.copyWith(color: theme.primaryColor),
                            ),
                          ]),
                        ),
                        SizedBox(width: Dimensions.paddingSizeSmall),
                        (Get.find<SplashController>().configModel?.toggleVegNonVeg ?? false) ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.disabledColor.withAlpha(80), width: 1.5),
                            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
                            Image.asset(product.veg == 1 ? Images.vegImage : Images.nonVegIcon, height: 18, width: 18),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(product.veg == 1 ? 'veg'.tr : 'non_veg'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ]),
                        ) : const SizedBox(),
                      ]),
                    ])),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(product.description != null && product.description!.isNotEmpty) ...[
                    Text('description'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(product.description!, style: robotoRegular.copyWith(color: theme.hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],

                  if(product.nutrition != null && product.nutrition!.isNotEmpty) ...[
                    Text('nutrition_details'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(product.nutrition!.join(', '), style: robotoRegular.copyWith(color: theme.hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],

                  if(product.allergies != null && product.allergies!.isNotEmpty) ...[
                    Text('allergic_ingredients'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(product.allergies!.join(', '), style: robotoRegular.copyWith(color: theme.hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],

                  if(product.variations != null && product.variations!.isNotEmpty)
                    ...List.generate(product.variations!.length, (groupIndex) => _VariationGroupWidget(
                      theme: theme, product: product, groupIndex: groupIndex,
                      selectedOptionIndexes: selectedOptions[groupIndex] ?? const <int>{},
                      onToggleOption: onToggleOption,
                    )),

                  if(product.addOns != null && product.addOns!.isNotEmpty)
                    _AddOnListWidget(
                      theme: theme, addOns: product.addOns!,
                      activeList: addOnActiveList, qtyList: addOnQtyList,
                      onToggle: onToggleAddOn, onSetQuantity: onSetAddOnQuantity,
                    ),

                ]),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [BoxShadow(color: theme.shadowColor, spreadRadius: 0, blurRadius: 5)],
              ),
              child: SafeArea(
                top: false,
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('total'.tr, style: robotoMedium),
                    PriceConverter.convertAnimationPrice(totalPrice, textStyle: robotoMedium),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomButtonWidget(buttonText: 'add_this_food'.tr, onPressed: onAddPressed),
                ]),
              ),
            ),

          ]),
        );
      },
    );
  }
}

class _StickyHeader extends StatefulWidget {
  final ScrollController scrollController;
  final ThemeData theme;
  final String productName;
  const _StickyHeader({required this.scrollController, required this.theme, required this.productName});

  @override
  State<_StickyHeader> createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<_StickyHeader> {
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShow = widget.scrollController.hasClients && widget.scrollController.offset > 10;
    if(shouldShow != _showTitle) {
      setState(() => _showTitle = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Padding(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall),
      child: Row(children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.centerLeft,
              children: [
                ...previousChildren,
                ?currentChild,
              ],
            ),
            child: _showTitle ? Align(
              key: const ValueKey('title'),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: _showTitle ? const EdgeInsets.only(top: Dimensions.paddingSizeLarge) : EdgeInsets.zero,
                child: Text(
                  widget.productName, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
              ),
            ) : Align(
              key: const ValueKey('handle'),
              alignment: Alignment.center,
              child: Container(
                height: 4, width: 40,
                decoration: BoxDecoration(color: theme.disabledColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: _showTitle ? const EdgeInsets.only(top: Dimensions.paddingSizeLarge) : EdgeInsets.zero,
            child: Icon(Icons.close, size: 22, color: theme.hintColor),
          ),
        ),
      ]),
    );
  }
}

class _VariationGroupWidget extends StatelessWidget {
  final ThemeData theme;
  final Product product;
  final int groupIndex;
  final Set<int> selectedOptionIndexes;
  final void Function(int groupIndex, int optionIndex, bool isMultiSelect) onToggleOption;

  const _VariationGroupWidget({
    required this.theme, required this.product, required this.groupIndex,
    required this.selectedOptionIndexes, required this.onToggleOption,
  });

  @override
  Widget build(BuildContext context) {
    final Variation variation = product.variations![groupIndex];
    final bool isRequired = variation.required == 'on';
    final bool isMultiSelect = variation.type == 'multi';
    final List<VariationOption> options = variation.variationValues ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(variation.name ?? '', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

          if(isRequired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text('required'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.colorScheme.error)),
            ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          isMultiSelect ? 'select_multiple'.tr : 'select_one'.tr,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ...List.generate(options.length, (optionIndex) {
          final VariationOption option = options[optionIndex];
          final bool isSelected = selectedOptionIndexes.contains(optionIndex);
          final double optionPrice = double.tryParse(option.optionPrice ?? '') ?? 0;

          return InkWell(
            onTap: () => onToggleOption(groupIndex, optionIndex, isMultiSelect),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                Icon(
                  isMultiSelect
                      ? (isSelected ? Icons.check_box : Icons.check_box_outline_blank)
                      : (isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                  size: 18, color: isSelected ? theme.primaryColor : theme.hintColor,
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Text(
                    option.level?.trim() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
                  ),
                ),

                Text(
                  PriceConverter.convertPrice(optionPrice), textDirection: TextDirection.ltr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
                ),
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

class _AddOnListWidget extends StatelessWidget {
  final ThemeData theme;
  final List<AddOns> addOns;
  final List<bool> activeList;
  final List<int> qtyList;
  final void Function(int index) onToggle;
  final void Function(int index, bool isIncrement) onSetQuantity;

  const _AddOnListWidget({
    required this.theme, required this.addOns, required this.activeList, required this.qtyList,
    required this.onToggle, required this.onSetQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('addons'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ...List.generate(addOns.length, (index) {
          final AddOns addOn = addOns[index];
          final bool isActive = index < activeList.length && activeList[index];
          final int qty = index < qtyList.length ? qtyList[index] : 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              InkWell(
                onTap: () => onToggle(index),
                child: Checkbox(
                  value: isActive,
                  activeColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  onChanged: (_) => onToggle(index),
                  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                  side: BorderSide(width: 2, color: theme.hintColor),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Text(
                  addOn.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: isActive ? robotoMedium : robotoRegular.copyWith(color: theme.hintColor),
                ),
              ),

              Text(
                (addOn.price ?? 0) > 0 ? PriceConverter.convertPrice(addOn.price) : 'free'.tr,
                textDirection: TextDirection.ltr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor),
              ),

              if(isActive) ...[
                const SizedBox(width: Dimensions.paddingSizeSmall),
                QuantityButton(isIncrement: false, onTap: () => onSetQuantity(index, false)),
                Text('$qty', style: robotoMedium),
                QuantityButton(isIncrement: true, onTap: () => onSetQuantity(index, true)),
              ],
            ]),
          );
        }),
      ]),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  final double rating;
  final int ratingCount;
  const _RatingWidget({required this.rating, required this.ratingCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.star_rounded, color: theme.primaryColor, size: 16),
      const SizedBox(width: 2),

      Text(rating.toStringAsFixed(1), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: 2),

      Text('($ratingCount+)', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor)),
    ]);
  }
}
