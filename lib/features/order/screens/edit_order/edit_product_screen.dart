import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_edit_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/product_delete_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/quantity_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/cart_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class EditProductScreen extends StatefulWidget {
  final int? orderId;
  final String? orderStatus;
  final List<OrderDetailsModel>? orderDetailsModel;
  const EditProductScreen({super.key, this.orderDetailsModel, this.orderId, this.orderStatus});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  @override
  void initState() {
    super.initState();
    OrderEditController orderEditController = Get.find<OrderEditController>();
    orderEditController.prepareCartList(productList: widget.orderDetailsModel);
    orderEditController.setHistoryLogList(willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: '${'edit_item'.tr} # ${widget.orderId}',
        subTitle: '${'order_is'.tr} ${widget.orderStatus?.tr}',
      ),

      body: GetBuilder<OrderEditController>(builder: (orderEditController) {
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [

                Row(children: [
                  Text('item_list'.tr, style: robotoBold),
                  SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.4),
                    ),
                    child: Text('${orderEditController.cartList.length}', style: robotoRegular),
                  ),
                ]),
                SizedBox(height: Dimensions.paddingSizeSmall),

                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderEditController.cartList.length,
                  itemBuilder: (context, index) {

                    Product? editProduct = orderEditController.cartList[index].product;

                    String addOnText = CartHelper.setupAddonsText(cart: orderEditController.cartList[index]) ?? '';
                    String variationText = CartHelper.setupVariationText(cart: orderEditController.cartList[index]);

                    double? discount = editProduct!.discount;
                    String? discountType = editProduct.discountType;

                    bool isNewProductInCart = !orderEditController.tempCartList.any((oldCart) {

                      if (oldCart.product?.id != editProduct.id) return false;

                      if (oldCart.variations == null || orderEditController.cartList[index].variations == null) {
                        return false;
                      }

                      return orderEditController.isSameVariation(oldCart.variations!, orderEditController.cartList[index].variations!);
                    });

                    bool isAvailable = DateConverter.isAvailable(editProduct.availableTimeStarts, editProduct.availableTimeEnds);
                    
                    return Container(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: isNewProductInCart ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: isNewProductInCart ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Colors.black12, spreadRadius: 1, blurRadius: 5)],
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: InkWell(
                        onTap: !isAvailable ? null : () {
                          Get.bottomSheet(
                            ProductBottomSheetWidget(product: editProduct, cart: orderEditController.cartList[index], cartIndex: index),
                            backgroundColor: Colors.transparent, isScrollControlled: true,
                          );
                        },
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Row(children: [

                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: CustomImageWidget(
                                    image: editProduct.imageFullUrl ?? '',
                                    height: 50, width: 50, fit: BoxFit.cover,
                                  ),
                                ),

                                isAvailable ? const SizedBox() : Positioned(
                                  top: 0, left: 0, bottom: 0, right: 0,
                                  child: NotAvailableWidget(
                                    opacity: 0.3, isRestaurant: false,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                Row(children: [

                                  Expanded(
                                    child: Row(children: [
                                      Flexible(
                                        child: Text(
                                          editProduct.name!,
                                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                      Get.find<SplashController>().configModel!.toggleVegNonVeg! ? CustomAssetImageWidget(
                                        image: editProduct.veg == 0 ? Images.nonVegImage : Images.vegImage,
                                        height: 12, width: 12,
                                      ) : SizedBox(),

                                    ]),
                                  ),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Row(children: [

                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        PriceConverter.convertPrice(editProduct.price, discount: discount, discountType: discountType),
                                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                                      ),

                                      discount! > 0 ? Text(
                                        PriceConverter.convertPrice(editProduct.price), textDirection: TextDirection.ltr,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                                      ) : const SizedBox(),
                                    ],
                                  )),

                                  Row(children: [

                                    QuantityButton(
                                      onTap: !isAvailable ? null : () {
                                        if(orderEditController.cartList[index].quantity! > 1) {
                                          orderEditController.increaseQuantity(false, orderEditController.cartList[index]);
                                        }else {
                                          if(orderEditController.cartList.length > 1){
                                            showCustomBottomSheet(child: ProductDeleteConfirmationBottomSheet(itemIndex: index));
                                          }else{
                                            showCustomSnackBar('you_must_have_at_least_one_food_in_cart_you_can_not_delete_this_food'.tr, isError: true);
                                          }
                                        }
                                      },
                                      isIncrement: false,
                                      showRemoveIcon: orderEditController.cartList[index].quantity == 1,
                                      isLastItem: orderEditController.cartList.length == 1,
                                    ),

                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      ),
                                      child: Text('${orderEditController.cartList[index].quantity}', style: robotoMedium),
                                    ),

                                    QuantityButton(
                                      onTap: !isAvailable ? null : () {
                                        orderEditController.increaseQuantity(true, orderEditController.cartList[index]);
                                      },
                                      isIncrement: true,
                                    ),
                                  ]),

                                ]),

                              ]),
                            ),
                          ]),

                          addOnText.isNotEmpty ? Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [

                              SizedBox(width: 60),

                              Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                              Flexible(child: Text(
                                addOnText,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              )),

                            ]),
                          ) : const SizedBox(),

                          variationText.isNotEmpty ? Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            child: Row(children: [

                              SizedBox(width: 60),

                              Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                              Flexible(child: Text(
                                variationText,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              )),
                            ]),
                          ) : const SizedBox(),

                        ]),
                      ),
                    );
                  },
                ),
                SizedBox(height: Dimensions.paddingSizeSmall),

                TextButton(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_circle_outline, size: 20, color: Theme.of(context).primaryColor),
                    SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('add_more_items'.tr),
                  ]),
                  onPressed: () {
                    Get.toNamed(RouteHelper.getAddNewProductRoute());
                  },
                ),

              ]),
            ),
          ),

          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: Row(children: [

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
                  isLoading: orderEditController.isLoading,
                  buttonText: 'update'.tr,
                  onPressed: () {

                    List<Cart> carts = [];
                    for (int index = 0; index < orderEditController.cartList.length; index++) {
                      CartModel cart = orderEditController.cartList[index];
                      List<int?> addOnIdList = [];
                      List<int?> addOnQtyList = [];
                      List<OrderVariation> variations = [];
                      List<int?> optionIds = [];
                      bool isNewProductInCart = !orderEditController.tempCartList.any((oldCart) => oldCart.product?.id == cart.product!.id);

                      for (var addOn in cart.addOnIds!) {
                        addOnIdList.add(addOn.id);
                        addOnQtyList.add(addOn.quantity);
                      }
                      if(cart.product!.variations != null){
                        for(int i=0; i<cart.product!.variations!.length; i++) {
                          if(cart.variations![i].contains(true)) {
                            variations.add(OrderVariation(name: cart.product!.variations![i].name, values: OrderVariationValue(label: [])));
                            for(int j=0; j<cart.product!.variations![i].variationValues!.length; j++) {
                              if(cart.variations![i][j]!) {
                                variations[variations.length-1].values!.label!.add(cart.product!.variations![i].variationValues![j].level);
                                if(cart.product!.variations![i].variationValues![j].optionId != null) {
                                  optionIds.add(int.parse(cart.product!.variations![i].variationValues![j].optionId!));
                                }
                              }
                            }
                          }
                        }
                      }

                      carts.add(Cart(
                        itemId: cart.product!.id, itemType: 'food', quantity: cart.quantity,
                        addOnIds: addOnIdList, addOns: cart.addOns, addOnQtys: addOnQtyList,
                        variations: variations, variationOptionIds: optionIds, newItem: isNewProductInCart,
                      ));
                    }

                    PlaceOrderModel orderBody = PlaceOrderModel(orderId: widget.orderId.toString(), carts: carts, editHistoryLog: orderEditController.historyLogList);

                    orderEditController.updateOrder(orderBody);
                  },
                ),
              ),

            ]),
          ),

        ]);
      }),
    );
  }
}
