import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart' hide AddOn;
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

abstract class OrderEditServiceInterface {
  Future<ProductModel?> getSearchProduct({required int offset, required String productName});
  List<CartModel> prepareCartList({List<OrderDetailsModel>? orderedFoods, List<Product>? foods});
  Future<int> decideProductQuantity(List<CartModel> cartList, bool isIncrement, int index);
  List<List<bool?>> setCartVariationIndex(int index, int i, List<Variation>? variations, bool isMultiSelect, List<List<bool?>> selectedVariations);
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index);
  int setAddonQuantity(int addOnQty, bool isIncrement, String? stockType, int? addonStock);
  int setQuantity(bool isIncrement, int? cartQuantityLimit, int quantity, List<List<bool?>> selectedVariations, List<List<int?>> variationsStock, String? stockType, int? itemStock);
  void addToSharedPrefCartList(List<CartModel> cartProductList);
  List<List<int?>> initializeVariationsStock(List<Variation>? variations);
  List<bool> initializeCartAddonActiveList(Product? product, List<AddOn>? addOnIds);
  List<int?> initializeCartAddonQuantityList(Product? product, List<AddOn>? addOnIds);
  List<bool> initializeCollapseVariation(List<Variation>? variations);
  List<List<bool?>> initializeSelectedVariation(List<Variation>? variations);
  List<bool> initializeAddonActiveList(List<AddOns>? addOns);
  List<int?> initializeAddonQuantityList(List<AddOns>? addOns);
  int isExistInCartForBottomSheet(List<CartModel> cartList, int? productID, int? cartIndex, List<List<bool?>>? variations);
  int isExistInCart(int? productID, int? cartIndex, List<CartModel> cartList);
  int cartQuantity(int productID, List<CartModel> cartList);
  Future<ResponseModel> updateOrder(PlaceOrderModel placeOrderModel);
}