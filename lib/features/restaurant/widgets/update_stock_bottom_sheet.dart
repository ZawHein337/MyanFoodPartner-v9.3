import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class UpdateStockBottomSheet extends StatefulWidget {
  final Product product;
  const UpdateStockBottomSheet({super.key, required this.product});

  @override
  State<UpdateStockBottomSheet> createState() => _UpdateStockBottomSheetState();
}

class _UpdateStockBottomSheetState extends State<UpdateStockBottomSheet> {

  TextEditingController mainStockController = TextEditingController();
  late List<List<TextEditingController>> variationStockControllers;

  @override
  void initState() {
    super.initState();
    mainStockController.text = widget.product.itemStock.toString();
    variationStockControllers = widget.product.variations!.map((variation) => variation.variationValues!.map((variationValue) => TextEditingController(
      text: variationValue.currentStock?.toString() ?? '',
    )).toList()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
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

          Text('update_stock'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

          Flexible(
            child: SingleChildScrollView(
              child: Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('main_stock'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    hintText: 'enter_stock'.tr,
                    controller: mainStockController,
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(children: [
                    Expanded(child: Text('variation'.tr, style: robotoRegular)),

                    Expanded(child: Text('stock'.tr, style: robotoRegular)),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  ListView.builder(
                    itemCount: widget.product.variations!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(widget.product.variations![index].name!, style: robotoBold),

                            const Divider(),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          ListView.builder(
                            itemCount: widget.product.variations![index].variationValues!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {

                              return Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: Row(children: [

                                  Expanded(
                                    child: Text(
                                      '${widget.product.variations![index].variationValues![i].level}',
                                      style: robotoRegular,
                                    ),
                                  ),

                                  Expanded(
                                    child: CustomTextFieldWidget(
                                      hintText: 'enter_stock'.tr,
                                      controller: variationStockControllers[index][i],
                                      inputType: TextInputType.phone,
                                    ),
                                  ),

                                ]),
                              );
                            },
                          ),
                        ]),
                      );
                    },
                  ),

                ]),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: Row(children: [

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'cancel'.tr,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: CustomButtonWidget(
                  color: Theme.of(context).primaryColor,
                  buttonText: 'update'.tr,
                  isLoading: restaurantController.isLoading,
                  onPressed: () {
                    restaurantController.updateProductStock(
                      foodId: widget.product.id.toString(),
                      itemStock: mainStockController.text,
                      product: widget.product,
                      variationStock: variationStockControllers.map((variationController) => variationController.map((controller) => controller.text).toList()).toList(),
                    );
                  },
                ),
              ),
            ]),
          ),

        ]),
      );
    });
  }
}
