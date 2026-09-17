import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/assignable_food_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AssignMyCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const AssignMyCategoryScreen({super.key, required this.categoryId, required this.categoryName});

  static Future<T?> show<T>({required int categoryId, required String categoryName}) {
    return showModalBottomSheet<T>(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignMyCategoryScreen(categoryId: categoryId, categoryName: categoryName),
    );
  }

  @override
  State<AssignMyCategoryScreen> createState() => _AssignMyCategoryScreenState();
}

class _AssignMyCategoryScreenState extends State<AssignMyCategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIds = {};
  final Set<int> _originalAssignedIds = {};
  final Set<int> _initializedIds = {};
  Timer? _searchDebounce;
  String _lastSearchText = '';

  // Pre-selects foods already assigned from API, preserving the user's manual
  // toggles across pagination by only initializing each food once.
  void _syncInitialSelection(List<AssignableFood> foods) {
    for (final food in foods) {
      final int? id = food.id;
      if (id == null || _initializedIds.contains(id)) {
        continue;
      }
      _initializedIds.add(id);
      if (food.isAssigned ?? false) {
        _originalAssignedIds.add(id);
        _selectedIds.add(id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().resetMyCategoryForm();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CategoryController>().getAssignableFoods(offset: '1', categoryId: widget.categoryId, search: _lastSearchText);

      _scrollController.addListener(() {
        final ctrl = Get.find<CategoryController>();
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
            && ctrl.assignableFoodList != null
            && !ctrl.isAssignableFoodLoading) {
          final int pageSize = (ctrl.assignableFoodPageSize! / 25).ceil();
          if (ctrl.assignableFoodOffset < pageSize) {
            ctrl.setAssignableFoodOffset(ctrl.assignableFoodOffset + 1);
            ctrl.showAssignableFoodBottomLoader();
            ctrl.getAssignableFoods(offset: ctrl.assignableFoodOffset.toString(), categoryId: widget.categoryId, search: _lastSearchText);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchFood(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final String search = value.trim();
      if (_lastSearchText == search) {
        return;
      }
      _lastSearchText = search;
      Get.find<CategoryController>().getAssignableFoods(offset: '1', categoryId: widget.categoryId, search: search);
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _reset() {
    setState(() {
      _selectedIds..clear()..addAll(_originalAssignedIds);
    });
  }

  Future<void> _save() async {
    final CategoryController controller = Get.find<CategoryController>();
    final List<AssignableFood>? foods = controller.assignableFoodList;

    // No assignable foods to work with → nothing to save, just close without error.
    if (foods == null || foods.isEmpty) {
      Get.back();
      return;
    }

    if (_selectedIds.isEmpty) {
      showCustomSnackBar('assign_at_least_one_food'.tr, isError: true);
      return;
    }
    final bool success = await controller.assignFoodsToCategory(widget.categoryId, _selectedIds.toList());
    if (success) {
      Get.back();
      showCustomSnackBar('category_updated_successfully'.tr, isError: false);
      setState(() => _selectedIds.clear());
      controller.getAssignableFoods(offset: '1', categoryId: widget.categoryId, search: _lastSearchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [

            _BottomSheetHeader(title: widget.categoryName),

            Expanded(
              child: GetBuilder<CategoryController>(builder: (ctrl) {
                final List<AssignableFood>? foods = ctrl.assignableFoodList;

                if (foods != null) {
                  _syncInitialSelection(foods);
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [

                    SliverToBoxAdapter(
                      child: _TopMessagesSection(
                        unassignedCount: ctrl.assignableUnassignedCount ?? 0,
                      ),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SearchHeaderDelegate(
                        child: _SearchAndListHeader(
                          controller: _searchController,
                          selectedCount: _selectedIds.length,
                          onChanged: _searchFood,
                        ),
                      ),
                    ),

                    foods == null ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ) : foods.isEmpty ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                        child: Text('no_food_found'.tr),
                      )),
                    ) : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == foods.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                  ),
                                ),
                              );
                            }

                            final food = foods[index];
                            final bool selected = _selectedIds.contains(food.id);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: _AssignFoodCard(
                                food: food,
                                selected: selected,
                                onTap: () => _toggleSelection(food.id!),
                              ),
                            );
                          },
                          childCount: foods.length + (ctrl.isAssignableFoodLoading ? 1 : 0),
                        ),
                      ),
                    ),

                  ],
                );
              }),
            ),

            GetBuilder<CategoryController>(
              builder: (ctrl) => _BottomActionBar(
                onReset: _reset,
                onSave: _save,
                isSaveLoading: ctrl.isAssignSubmitLoading,
                showSave: ctrl.assignableFoodList?.isNotEmpty ?? false,
              ),
            ),

          ]),
        ),
      ),
    );
  }
}

