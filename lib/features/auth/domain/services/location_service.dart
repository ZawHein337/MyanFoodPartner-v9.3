import 'dart:math';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/prediction_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/location_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/location_service_interface.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService implements LocationServiceInterface {
  final LocationRepositoryInterface locationRepositoryInterface;
  LocationService({required this.locationRepositoryInterface});

  @override
  Future<List<ZoneModel>?> getZoneList() async {
    return await locationRepositoryInterface.getList();
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    return await locationRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    return await locationRepositoryInterface.searchLocation(text);
  }

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await locationRepositoryInterface.getZone(lat, lng);
  }

  @override
  Future<Response?> getPlaceDetails(String? placeID) async {
    return await locationRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  Future<bool> saveUserAddress(String address) async {
    return await locationRepositoryInterface.saveUserAddress(address);
  }

  @override
  String? getUserAddress() {
    return locationRepositoryInterface.getUserAddress();
  }

  @override
  LatLng? setRestaurantLocation(ZoneResponseModel response, LatLng location) {
    LatLng? restaurantLocation;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      restaurantLocation = location;
    }else {
      restaurantLocation = null;
    }
    return restaurantLocation;
  }

  @override
  List<int>? setZoneIds(ZoneResponseModel response) {
    List<int>? zoneIds;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      zoneIds = response.zoneIds;
    }else {
      zoneIds = null;
    }
    return zoneIds;
  }

  @override
  int? setSelectedZoneIndex(ZoneResponseModel response, List<int>? zoneIds, int? selectedZoneIndex, List<ZoneModel>? zoneList) {
    int? zoneIndex = selectedZoneIndex;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      for(int index=0; index<zoneList!.length; index++) {
        if(zoneIds!.contains(zoneList[index].id)) {
          zoneIndex = index;
          break;
        }
      }
    }
    return zoneIndex;
  }

  @override
  Future<void> prepareZoomToFit(GoogleMapController googleMapController, LatLngBounds bounds, LatLng centerBounds, double padding) async {
    bool keepZoomingOut = true;
    int count = 0;

    while(keepZoomingOut) {
      count++;
      final LatLngBounds screenBounds = await googleMapController.getVisibleRegion();
      if(_fits(bounds, screenBounds) || count == 200) {
        keepZoomingOut = false;
        final double zoomLevel = await googleMapController.getZoomLevel() - padding;
        googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        final double zoomLevel = await googleMapController.getZoomLevel() - 0.1;
        googleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool _fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  @override
  LatLngBounds computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var south = firstLatLng.latitude,
        north = firstLatLng.latitude,
        west = firstLatLng.longitude,
        east = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latLng = list[i];
      south = min(south, latLng.latitude);
      north = max(north, latLng.latitude);
      west = min(west, latLng.longitude);
      east = max(east, latLng.longitude);
    }
    return LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east));
  }

}