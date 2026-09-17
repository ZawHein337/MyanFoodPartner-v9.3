import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';

abstract class OrderServiceInterface {
  Future<dynamic> getOrderDetails(int orderID);
  Future<dynamic> getCurrentOrders({required String status, required int offset, required int isCampaign, required int isSubscription});
  Future<dynamic> getPaginatedOrderList({required int offset, required String status, required int isSubscription});
  Future<dynamic> updateOrderStatus(UpdateStatusModel updateStatusBody, List<MultipartBody> proofAttachment);
  Future<dynamic> getOrderWithId(int? orderId);
  Future<dynamic> getCancelReasons();
  Future<dynamic> sendDeliveredNotification(int? orderID);
  Future<void> setBluetoothAddress(String? address);
  String? getBluetoothAddress();
  Future<bool> addDineInTableAndTokenNumber(int? orderId, String? tableNumber, String? tokenNumber);
}