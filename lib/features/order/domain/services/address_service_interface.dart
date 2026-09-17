import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';

abstract class AddressServiceInterface{
  Future<List<PredictionModel>> searchLocation(String text);
  Future<LatLng> getLatLng(String id);
  Future<String> getAddressFromGeocode(LatLng latLng);
  void handleMapAnimation(GoogleMapController? mapController, Position myPosition);
  Future<Position> getPosition(LatLng? defaultLatLng, LatLng configLatLng);
  Future<ZoneResponseModel> getZone(String? lat, String? lng);
  Future<ResponseModel> updateDeliveryAddress(DeliveryAddress deliveryAddress, int orderId);
}