import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/address_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';

class AddressRepository implements AddressRepositoryInterface{
  final ApiClient apiClient;
  AddressRepository({required this.apiClient});

  @override
  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  @override
  Future<Response> getLatLng(String? id) async {
    Response response = await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$id');
    return response;
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    Response response = await apiClient.getData('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
    String address = 'Unknown Location Found';
    if(response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    }else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return address;
  }

  @override
  Future<ZoneResponseModel> getZone(String? lat, String? lng) async {
    Response response = await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng', handleError: false);
    if(response.statusCode == 200) {
      ZoneResponseModel responseModel;
      responseModel = ZoneResponseModel(true, '' , [], []);
      return responseModel;
    } else {
      return ZoneResponseModel(false, response.statusText, [], []);
    }
  }

  @override
  Future<ResponseModel> updateDeliveryAddress(DeliveryAddress deliveryAddress, int orderId) async {
    Map<String, dynamic> body = {
      '_method': 'put',
      'order_id': orderId,
      'contact_person_name': deliveryAddress.contactPersonName,
      'contact_person_number': deliveryAddress.contactPersonNumber,
      'address_type': deliveryAddress.addressType,
      'address': deliveryAddress.address,
      'latitude': deliveryAddress.latitude,
      'longitude': deliveryAddress.longitude,
      'road': deliveryAddress.streetNumber,
      'house': deliveryAddress.house,
      'floor': deliveryAddress.floor,
    };

    Response response = await apiClient.postData(AppConstants.updateCustomerAddressUri, body, handleError: false);
    ResponseModel responseModel;
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
