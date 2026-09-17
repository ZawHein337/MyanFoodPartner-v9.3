import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getAddressFromGeocode(LatLng latLng);
  Future<dynamic> searchLocation(String text);
  Future<dynamic> getZone(String lat, String lng);
  Future<dynamic> getPlaceDetails(String? placeID);
  Future<bool> saveUserAddress(String address);
  String? getUserAddress();
}