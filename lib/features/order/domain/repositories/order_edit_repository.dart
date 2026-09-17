import 'dart:convert';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/place_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_edit_repository_interface.dart';

class OrderEditRepository implements OrderEditRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderEditRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ProductModel?> getSearchProduct({required int offset, required String productName}) async {
    ProductModel? searchProduct;
    Response response = await apiClient.getData('${AppConstants.getSearchFoodUri}?name=$productName&offset=$offset&limit=25');
    if (response.statusCode == 200) {
      searchProduct = ProductModel.fromJson(response.body);
    }
    return searchProduct;
  }

  @override
  void addToSharedPrefCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences.setStringList(AppConstants.cartList, carts);
  }

  @override
  Future<ResponseModel> updateOrder(PlaceOrderModel placeOrderModel) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.updateOrderUri, placeOrderModel.toJson(), handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}