import 'dart:convert';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/address_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/location_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class LocationController extends GetxController implements GetxService {
  final LocationServiceInterface locationServiceInterface;
  LocationController({required this.locationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  int? _selectedZoneIndex = -1;
  int? get selectedZoneIndex => _selectedZoneIndex;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;

  String? _storeAddress;
  String? get storeAddress => _storeAddress;

  bool _loading = false;
  bool get loading => _loading;

  bool _inZone = false;
  bool get inZone => _inZone;

  int _zoneID = 0;
  int get zoneID => _zoneID;

  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position get pickPosition => _pickPosition;

  String? _pickAddress = '';
  String? get pickAddress => _pickAddress;

  List<PredictionModel> _predictionList = [];
  List<PredictionModel> get predictionList => _predictionList;

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = -1;
    _restaurantLocation = null;
    _zoneIds = null;
    List<ZoneModel>? zoneList = await locationServiceInterface.getZoneList();
    if (zoneList != null) {
      _zoneList = [];
      _zoneList!.addAll(zoneList);
    }
    update();
  }

  void setZoneIndex(int? index) {
    _selectedZoneIndex = index;
    update();
  }

  void setLocation(LatLng location) async{
    ZoneResponseModel response = await getZone(
      location.latitude.toString(), location.longitude.toString(), false,
    );
    _storeAddress = await _getAddressFromGeocode(LatLng(location.latitude, location.longitude));
    _restaurantLocation = locationServiceInterface.setRestaurantLocation(response, location);
    _zoneIds = locationServiceInterface.setZoneIds(response);
    /*if(_selectedZoneIndex != -1){
      _selectedZoneIndex = locationServiceInterface.setSelectedZoneIndex(response, _zoneIds, _selectedZoneIndex, _zoneList);
    }*/
    update();
  }

  Future<String> _getAddressFromGeocode(LatLng latLng) async {
    String address = await locationServiceInterface.getAddressFromGeocode(latLng);
    return address;
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool updateInAddress = false}) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    if(!updateInAddress){
      update();
    }
    ZoneResponseModel responseModel;
    Response response = await locationServiceInterface.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _zoneID = int.parse(jsonDecode(response.body['zone_id'])[0].toString());
      List<int> zoneIds = [];
      jsonDecode(response.body['zone_id']).forEach((zoneId){
        zoneIds.add(int.parse(zoneId.toString()));
      });
      List<ZoneData> zoneData = [];
      response.body['zone_data'].forEach((data) => zoneData.add(ZoneData.fromJson(data)));
      responseModel = ZoneResponseModel(true, '' , zoneIds, zoneData);
      if(updateInAddress) {
        AddressModel address = getUserAddress()!;
        address.zoneData = zoneData;
        saveUserAddress(address);
      }
    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.statusText, [], []);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await locationServiceInterface.saveUserAddress(userAddress);
  }

  AddressModel? getUserAddress() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(locationServiceInterface.getUserAddress()!));
    }catch(e) {
      debugPrint('Address Not Found In SharedPreference:$e');
    }
    return addressModel;
  }

  Future<void> zoomToFit(GoogleMapController googleMapController, List<LatLng> list, {double padding = 0.5}) async {
    LatLngBounds bounds = locationServiceInterface.computeBounds(list);
    LatLng centerBounds = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude)/2,
      (bounds.northeast.longitude + bounds.southwest.longitude)/2,
    );
    googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 16)));
    locationServiceInterface.prepareZoomToFit(googleMapController, bounds, centerBounds, padding);
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      List<PredictionModel> predictionList = await locationServiceInterface.searchLocation(text);
      if(predictionList.isNotEmpty) {
        _predictionList = [];
        _predictionList.addAll(predictionList);
      }
    }
    return _predictionList;
  }

  Future<Position> setSuggestedLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _isLoading = true;
    update();

    LatLng latLng = const LatLng(0, 0);
    Response response = await locationServiceInterface.getPlaceDetails(placeID);

    if(response.statusCode == 200) {
      final data = response.body;
      final location = data['location'];
      final double lat = location['latitude'];
      final double lng = location['longitude'];
      latLng = LatLng(lat, lng);
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );

    _pickAddress = address;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
    }
    _isLoading = false;
    update();
    return _pickPosition;
  }

}