import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class BogoOrderItemGroup {
  final String groupId;
  final List<OrderDetailsModel> buyItems;
  final List<OrderDetailsModel> freeItems;
  const BogoOrderItemGroup({required this.groupId, required this.buyItems, required this.freeItems});
}

List<Object> groupBogoOrderDetails(List<OrderDetailsModel> items) {
  final List<Object> result = [];
  final Map<String, BogoOrderItemGroup> groupsById = {};

  for(final OrderDetailsModel item in items) {
    if(!item.isBogoItem) {
      result.add(item);
      continue;
    }

    final String groupId = item.bogoGroupId!;
    BogoOrderItemGroup? group = groupsById[groupId];
    if(group == null) {
      group = BogoOrderItemGroup(groupId: groupId, buyItems: [], freeItems: []);
      groupsById[groupId] = group;
      result.add(group);
    }
    (item.isFree ? group.freeItems : group.buyItems).add(item);
  }

  return result;
}

class BogoOrderItemWidget extends StatelessWidget {
  final BogoOrderItemGroup group;
  const BogoOrderItemWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final OrderDetailsModel? primary = group.buyItems.isNotEmpty ? group.buyItems.first : (group.freeItems.isNotEmpty ? group.freeItems.first : null);
    final double totalPrice = group.buyItems.fold(0.0, (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 1)));
    final int buyQty = group.buyItems.fold(0, (sum, item) => sum + (item.quantity ?? 0));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(children: [
        Expanded(
          child: Text(
            primary?.foodDetails?.name ?? '',
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Text('${'qty'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
        Text(buyQty.toString(), style: robotoMedium.copyWith(color: theme.primaryColor, fontSize: Dimensions.fontSizeSmall)),
      ]),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      Text(PriceConverter.convertPrice(totalPrice), style: robotoMedium, textDirection: TextDirection.ltr),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _BogoItemGroupColumn(label: 'buying_item'.tr, items: group.buyItems),
        const SizedBox(width: Dimensions.paddingSizeLarge),
        _BogoItemGroupColumn(label: 'free_item'.tr, items: group.freeItems),
      ]),

    ]);
  }
}

class _BogoItemGroupColumn extends StatelessWidget {
  final String label;
  final List<OrderDetailsModel> items;
  const _BogoItemGroupColumn({required this.label, required this.items});

  static const double _size = 44;
  static const double _overlap = 26;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> thumbnails = items.map((item) => item.foodDetails?.imageFullUrl ?? '').toList();
    final List<String> visible = thumbnails.take(2).toList();
    final int overflow = thumbnails.length - visible.length;
    final int cardCount = visible.length + (overflow > 0 ? 1 : 0);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: theme.hintColor)),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      visible.isEmpty ? const SizedBox() : SizedBox(
        height: _size,
        width: _size + (cardCount - 1) * _overlap,
        child: Stack(children: [
          ...List.generate(visible.length, (index) => Positioned(
            left: index * _overlap,
            child: Container(
              width: _size, height: _size,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusMedium)),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                border: Border.all(color: theme.cardColor, width: 2),
              ),
              child: CustomImageWidget(image: visible[index], height: _size, width: _size, fit: BoxFit.cover),
            ),
          )),

          if(overflow > 0) Positioned(
            left: visible.length * _overlap,
            child: Container(
              height: _size, width: _size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                border: Border.all(color: theme.cardColor, width: 2),
              ),
              child: Text('+$overflow', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ),
          ),
        ]),
      ),
    ]);
  }
}
