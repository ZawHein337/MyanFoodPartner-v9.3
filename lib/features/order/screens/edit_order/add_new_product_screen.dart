import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/not_available_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_edit_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/product_delete_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/quantity_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    OrderEditController orderEditController = Get.find<OrderEditController>();

    orderEditController.clearSearch(isUpdate: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
    
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && orderEditController.searchProductList != null && !orderEditController.isLoading) {
        int pageSize = (orderEditController.pageSize! / 10).ceil();
        if (orderEditController.offset < pageSize) {
          orderEditController.setOffset(orderEditController.offset+1);
          debugPrint('end of the page');
          orderEditController.showBottomLoader();
          orderEditController.getSearchProductList(
            productName: _searchController.text.isNotEmpty ? _searchController.text : '',
            offset: orderEditController.offset,
          );
        }
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'add_new_item'.tr,
        onBackPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          } else {
            Get.back();
          }
        },
      ),

      body: GetBuilder<OrderEditController>(builder: (orderEditController) {
        return Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
              elevation: WidgetStatePropertyAll(0),
              side: WidgetStatePropertyAll(BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.3))),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  orderEditController.getSearchProductList(productName: value, offset: 1);
                }
              },
              onSubmitted: (value) {
                orderEditController.getSearchProductList(productName: value, offset: 1);
              },
              hintText: 'search_by_food_name'.tr,
              hintStyle: WidgetStatePropertyAll(
                robotoRegular.copyWith(color: Theme.of(context).hintColor),
              ),
              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: Icon(CupertinoIcons.search, color: Theme.of(context).hintColor),
              trailing: _searchController.text.isEmpty ? [const SizedBox()] : _searchController.text.isNotEmpty ? [InkWell(
                child: Icon(Icons.clear, color: Theme.of(context).hintColor),
                onTap: () {
                  _searchController.clear();
                  orderEditController.clearSearch();
                  orderEditController.update();
                },
              )] : [const SizedBox()],
            ),
          ),

          orderEditController.searchProductList != null ? orderEditController.searchProductList!.isNotEmpty ? Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
              itemCount: orderEditController.searchProductList!.length,
              itemBuilder: (context, index) {
                Product product = orderEditController.searchProductList![index];
                int cartQty = orderEditController.cartQuantity(product.id!);
                int cartIndex = orderEditController.isExistInCart(product.id, null);
                bool isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);

                return Container(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall + 2),
                  width: context.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: InkWell(
                    onTap: !isAvailable ? null : () {
                      Get.bottomSheet(
                        ProductBottomSheetWidget(product: product),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      );
                    },
                    child: Row(children: [

                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              image: product.imageFullUrl ?? '',
                              height: 70, width: 70, fit: BoxFit.cover,
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
                          Text(product.name ?? '', style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Wrap(children: [

                            product.discount! > 0 ? Text(
                              PriceConverter.convertPrice(product.price), textDirection: TextDirection.ltr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough, decorationColor: Theme.of(context).hintColor),
                            ) : const SizedBox(),
                            SizedBox(width: product.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

                            Text(
                              PriceConverter.convertPrice(product.price, discount: product.discount, discountType: product.discountType),
                              style: robotoBold.copyWith(color: Theme.of(context).primaryColor), textDirection: TextDirection.ltr,
                            ),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text('${'stock'.tr}: ${product.stockType == 'unlimited' ? 'unlimited'.tr : product.itemStock! > 0 ? product.itemStock.toString() : 'out_of_stock'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                        ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      cartQty != 0 ? Row(children: [

                        QuantityButton(
                          onTap: !isAvailable ? null : () {
                            if(cartQty > 1) {
                              orderEditController.increaseQuantity(false, orderEditController.cartList[index], cartIndex: cartIndex);
                            }else {
                              showCustomBottomSheet(child: ProductDeleteConfirmationBottomSheet(itemIndex: cartIndex));
                            }
                          },
                          isIncrement: false,
                          showRemoveIcon: cartQty == 1,
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text('$cartQty', style: robotoMedium),
                        ),

                        QuantityButton(
                          onTap: !isAvailable ? null : () {
                            orderEditController.increaseQuantity(true, orderEditController.cartList[index], cartIndex: cartIndex);
                          },
                          isIncrement: true,
                        ),
                      ]) : QuantityButton(
                        onTap: !isAvailable ? null : () {
                          orderEditController.productDirectlyAddToCart(product);
                        },
                        isIncrement: true,
                      ),

                    ]),
                  ),
                );
              },
            ),
          ) : Expanded(child: Center(child: Text('no_item_found'.tr))) : SizedBox(),

        ]);
      }),
    );
  }
}
