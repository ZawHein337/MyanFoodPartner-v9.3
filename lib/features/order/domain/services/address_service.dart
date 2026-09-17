import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/address_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/address_service_interface.dart';

class AddressService implements AddressServiceInterface{
  final AddressRepositoryInterface addressRepositoryInterface;
  AddressService({required this.addressRepositoryInterface});

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await addressRepositoryInterface.searchLocation(text);
    if (response.statusCode == 200) {
      predictionList = [];
      response.body['suggestions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  @override
  Future<LatLng> getLatLng(String id) async {
    LatLng latLng = const LatLng(0, 0);
    Response? response = await addressRepositoryInterface.getLatLng(id);
    if(response.statusCode == 200) {
      final data = response.body;
      final location = data['location'];
      final double lat = location['latitude'];
      final double lng = location['longitude'];
      latLng = LatLng(lat, lng);
    }
    return latLng;
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    return await addressRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  void handleMapAnimation(GoogleMapController? mapController, Position myPosition) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 16),
      ));
    }
  }

  @override
  Future<Position> getPosition(LatLng? defaultLatLng, LatLng configLatLng) async {
    Position myPosition;
    try {
      await Geolocator.requestPermission();
      Position newLocalData = await Geolocator.getCurrentPosition();
      myPosition = newLocalData;
    }catch(e) {
      myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : configLatLng.latitude,
        longitude: defaultLatLng != null ? defaultLatLng.longitude : configLatLng.longitude,
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,

      );
    }
    return myPosition;
  }

  @override
  Future<ZoneResponseModel> getZone(String? lat, String? lng) async {
    return await addressRepositoryInterface.getZone(lat, lng);
  }

  @override
  Future<ResponseModel> updateDeliveryAddress(DeliveryAddress deliveryAddress, int orderId) async {
    return await addressRepositoryInterface.updateDeliveryAddress(deliveryAddress, orderId);
  }

}