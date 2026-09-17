import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepository({required this.apiClient, required this.sharedPreferences});

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future<Response> get(int id) {
    return apiClient.getData('${AppConstants.orderDetailsUri}$id');
  }

  @override
  Future<CurrentOrderModel?> getCurrentOrders({required String status, required int offset, required int isCampaign, required int isSubscription}) async {
    CurrentOrderModel? currentOrderModel;
    final campaign =  isCampaign == 1 ?"&order_filter=campaign" : "";
    final subscription =  isSubscription == 1 ?"&order_filter=subscription" : "";
    Response response = await apiClient.getData('${AppConstants.currentOrdersUri}?status=$status&offset=$offset&limit=10$campaign$subscription');
    if (response.statusCode == 200) {
      currentOrderModel = CurrentOrderModel.fromJson(response.body);
    }
    return currentOrderModel;
  }

  @override
  Future<PaginatedOrderModel?> getPaginatedOrderList({required int offset, required String status, required int isSubscription}) async {
    PaginatedOrderModel? historyOrderModel;
    Response response = await apiClient.getData('${AppConstants.completedOrdersUri}?status=$status&offset=$offset&limit=10&is_subscription=$isSubscription');
    if (response.statusCode == 200) {
      historyOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return historyOrderModel;
  }

  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusModel updateStatusBody, List<MultipartBody> proofAttachment) async {
    ResponseModel responseModel;
    Response response = await apiClient.postMultipartData(AppConstants.updateOrderStatusUri, updateStatusBody.toJson(), proofAttachment, [], handleError: false);
    if (response.statusCode == 200) {

      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<OrderModel?> getOrderWithId(int? orderId) async {
    OrderModel? orderModel;
    Response response = await apiClient.getData('${AppConstants.currentOrderDetailsUri}$orderId');
    if(response.statusCode == 200) {
      orderModel = OrderModel.fromJson(response.body);
    }
    return orderModel;
  }

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=restaurant');
    if (response.statusCode == 200) {
      OrderCancellationBodyModel orderCancellationBody = OrderCancellationBodyModel.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
  }

  @override
  Future<bool> sendDeliveredNotification(int? orderID) async {
    Response response = await apiClient.postData(AppConstants.deliveredOrderNotificationUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> addDineInTableAndTokenNumber(int? orderId, String? tableNumber, String? tokenNumber) async {
    Response response = await apiClient.postData('${AppConstants.addDineInTableAndTokenUri}/$orderId', {
      '_method': 'put',
      'table_number': tableNumber,
      'token_number': tokenNumber,
    });
    return response.statusCode == 200;
  }

  @override
  Future<void> setBluetoothAddress(String? address) async {
    await sharedPreferences.setString(AppConstants.bluetoothMacAddress, address ?? '');
  }

  @override
  String? getBluetoothAddress() => sharedPreferences.getString(AppConstants.bluetoothMacAddress);

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }
  
}