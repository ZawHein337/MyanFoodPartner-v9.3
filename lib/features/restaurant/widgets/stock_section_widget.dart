import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class StackSectionWidget extends StatelessWidget {
  final RestaurantController restaurantController;
  final TextEditingController stockTextController;
  const StackSectionWidget({super.key, required this.restaurantController, required this.stockTextController});

  @override
  Widget build(BuildContext context) {
    List<DropdownItem<int>> stockTypeList = _generateStockTypeList(restaurantController.stockTypeList, context);

    return Row(children: [

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).hintColor, width: 0.3),
          ),
          child: CustomDropdownWidget<int>(
            icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
            onChange: (int? value, int index) {
              restaurantController.setStockTypeIndex(index, true);
              stockTextController.text = '';
            },
            dropdownButtonStyle: DropdownButtonStyle(
              height: 50,
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall,
                horizontal: Dimensions.paddingSizeExtraSmall,
              ),
              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            dropdownStyle: DropdownStyle(
              elevation: 10,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            ),
            items: stockTypeList,
            child: Text(
              restaurantController.stockTypeList[restaurantController.stockTypeIndex!]!.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeDefault),
            ),
          ),
        ),

      ])),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        CustomTextFieldWidget(
          hintText: restaurantController.stockTypeIndex == 0 ? 'unlimited'.tr : 'food_stock'.tr,
          labelText: restaurantController.stockTypeIndex == 0 ? 'unlimited'.tr : 'food_stock'.tr,
          controller: stockTextController,
          inputAction: TextInputAction.done,
          inputType: TextInputType.phone,
          showTitle: false,
          readOnly: restaurantController.stockTypeIndex == 0 || (restaurantController.stockTextFieldDisable) ? true : false,
          required: restaurantController.stockTypeIndex != 0 ? true : false,
          validator: (value) => restaurantController.stockTypeIndex != 0 ? (value == null || value.isEmpty) ? 'enter_the_item_stock'.tr : null : null,
        ),

      ])),

    ]);
  }

  List<DropdownItem<int>> _generateStockTypeList(List<String?> typeList, BuildContext context) {
    List<DropdownItem<int>> generateDmTypeList = [];
    for(int index=0; index<typeList.length; index++) {
      generateDmTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${typeList[index]?.tr}',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
      )));
    }
    return generateDmTypeList;
  }
}
