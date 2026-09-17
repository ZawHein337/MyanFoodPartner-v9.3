import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/location_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepository implements LocationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<ZoneModel>?> getList() async {
    List<ZoneModel>? zoneList;
    Response response = await apiClient.getData(AppConstants.zoneListUri);
    if (response.statusCode == 200) {
      zoneList = [];
      response.body.forEach((zone) => zoneList!.add(ZoneModel.fromJson(zone)));
    }
    return zoneList;
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = 'Unknown Location Found';
    Response response = await apiClient.getData('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
    if(response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    }else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return address;
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
    if (response.statusCode == 200) {
      predictionList = [];
      response.body['suggestions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  @override
  Future<Response?> getPlaceDetails(String? placeID) async {
    Response response = await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
    return response;
  }

  @override
  Future<bool> saveUserAddress(String address) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      sharedPreferences.getString(AppConstants.languageCode),
      sharedPreferences.getString(AppConstants.type),
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  @override
  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
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
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}