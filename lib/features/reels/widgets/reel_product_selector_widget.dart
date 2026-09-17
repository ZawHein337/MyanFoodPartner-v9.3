import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

/// Dropdown-style field for the reel "order now" food with a locally searchable
/// list. The product list and its loading state are owned by the caller.
class ReelProductSelectorWidget extends StatelessWidget {
  final List<Product> products;
  final int? selectedFoodId;
  final bool isLoading;
  final ValueChanged<int?> onSelected;

  const ReelProductSelectorWidget({
    super.key,
    required this.products,
    required this.selectedFoodId,
    required this.isLoading,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Product? selected = products.firstWhereOrNull((p) => p.id == selectedFoodId);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        onTap: isLoading ? null : () => _openSearchSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            Expanded(child: _buildFieldContent(context, selected)),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            isLoading
                ? SizedBox(
                    height: 18, width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor),
                  )
                : Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
          ]),
        ),
      ),
    );
  }

  Widget _buildFieldContent(BuildContext context, Product? selected) {
    if (isLoading) {
      return Text('loading'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor));
    }
    if (selected != null) {
      return Text(
        selected.name ?? '',
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
      );
    }
    return RichText(
      text: TextSpan(
        text: 'select_food'.tr,
        style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
        children: [
          TextSpan(text: ' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
        ],
      ),
    );
  }

  void _openSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductSearchSheet(
        products: products,
        selectedFoodId: selectedFoodId,
        onSelected: onSelected,
      ),
    );
  }
}

class _ProductSearchSheet extends StatefulWidget {
  final List<Product> products;
  final int? selectedFoodId;
  final ValueChanged<int?> onSelected;

  const _ProductSearchSheet({
    required this.products,
    required this.selectedFoodId,
    required this.onSelected,
  });

  @override
  State<_ProductSearchSheet> createState() => _ProductSearchSheetState();
}

class _ProductSearchSheetState extends State<_ProductSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final String query = value.trim().toLowerCase();
    setState(() {
      _filteredProducts = query.isEmpty
          ? widget.products
          : widget.products.where((p) => (p.name ?? '').toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(children: [
          Container(
            height: 4, width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            decoration: InputDecoration(
              hintText: 'search_food'.tr,
              hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text('no_food_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)))
                : ListView.separated(
                    itemCount: _filteredProducts.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
                    itemBuilder: (context, index) {
                      final Product product = _filteredProducts[index];
                      final bool isSelected = product.id == widget.selectedFoodId;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          product.name ?? '',
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20) : null,
                        onTap: () {
                          widget.onSelected(product.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
