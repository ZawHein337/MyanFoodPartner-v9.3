import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class FilterDataBottomSheet extends StatelessWidget {
  const FilterDataBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('filter_data'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('foods_type'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Dynamically create filter buttons for food types
              ...restaurantController.productTypeList.map((type) {
                return FilterButton(
                  title: type == 'all' ? 'all_foods'.tr : type == 'veg' ? 'veg_foods'.tr : 'non_veg_foods'.tr,
                  isSelected: restaurantController.selectedFoodType == type,
                  onTap: () {
                    restaurantController.updateSelectedFoodType(type);
                  },
                );
              }),

              const Divider(height: 30),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('foods_stock'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Dynamically create filter buttons for Stock types
              ...restaurantController.foodStockList.map((type) {
                return FilterButton(
                  title: type == 'all' ? 'all'.tr : 'out_of_stock_foods'.tr,
                  isSelected: restaurantController.selectedStockType == type,
                  onTap: () {
                    restaurantController.updateSelectedStockType(type);
                  },
                );
              }),

              const SizedBox(height: 30),

              Row(children: [
                !restaurantController.isFilterClearLoading ? Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'clear_filter'.tr,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      restaurantController.updateSelectedFoodType('all');
                      restaurantController.updateSelectedStockType('all');
                      restaurantController.applyFilters(isClearFilter: true);
                    },
                  ),
                ) : const Expanded(child: Center(child: CircularProgressIndicator())),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                !restaurantController.isLoading ? Expanded(
                  child: CustomButtonWidget(
                    color: Theme.of(context).primaryColor,
                    buttonText: 'filter'.tr,
                    onPressed: () {
                      restaurantController.applyFilters();
                    },
                  ),
                ) : const Expanded(child: Center(child: CircularProgressIndicator())),
              ]),
            ]),
          ),
        ]),
      );
    });
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  const FilterButton({super.key, required this.title, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: robotoRegular),

        RadioGroup(
          groupValue: true,
          onChanged: (bool? value) {
            onTap();
          },
          child: Radio(value: isSelected),
        ),
      ]),
    );
  }
}
