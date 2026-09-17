import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class AddressRepositoryInterface implements RepositoryInterface {
  Future<Response> searchLocation(String text);
  Future<Response> getLatLng(String id);
  Future<String> getAddressFromGeocode(LatLng latLng);
  Future<ZoneResponseModel> getZone(String? lat, String? lng);
  Future<ResponseModel> updateDeliveryAddress(DeliveryAddress deliveryAddress, int orderId);
}