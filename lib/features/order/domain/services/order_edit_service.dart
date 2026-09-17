import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart' as cart;
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart' hide AddOn;
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_edit_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_edit_service_interface.dart';

class OrderEditService implements OrderEditServiceInterface {
  final OrderEditRepositoryInterface orderEditRepositoryInterface;
  OrderEditService({required this.orderEditRepositoryInterface});

  @override
  Future<ProductModel?> getSearchProduct({required int offset, required String productName}) async {
    return await orderEditRepositoryInterface.getSearchProduct(offset: offset, productName: productName);
  }

  @override
  void addToSharedPrefCartList(List<CartModel> cartProductList) {
    orderEditRepositoryInterface.addToSharedPrefCartList(cartProductList);
  }

  @override
  Future<ResponseModel> updateOrder(PlaceOrderModel placeOrderModel) async {
    return await orderEditRepositoryInterface.updateOrder(placeOrderModel);
  }

  @override
  List<CartModel> prepareCartList({List<OrderDetailsModel>? orderedFoods, List<Product>? foods}) {
    List<CartModel> offlineCartList = [];

    for (int i = 0; i < orderedFoods!.length; i++) {
      for (int j = 0; j < foods!.length; j++) {
        if (orderedFoods[i].foodDetails!.id == foods[j].id) {
            offlineCartList.add(_sortOutProductAddToCard(orderedFoods[i].variation, foods[j], orderedFoods[i]),
          );
          break;
        }
      }
    }
    return offlineCartList;
  }

  dynamic _sortOutProductAddToCard(List<Variation>? orderedVariation, Product currentFood, OrderDetailsModel orderDetailsModel){
    List<List<bool?>> selectedVariations = [];

    double price = currentFood.price!;
    double variationPrice = 0;
    int? quantity = orderDetailsModel.quantity;
    List<int?> addOnIdList = [];
    List<cart.AddOn> addOnIdWithQtnList = [];
    List<bool> addOnActiveList = [];
    List<int?> addOnQtyList = [];
    List<AddOns> addOnsList = [];
    List<OrderVariation> variations = [];
    List<int?>? optionIds = [];

    if(currentFood.variations != null && currentFood.variations!.isNotEmpty){
      for (int i = 0; i < currentFood.variations!.length; i++) {
        selectedVariations.add(
          List<bool?>.filled(currentFood.variations![i].variationValues!.length, false),
        );

        if (orderedVariation != null && orderedVariation.isNotEmpty) {
          for (int j = 0; j < orderedVariation.length; j++) {
            if (currentFood.variations![i].name == orderedVariation[j].name) {
              for (int x = 0; x < currentFood.variations![i].variationValues!.length; x++) {
                for (int y = 0; y < orderedVariation[j].variationValues!.length; y++) {
                  if (currentFood.variations![i].variationValues![x].level == orderedVariation[j].variationValues![y].level) {
                    selectedVariations[i][x] = true;
                  }
                }
              }
            }
          }
        }
      }
    }

    if(currentFood.variations != null && currentFood.variations!.isNotEmpty){
      for(int i=0; i<currentFood.variations!.length; i++){
        if(selectedVariations[i].contains(true)){
          variations.add(OrderVariation(name: currentFood.variations![i].name, values: OrderVariationValue(label: [])));
          for(int j=0; j<currentFood.variations![i].variationValues!.length; j++) {
            if(selectedVariations[i][j]!) {
              variations[variations.length-1].values!.label!.add(currentFood.variations![i].variationValues![j].level);
              if(currentFood.variations![i].variationValues![j].optionId != null && currentFood.variations![i].variationValues![j].optionId!.isNotEmpty) {
                optionIds.add(int.parse(currentFood.variations![i].variationValues![j].optionId!));
              }
            }
          }
        }
      }
    }

    if(currentFood.variations != null){
      for(int index = 0; index< currentFood.variations!.length; index++) {
        for(int i=0; i<currentFood.variations![index].variationValues!.length; i++) {
          if(selectedVariations[index].isNotEmpty && selectedVariations[index][i]!) {
            variationPrice += double.parse(currentFood.variations![index].variationValues![i].optionPrice!);
          }
        }
      }
    }

    for (var addon in currentFood.addOns!) {
      for(int i=0; i<orderDetailsModel.addOns!.length; i++){
        if(orderDetailsModel.addOns![i].id == addon.id){
          addOnIdList.add(addon.id);
          addOnIdWithQtnList.add(cart.AddOn(id: addon.id, quantity: orderDetailsModel.addOns![i].quantity));
        }
      }
      addOnsList.add(addon);
    }

    for (var addOn in currentFood.addOns!) {
      if(addOnIdList.contains(addOn.id)) {
        addOnActiveList.add(true);
        addOnQtyList.add(orderDetailsModel.addOns![addOnIdList.indexOf(addOn.id)].quantity);
      }else {
        addOnActiveList.add(false);
      }
    }

    double? discount = (currentFood.restaurantDiscount == 0) ? currentFood.discount : currentFood.restaurantDiscount;
    String? discountType = (currentFood.restaurantDiscount == 0) ? currentFood.discountType : 'percent';
    double? priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType);
    double priceWithVariation = price + variationPrice;

