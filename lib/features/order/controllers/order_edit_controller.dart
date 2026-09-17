import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/enum/history_log_enum.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_edit_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';

class OrderEditController extends GetxController implements GetxService {
  final OrderEditServiceInterface orderEditServiceInterface;
  OrderEditController({required this.orderEditServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  List<CartModel> _tempCartList = [];
  List<CartModel> get tempCartList => _tempCartList;

  List<Product>? _searchProductList;
  List<Product>? get searchProductList => _searchProductList;

  List<List<bool?>> _selectedVariations = [];
  List<List<bool?>> get selectedVariations => _selectedVariations;

  int? _cartIndex = -1;
  int? get cartIndex => _cartIndex;

  int _quantity = 1;
  int get quantity => _quantity;

  List<bool> _collapseVariation = [];
  List<bool> get collapseVariation => _collapseVariation;

  bool _canAddToCartProduct = true;
  bool get canAddToCartProduct => _canAddToCartProduct;

  List<List<int?>> _variationsStock = [];
  List<List<int?>> get variationsStock => _variationsStock;

  List<bool> _addOnActiveList = [];
  List<bool> get addOnActiveList => _addOnActiveList;

  List<int?> _addOnQtyList = [];
  List<int?> get addOnQtyList => _addOnQtyList;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<int> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<String> _historyLogList = [];
  List<String> get historyLogList => _historyLogList;

  Future<void> getSearchProductList({required int offset, required String productName, bool isUpdate = true}) async {
    if(offset == 1) {
      _offsetList = [];
      _offset = 1;
      _searchProductList = null;
      if(isUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ProductModel? productModel = await orderEditServiceInterface.getSearchProduct(offset: offset, productName: productName);
      if (productModel != null) {
        if (offset == 1) {
          _searchProductList = [];
        }
        _searchProductList!.addAll(productModel.products!);
        _pageSize = productModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void clearSearch({bool isUpdate = true}) {
    _searchProductList = null;
    _offsetList = [];
    _offset = 1;
    if(isUpdate) {
      update();
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> updateOrder(PlaceOrderModel placeOrderModel) async {
    _isLoading = true;
    update();

    ResponseModel responseModel = await orderEditServiceInterface.updateOrder(placeOrderModel);
    if(responseModel.isSuccess) {
      _cartList = [];
      _tempCartList = [];
      _historyLogList = [];
      orderEditServiceInterface.addToSharedPrefCartList(_cartList);
      Get.find<OrderController>().getOrderDetails(int.parse(placeOrderModel.orderId!));
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }

    _isLoading = false;
    update();
  }

  void prepareCartList({List<OrderDetailsModel>? productList}) {
    List<Product>? products = [];
    if(productList != null) {
      products.addAll(productList.map((e) => e.foodDetails!));
    }
    _cartList = [];
    _tempCartList = [];
    List<CartModel> cartList = orderEditServiceInterface.prepareCartList(orderedFoods: productList, foods: products);
    _cartList = cartList;
    _tempCartList = List.from(cartList);
    orderEditServiceInterface.addToSharedPrefCartList(_cartList);
  }

  Future<void> increaseQuantity(bool isIncrement, CartModel cart, {int? cartIndex}) async {
    int index = cartIndex ?? _cartList.indexOf(cart);
    _cartList[index].quantity = await orderEditServiceInterface.decideProductQuantity(_cartList, isIncrement, index);
    orderEditServiceInterface.addToSharedPrefCartList(_cartList);
    setHistoryLogList(isEdit: true);
    update();
  }

  void removeFromCart(int index, {bool deleteExistingItem = false}) {
    _cartList.removeAt(index);
    orderEditServiceInterface.addToSharedPrefCartList(_cartList);
    if(deleteExistingItem){
      _tempCartList.removeAt(index);
    }
    update();
  }

  String? checkOutOfStockVariationSelected(List<Variation>? variations) {
    if (variations == null || _selectedVariations.isEmpty) return null;

    for (int i = 0; i < _selectedVariations.length; i++) {
      if (i >= variations.length || variations[i].variationValues == null) continue;

      for (int j = 0; j < _selectedVariations[i].length; j++) {
        if (_selectedVariations[i][j] == true) {
          VariationOption variationValue = variations[i].variationValues![j];

          if (variationValue.currentStock != null && int.tryParse(variationValue.currentStock!) != null && int.parse(variationValue.currentStock!) <= 0 && variationValue.stockType != 'unlimited') {
            return '${variationValue.level} ${'variation_is_out_of_stock'.tr}';
          }
        }
      }
    }
    return null;
  }

  void initData(Product? product, CartModel? cart) {
    _canAddToCartProduct = true;
    _selectedVariations = [];
    _variationsStock = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    _collapseVariation = [];
    if(cart != null) {
      _quantity = cart.quantity!;
      _selectedVariations.addAll(cart.variations!);
      _variationsStock = orderEditServiceInterface.initializeVariationsStock(product!.variations);
      _addOnActiveList = orderEditServiceInterface.initializeCartAddonActiveList(product, cart.addOnIds);
      _addOnQtyList = orderEditServiceInterface.initializeCartAddonQuantityList(product, cart.addOnIds);
      _collapseVariation = orderEditServiceInterface.initializeCollapseVariation(product.variations);
    }else {
      _quantity = 1;
      _selectedVariations = orderEditServiceInterface.initializeSelectedVariation(product!.variations);
      _variationsStock = orderEditServiceInterface.initializeVariationsStock(product.variations);
      _collapseVariation = orderEditServiceInterface.initializeCollapseVariation(product.variations);
      _addOnActiveList = orderEditServiceInterface.initializeAddonActiveList(product.addOns);
      _addOnQtyList = orderEditServiceInterface.initializeAddonQuantityList(product.addOns);
    }
    setExistInCartForBottomSheet(product, _selectedVariations);
  }

  int? setExistInCart(Product product, {bool notify = true}) {
    _cartIndex = isExistInCart(product.id, null);
    if(_cartIndex != -1) {
      _quantity = _cartList[_cartIndex!].quantity!;
      _addOnActiveList = orderEditServiceInterface.initializeCartAddonActiveList(product, _cartList[_cartIndex!].addOnIds!);
      _addOnQtyList = orderEditServiceInterface.initializeCartAddonQuantityList(product, _cartList[_cartIndex!].addOnIds!);
    }
    return _cartIndex;
  }

  int? setExistInCartForBottomSheet(Product product, List<List<bool?>>? selectedVariations, {bool notify = true}) {
    _cartIndex = orderEditServiceInterface.isExistInCartForBottomSheet(_cartList, product.id, null, selectedVariations);
    if(_cartIndex != -1) {
      _quantity = _cartList[_cartIndex!].quantity!;
      _addOnActiveList = orderEditServiceInterface.initializeCartAddonActiveList(product, _cartList[_cartIndex!].addOnIds!);
      _addOnQtyList = orderEditServiceInterface.initializeCartAddonQuantityList(product, _cartList[_cartIndex!].addOnIds!);
    } else {
      _quantity = 1;
    }
    return _cartIndex;
  }

  int isExistInCart(int? productID, int? cartIndex) {
    return orderEditServiceInterface.isExistInCart(productID, cartIndex, _cartList);
  }

  int cartQuantity(int productID) {
    return orderEditServiceInterface.cartQuantity(productID, _cartList);
  }

  void changeCanAddToCartProduct(bool status) {
    _canAddToCartProduct = status;
  }

  void showMoreSpecificSection(int index){
    _collapseVariation[index] = !_collapseVariation[index];
    update();
  }

  void setCartVariationIndex(int index, int i, Product? product, bool isMultiSelect) {
    _selectedVariations = orderEditServiceInterface.setCartVariationIndex(index, i, product!.variations, isMultiSelect, _selectedVariations);
    update();
  }

  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    return orderEditServiceInterface.selectedVariationLength(selectedVariations, index);
  }

  void addAddOn(bool isAdd, int index, String? stockType, int? stock) {
    if(stock != null && (stock > 0 && stockType != 'unlimited') || (stockType == 'unlimited')) {
      _addOnActiveList[index] = isAdd;
    }
    update();
  }

  void setAddOnQuantity(bool isIncrement, int index, String? stockType, int? addonStock) {
    _addOnQtyList[index] = orderEditServiceInterface.setAddonQuantity(_addOnQtyList[index]!, isIncrement, stockType, addonStock);
    update();
  }

  void setQuantity(bool isIncrement, int? cartQuantityLimit, String? stockType, int? itemStock) {
    _quantity = orderEditServiceInterface.setQuantity(isIncrement, cartQuantityLimit, _quantity, _selectedVariations, _variationsStock, stockType, itemStock);
    update();
  }

  Future<void> addToCart(CartModel cartModel, {bool fromDirectlyAdd = false, bool fromProductBottomSheet = false}) async {
    if(_cartList.isEmpty) {
      showCustomSnackBar('please_add_product'.tr, isError: true);
      return;
    }
    _cartList.add(cartModel);
    orderEditServiceInterface.addToSharedPrefCartList(_cartList);
    setHistoryLogList(isAdd: true);
    if(fromDirectlyAdd) {
      Get.back();
    }else if(fromProductBottomSheet) {
      Get.back();
      Get.back();
    }
    update();
  }

  Future<void> updateCart(CartModel cartModel, int cartIndex) async {
    if(cartIndex != -1) {
      _cartList[cartIndex] = cartModel;
      orderEditServiceInterface.addToSharedPrefCartList(_cartList);
      _cartIndex = -1;
      Get.back();
    } else {
      showCustomSnackBar('please_add_product'.tr, isError: true);
    }
    update();
  }

  void productDirectlyAddToCart(Product? product) {

    if (product!.variations == null || (product.variations != null && product.variations!.isEmpty)) {

      double price = product.price!;
      double discount = product.discount!;
      double discountPrice = PriceConverter.convertWithDiscount(price, discount, product.discountType)!;

      CartModel cartModel = CartModel(
        id: null, price: price, discountedPrice: discountPrice, discountAmount: (price - discountPrice),
        quantity: 1, addOnIds: [], addOns: [], isCampaign: false, product: product, variations: [], quantityLimit: product.cartQuantityLimit, variationsStock: [],
      );

      setExistInCart(product);
      addToCart(cartModel, fromDirectlyAdd: true);
    } else {
      Get.bottomSheet(
        ProductBottomSheetWidget(product: product),
        backgroundColor: Colors.transparent, isScrollControlled: true,
      );
    }
  }

  void setHistoryLogList({bool isAdd = false, bool isEdit = false, bool isDelete = false, bool willUpdate = true}) {
    if(isAdd && !_historyLogList.contains(HistoryLogEnum.add_new_item.name)) {
      _historyLogList.add(HistoryLogEnum.add_new_item.name);
    }else if(isEdit && !_historyLogList.contains(HistoryLogEnum.edited_item_quantity.name)) {
      _historyLogList.add(HistoryLogEnum.edited_item_quantity.name);
    }else if(isDelete && !_historyLogList.contains(HistoryLogEnum.delete_item.name)) {
      _historyLogList.add(HistoryLogEnum.delete_item.name);
    } else if(!isAdd && !isEdit && !isDelete) {
      _historyLogList = [];
    }
    if(willUpdate) {
      update();
    }
  }

  bool isSameVariation(List<List<bool?>> v1, List<List<bool?>> v2) {
    if (v1.length != v2.length) return false;

    for (int i = 0; i < v1.length; i++) {
      if (v1[i].length != v2[i].length) return false;

      for (int j = 0; j < v1[i].length; j++) {
        if (v1[i][j] != v2[i][j]) return false;
      }
    }
    return true;
  }

}