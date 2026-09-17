import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_edit_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ProductDeleteConfirmationBottomSheet extends StatelessWidget {
  final int itemIndex;
  const ProductDeleteConfirmationBottomSheet({super.key, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderEditController>(builder: (orderEditController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.highlight_remove, color: Theme.of(context).hintColor.withValues(alpha: 0.8), size: 27),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

              CustomAssetImageWidget(image: Images.warning, height: 60, width: 60),
              SizedBox(height: Dimensions.paddingSizeDefault),

              Text('are_you_sure_to_delete_this_food'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              SizedBox(height: Dimensions.paddingSizeDefault),

              Text(
                'if_once_you_delete_this_food_this_will_remove_from_food_list'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

              Row(children: [

                Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'cancel'.tr,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'delete'.tr,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      if(orderEditController.cartList.length > 1){
                        bool isNewProductInCart = false;

                        for (int index = 0; index < orderEditController.cartList.length; index++) {
                          CartModel cart = orderEditController.cartList[index];
                          isNewProductInCart = !orderEditController.tempCartList.any((oldCart) => oldCart.product?.id == cart.product!.id);
                        }

                        Get.back();
                        orderEditController.removeFromCart(itemIndex, deleteExistingItem: isNewProductInCart ? false : true);

                        if(!isNewProductInCart){
                          orderEditController.setHistoryLogList(isDelete: true);
                        }
                      }else{
                        Get.back();
                        showCustomSnackBar('you_must_have_at_least_one_food_in_cart_you_can_not_delete_this_food'.tr, isError: true);
                      }
                    },
                  ),
                ),

              ]),

            ]),
          ),

        ]),
      );
    });
  }
}