    CartModel cartModel = CartModel(
      id: null, price: priceWithVariation, discountedPrice: priceWithDiscount, discountAmount: (price - PriceConverter.convertWithDiscount(price, discount, discountType)!),
      quantity: quantity, addOnIds: addOnIdWithQtnList, addOns: addOnsList, isCampaign: false, product: currentFood, variations: selectedVariations, quantityLimit: currentFood.cartQuantityLimit, variationsStock: [],
    );

    return cartModel;
  }

  @override
  Future<int> decideProductQuantity(List<CartModel> cartList, bool isIncrement, int index) async {
    int quantity = cartList[index].quantity!;
    if (isIncrement) {
      quantity = _quantityLimitChecking(cartList[index].variations!, cartList[index].variationsStock!, cartList[index].product!.cartQuantityLimit, quantity, cartList[index].product!.stockType, cartList[index].product!.itemStock);
    } else {
      quantity = quantity - 1;
    }
    return quantity;
  }

  int _minimumVariationStock(List<List<bool?>> selectedVariations, List<List<int?>> variationsStock) {
    List<int> stocks = [];

    for (int i = 0; i < selectedVariations.length; i++) {
      for (int j = 0; j < selectedVariations[i].length; j++) {
        if (selectedVariations[i][j] == true && i < variationsStock.length && j < variationsStock[i].length && variationsStock[i][j] != null) {
          stocks.add(variationsStock[i][j]!);
        }
      }
    }

    if (stocks.isEmpty) {
      return 0;
    }

    return stocks.reduce((curr, next) => curr < next ? curr : next);
  }


  @override
  List<List<bool?>> setCartVariationIndex(int index, int i, List<Variation>? variations, bool isMultiSelect, List<List<bool?>> selectedVariations) {
    List<List<bool?>> resultVariations = selectedVariations;
    int? currentStockI = int.tryParse(variations![index].variationValues![i].currentStock ?? '0');
    int? max = int.tryParse(variations[index].max!);

    if(!isMultiSelect) {

      for(int j = 0; j < resultVariations[index].length; j++) {

        int? currentStockJ = int.parse(variations[index].variationValues![j].currentStock ?? '0');

        if(variations[index].variationValues![i].stockType != 'unlimited' && currentStockI != null && currentStockI <= 0) {
          break;
        }

        if(variations[index].required! == 'on'){
          if(variations[index].variationValues![j].stockType != null) {
            if (variations[index].variationValues![j].stockType == 'unlimited' || (variations[index].variationValues![j].stockType != 'unlimited' && currentStockJ > 0)) {
              if( j == i && resultVariations[index][j]!) {
                resultVariations[index][j] = false;
              } else {
                resultVariations[index][j] = j == i;
              }
            }
          } else {
            resultVariations[index][j] = j == i;
          }
        }else{
          if(variations[index].variationValues![j].stockType != null) {
            if(variations[index].variationValues![j].stockType == 'unlimited' || (variations[index].variationValues![j].stockType != 'unlimited' && currentStockJ > 0)){
              if( j == i && resultVariations[index][j]!) {
                resultVariations[index][j] = false;
              } else {
                resultVariations[index][j] = j == i;
              }
            } else{
              resultVariations[index][j] = false;
            }
          } else {
            if(resultVariations[index][j]!){
              resultVariations[index][j] = false;
            }else{
              resultVariations[index][j] = j == i;
            }
          }

        }
      }
    } else {
      if(!resultVariations[index][i]! && selectedVariationLength(resultVariations, index) >= max!) {
        showCustomSnackBar('${'maximum_variation_for'.tr} ${variations[index].name} ${'is'.tr} ${variations[index].max}');
      }else {
        if(variations[index].variationValues![i].stockType != null) {
          if(variations[index].variationValues![i].stockType == 'unlimited') {
            resultVariations[index][i] = !resultVariations[index][i]!;
          } else if(variations[index].variationValues![i].stockType != 'unlimited' && currentStockI! > 0) {
            resultVariations[index][i] = !resultVariations[index][i]!;
          } else {
            resultVariations[index][i] = false;
          }
        } else {
          resultVariations[index][i] = !resultVariations[index][i]!;
        }

      }
    }
    return resultVariations;
  }

  @override
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for(bool? isSelected in selectedVariations[index]) {
      if(isSelected!) {
        length++;
      }
    }
    return length;
  }

  @override
  int setAddonQuantity(int addOnQty, bool isIncrement, String? stockType, int? addonStock) {
    int qty = addOnQty;
    if (isIncrement) {
      if(stockType != 'unlimited' && addonStock != null && qty >= addonStock) {
        showCustomSnackBar('${'maximum_addon_limit'.tr} $addonStock');
      } else {
        qty = qty + 1;
      }
    } else {
      qty = qty - 1;
    }
    return qty;
  }

  @override
  int setQuantity(bool isIncrement, int? cartQuantityLimit, int quantity, List<List<bool?>> selectedVariations, List<List<int?>> variationsStock, String? stockType, int? itemStock, {bool isFromBottomSheet = true}) {
    int qty = quantity;
    if (isIncrement) {
      qty = _quantityLimitChecking(selectedVariations, variationsStock, cartQuantityLimit, quantity, stockType, itemStock, isFromBottomSheet: isFromBottomSheet);
    } else {
      qty = qty - 1;
    }
    return qty;
  }

  int _quantityLimitChecking(List<List<bool?>> selectedVariations, List<List<int?>> variationsStock, int? cartQuantityLimit, int quantity, String? stockType, int? itemStock, {bool isFromBottomSheet = false}) {
    int qty = quantity;
    int? minimumStock;
    if(isFromBottomSheet && _haveSelectedVariationCheck(selectedVariations) && stockType != 'unlimited') {
      minimumStock = _minimumVariationStock(selectedVariations, variationsStock);
    }

    if(stockType != 'unlimited' && itemStock != null && qty >= itemStock) {
      showCustomSnackBar('${'maximum_food_quantity_limit'.tr} $itemStock');
    } else if(isFromBottomSheet && minimumStock != null && qty >= minimumStock) {
      showCustomSnackBar('${'maximum_variation_quantity_limit'.tr} $minimumStock');
    } else if(cartQuantityLimit != null && qty >= cartQuantityLimit && cartQuantityLimit != 0) {
      showCustomSnackBar('${'maximum_cart_quantity_limit'.tr} $cartQuantityLimit');
    } else {
      qty = qty + 1;
    }
    return qty;
  }

  bool _haveSelectedVariationCheck(List<List<bool?>> selectedVariations) {
    bool hasSelected = false;
    for(int i=0; i<selectedVariations.length; i++) {
      for(int j=0; j<selectedVariations[i].length; j++) {
        if(selectedVariations[i][j]!) {
          hasSelected = true;
        }
      }
    }
    return hasSelected;
  }

  @override
  List<bool> initializeAddonActiveList(List<AddOns>? addOns) {
    List<bool> addOnActiveList = [];
    for (var addOn in addOns!) {
      debugPrint('$addOn');
      addOnActiveList.add(false);
    }
    return addOnActiveList;
  }

  @override
  List<int?> initializeAddonQuantityList(List<AddOns>? addOns) {
    List<int?> addOnQtyList = [];
    for (var addOn in addOns!) {
      debugPrint('$addOn');
      addOnQtyList.add(1);
    }
    return addOnQtyList;
  }

  @override
  List<bool> initializeCartAddonActiveList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<bool> addOnActiveList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnActiveList.add(true);
        }else {
          addOnActiveList.add(false);
        }
      }
    }
    return addOnActiveList;
  }

  @override
  List<int?> initializeCartAddonQuantityList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<int?> addOnQtyList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnQtyList.add(addOnIds[addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          addOnQtyList.add(1);
        }
      }
    }
    return addOnQtyList;
  }

  @override
  List<bool> initializeCollapseVariation(List<Variation>? variations) {
    List<bool> collapseVariation = [];
    if(variations != null){
      for(int index=0; index<variations.length; index++){
        collapseVariation.add(true);
      }
    }
    return collapseVariation;
  }

  @override
  List<List<bool?>> initializeSelectedVariation(List<Variation>? variations) {
    List<List<bool?>> selectedVariations = [];
    if(variations != null){
      for(int index=0; index<variations.length; index++){
        selectedVariations.add([]);
        for(int i=0; i < variations[index].variationValues!.length; i++) {
          selectedVariations[index].add(false);
        }
      }
    }
    return selectedVariations;
  }

  @override
  List<List<int?>> initializeVariationsStock(List<Variation>? variations) {
    List<List<int?>> variationsStock = [];

    if (variations != null) {
      for (int index = 0; index < variations.length; index++) {
        variationsStock.add([]);

        final variationValues = variations[index].variationValues;
        if (variationValues == null) continue;

        for (int i = 0; i < variationValues.length; i++) {
          String? stockStr = variationValues[i].currentStock;
          int? stockInt = stockStr != null ? int.tryParse(stockStr) : null;
          variationsStock[index].add(stockInt);
        }
      }
    }

    return variationsStock;
  }


  @override
  int isExistInCart(int? productID, int? cartIndex, List<CartModel> cartList) {
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].product!.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  int cartQuantity(int productID, List<CartModel> cartList) {
    int quantity = 0;
    for(CartModel cart in cartList) {
      if(cart.product!.id == productID) {
        quantity += cart.quantity!;
      }
    }
    return quantity;
  }

  @override
  int isExistInCartForBottomSheet(List<CartModel> cartList, int? productID, int? cartIndex, List<List<bool?>>? variations) {
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].product!.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          if(variations != null) {
            bool same = false;
            for(int i=0; i<variations.length; i++) {
              for(int j=0; j<variations[i].length; j++) {
                if(variations[i][j] == cartList[index].variations![i][j]) {
                  same = true;
                } else {
                  same = false;
                  break;
                }

              }
              if(!same) {
                break;
              }
            }
            if(!same) {
              continue;
            }
            if(same) {
              return index;
            } else {
              return -1;
            }
          } else {
            return -1;
          }
        }
      }
    }
    return -1;
  }

}