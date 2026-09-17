import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';

abstract class LocationServiceInterface {
  Future<dynamic> getZoneList();
  Future<dynamic> getAddressFromGeocode(LatLng latLng);
  Future<dynamic> searchLocation(String text);
  Future<dynamic> getZone(String lat, String lng);
  Future<dynamic> getPlaceDetails(String? placeID);
  Future<bool> saveUserAddress(String address);
  String? getUserAddress();
  LatLngBounds computeBounds(List<LatLng> list);
  Future<void> prepareZoomToFit(GoogleMapController googleMapController, LatLngBounds bounds, LatLng centerBounds, double padding);
  LatLng? setRestaurantLocation(ZoneResponseModel response, LatLng location);
  List<int>? setZoneIds(ZoneResponseModel response);
  int? setSelectedZoneIndex(ZoneResponseModel response, List<int>? zoneIds, int? selectedZoneIndex, List<ZoneModel>? zoneList);
}