class _BottomSheetHeader extends StatelessWidget {
  final String title;
  const _BottomSheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
        child: Column(children: [

          Container(
            height: 5,
            width: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [

            const SizedBox(width: 40),

            Expanded(
              child: Text(
                title,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Icon(Icons.close, color: Theme.of(context).hintColor),
              ),
            ),

          ]),

          Text(
            'Linked Unsigned Items',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        ]),
      ),
    );
  }
}

class _TopMessagesSection extends StatelessWidget {
  final int unassignedCount;
  const _TopMessagesSection({required this.unassignedCount});

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
      child: Column(children: [

        _MessageCard(
          icon: Icons.info,
          iconColor: const Color(0xFFFFB233),
          backgroundColor: const Color(0xFFFFF7E8),
          child: Text(
            'assign_category_note'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, height: 1.5, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        if(unassignedCount > 0) _MessageCard(
          icon: Icons.warning_rounded,
          iconColor: const Color(0xFFFF4D4F),
          backgroundColor: const Color(0xFFFFE8E8),
          child: RichText(
            text: TextSpan(
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, height: 1.5, color: Theme.of(context).textTheme.bodyLarge!.color),
              children: [
                TextSpan(text: '${'there_are'.tr} '),
                TextSpan(text: '$unassignedCount ${'items'.tr.toLowerCase()}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
                TextSpan(text: ' ${'unassigned_items_message'.tr}'),
              ],
            ),
          ),
        ),

      ]),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Widget child;
  const _MessageCard({required this.icon, required this.iconColor, required this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: child),

      ]),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _SearchHeaderDelegate({required this.child});

  @override
  double get minExtent => 118;

  @override
  double get maxExtent => 118;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

class _SearchAndListHeader extends StatelessWidget {
  final TextEditingController controller;
  final int selectedCount;
  final ValueChanged<String> onChanged;
  const _SearchAndListHeader({required this.controller, required this.selectedCount, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
      child: Column(children: [

        TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'search_by_food_name'.tr,
            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
            prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 14),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).disabledColor.withValues(alpha: 0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          Expanded(child: Text('item_list'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),

          Text('$selectedCount ${'selected'.tr}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),

        ]),

      ]),
    );
  }
}

class _AssignFoodCard extends StatelessWidget {
  final AssignableFood food;
  final bool selected;
  final VoidCallback? onTap;
  const _AssignFoodCard({
    required this.food,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color disabledColor = Theme.of(context).disabledColor;

    final Color cardColor = Theme.of(context).cardColor;
    final Color borderColor = selected ? primaryColor.withValues(alpha: 0.5) : disabledColor.withValues(alpha: 0.16);
    const List<BoxShadow> shadow = [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 0)];
    final IconData checkIcon = selected ? Icons.check_box : Icons.check_box_outline_blank;
    final Color checkColor = selected ? primaryColor : disabledColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: borderColor),
          boxShadow: shadow,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            child: food.imageFullUrl != null ? CustomImageWidget(image: food.imageFullUrl!, height: 70, width: 70, fit: BoxFit.cover,) : Container(
              height: 70, width: 70,
              decoration: BoxDecoration(
                color: disabledColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
              ),
              child: Icon(Icons.fastfood, color: disabledColor),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(
                'ID #${food.id}',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 2),

              Text(
                food.name ?? '',
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${'price'.tr} : ${PriceConverter.convertPrice(food.price)}  |  ${'variation'.tr} : ${food.variationsCount ?? 0}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),

            ]),
          ),

          Icon(checkIcon, color: checkColor, size: 26),

        ]),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSave;
  final bool isSaveLoading;
  final bool showSave;
  const _BottomActionBar({required this.onReset, required this.onSave, required this.isSaveLoading, required this.showSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault,
        Dimensions.paddingSizeSmall,
        Dimensions.paddingSizeDefault,
        MediaQuery.of(context).padding.bottom + Dimensions.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
      ),
      child: Row(children: [

        if (showSave) ...[
          Expanded(
            child: CustomButtonWidget(
              buttonText: 'reset'.tr,
              transparent: true,
              isBorder: true,
              height: 50,
              onPressed: onReset,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
        ],

        Expanded(
          child: CustomButtonWidget(
            buttonText: showSave ? 'save'.tr : 'close'.tr,
            height: 50,
            isLoading: isSaveLoading,
            onPressed: isSaveLoading ? null : onSave,
          ),
        ),

      ]),
    );
  }
}
