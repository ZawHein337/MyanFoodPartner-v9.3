import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/address_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_delivery_address/location_search_dialog.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_delivery_address/permission_dialog.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';

class PickMapScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const PickMapScreen({super.key, this.googleMapController});

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    super.initState();

    Get.find<AddressController>().makeLoadingOff();
    Get.find<AddressController>().setPickData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<AddressController>(builder: (addressController) {
          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(addressController.position.latitude, addressController.position.longitude),
                zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
              },
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                addressController.disableButton();
              },
              onCameraIdle: () {
                Get.find<AddressController>().updatePosition(_cameraPosition, false);
              },
              style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
            ),

            Center(child: !addressController.isLoading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                : const CircularProgressIndicator()),

            Positioned(
              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: LocationSearchDialog(mapController: _mapController, pickedLocation: addressController.pickAddress!),
            ),

            Positioned(
              bottom: 80, right: Dimensions.paddingSizeSmall,
              child: FloatingActionButton(
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => _checkPermission(() {
                  Get.find<AddressController>().getCurrentLocation(false, mapController: _mapController);
                }),
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
              ),
            ),

            Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: CustomButtonWidget(
                buttonText: addressController.inZone ? 'pick_address'.tr : 'service_not_available_in_this_area'.tr,
                isLoading: addressController.isLoading,
                onPressed: (addressController.buttonDisabled || addressController.isLoading) ? null
                    : () => _onPickAddressButtonPressed(addressController),
              ),
            ),

          ]);
        }),
      ))),
    );
  }

  void _onPickAddressButtonPressed(AddressController addressController) {
    if(addressController.pickPosition.latitude != 0 && addressController.pickAddress!.isNotEmpty) {
      if(widget.googleMapController != null) {
        widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
          addressController.pickPosition.latitude, addressController.pickPosition.longitude,
        ), zoom: 17)));
        addressController.addAddressData();
      }
      Get.back();
    }else {
      showCustomSnackBar('pick_an_address'.tr);
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}
