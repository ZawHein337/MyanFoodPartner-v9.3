import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/address_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';

class AddressController extends GetxController implements GetxService {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;

  final List<String> _addressTypeList = ['home', 'office', 'others'];
  List<String>? get addressTypeList => _addressTypeList;

  String? _selectedAddressType;
  String? get selectedAddressType => _selectedAddressType;

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position get position => _position;

  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position get pickPosition => _pickPosition;

  String? _address = '';
  String? get address => _address;

  String? _pickAddress = '';
  String? get pickAddress => _pickAddress;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  bool _inZone = false;
  bool get inZone => _inZone;

  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;

  List<PredictionModel> _predictionList = [];
  List<PredictionModel> get predictionList => _predictionList;

  bool _updateAddressData = true;
  bool _changeAddress = true;

  void setSelectedAddressType(String? addressType, {bool isUpdate = true}) {
    _selectedAddressType = addressType;
    if(isUpdate) {
      update();
    }
  }

  void updateAddress(DeliveryAddress address){
    _position = Position(
      latitude: double.parse(address.latitude!), longitude: double.parse(address.longitude!), timestamp: DateTime.now(),
      altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, floor: 1, accuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );
    _address = address.address;
  }

  void updatePosition(CameraPosition? position, bool fromAddress) async {
    if(_updateAddressData) {
      _isLoading = true;
      update();
      if (fromAddress) {
        _position = Position(
          latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
          heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 1, headingAccuracy: 1,
        );
      } else {
        _pickPosition = Position(
          latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
          heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 1, headingAccuracy: 1,
        );
      }
      ZoneResponseModel responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), true);
      _buttonDisabled = !responseModel.isSuccess;
      if (_changeAddress) {
        String addressFromGeocode = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude));
        fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;
      } else {
        _changeAddress = true;
      }
      _isLoading = false;
      update();
    }else {
      _updateAddressData = true;
    }
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<DeliveryAddress> getCurrentLocation(bool fromAddress, {GoogleMapController? mapController, LatLng? defaultLatLng, bool notify = true, bool showSnackBar = false}) async {
    _isLoading = true;
    if(notify) {
      update();
    }
    DeliveryAddress addressModel;
    Position myPosition = await addressServiceInterface.getPosition(
      defaultLatLng,
      LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      ),
    );
    fromAddress ? _position = myPosition : _pickPosition = myPosition;

    addressServiceInterface.handleMapAnimation(mapController, myPosition);
    String addressFromGeocode = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));
    fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;
    ZoneResponseModel responseModel = await getZone(myPosition.latitude.toString(), myPosition.longitude.toString(), true, showSnackBar: showSnackBar);
    _buttonDisabled = !responseModel.isSuccess;
    addressModel = DeliveryAddress(
      latitude: myPosition.latitude.toString(), longitude: myPosition.longitude.toString(), addressType: 'others',
      address: addressFromGeocode,
    );
    _isLoading = false;
    update();
    return addressModel;
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
  }

  void makeLoadingOff() {
    _isLoading = false;
  }

  void disableButton() {
    _buttonDisabled = true;
    _inZone = true;
    update();
  }

  void addAddressData() {
    _position = _pickPosition;
    _address = _pickAddress;
    _updateAddressData = false;
    update();
  }

  Future<Position> setLocation(String placeID, String? address, GoogleMapController? mapController) async {
    _isLoading = true;
    update();

    LatLng latLng = await addressServiceInterface.getLatLng(placeID);

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );
    _pickAddress = address;
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
    }
    _isLoading = false;
    update();
    return _pickPosition;
  }

  Future<List<PredictionModel>> searchLocation(String text) async {
    _predictionList = [];
    if(text.isNotEmpty) {
      _predictionList = await addressServiceInterface.searchLocation(text);
    }
    return _predictionList;
  }

  void setPlaceMark(String address) {
    _address = address;
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    return await addressServiceInterface.getAddressFromGeocode(latLng);
  }

  Future<ZoneResponseModel> getZone(String? lat, String? long, bool markerLoad, {bool updateInAddress = false, bool showSnackBar = false}) async {
    _isLoading = true;

    if(!updateInAddress){
      Future.delayed(Duration(seconds: 10), () {
        update();
      });

    }
    ZoneResponseModel responseModel = await addressServiceInterface.getZone(lat, long);
    _inZone = responseModel.isSuccess;

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateDeliveryAddress(DeliveryAddress deliveryAddress, int orderId) async {
    _updateLoading = true;
    update();

    ResponseModel responseModel = await addressServiceInterface.updateDeliveryAddress(deliveryAddress, orderId);
    if (responseModel.isSuccess) {
      Get.find<OrderController>().getOrderDetails(orderId);
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message);
    }

    _updateLoading = false;
    update();
  }

}
