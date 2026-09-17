import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/location_search_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/zone_selection_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationViewWidget extends StatefulWidget {
  final bool fromView;
  final GoogleMapController? mapController;
  const SelectLocationViewWidget({super.key, required this.fromView, this.mapController});

  @override
  State<SelectLocationViewWidget> createState() => _SelectLocationViewWidgetState();
}

class _SelectLocationViewWidgetState extends State<SelectLocationViewWidget> {

  late CameraPosition _cameraPosition;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController? _mapController;
  GoogleMapController? _screenMapController;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: LatLng(
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
      ), zoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {

      List<int> zoneIndexList = [];
      List<DropdownItem<int>> zoneList = [];
      if(locationController.zoneList != null && locationController.zoneIds != null) {
        for(int index=0; index<locationController.zoneList!.length; index++) {
          zoneIndexList.add(index);
          zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${locationController.zoneList![index].name}'),
            ),
          )));
        }
      }

      return SizedBox(child: Padding(
        padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.paddingSizeSmall),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [
              Expanded(child: ZoneSelectionWidget(zoneList: zoneList)),
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            mapView(locationController),
            SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0),

            !widget.fromView ? CustomButtonWidget(
              buttonText: 'set_location'.tr,
              onPressed: () {
                try{
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                  Get.back();
                }catch(e){
                  showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                }
              },
            ) : const SizedBox()

          ]),
        ),
      ));
    });
  }

  Widget mapView(LocationController locationController) {
    return locationController.zoneList!.isNotEmpty ? Container(
      height: widget.fromView ? 225 : (context.height * 0.55),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(width: 1, color: Theme.of(context).hintColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Stack(clipBehavior: Clip.none, children: [

          GestureDetector(
            onVerticalDragStart: (details) {},
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
                  double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
                ), zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomControlsEnabled: !widget.fromView ? true : false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              zoomGesturesEnabled: true,
              polygons: _polygons,
              onCameraIdle: () {
                locationController.setLocation(_cameraPosition.target);
                if(!widget.fromView) {
                  widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                }
              },
              onCameraMove: ((position) => _cameraPosition = position),
              onMapCreated: (GoogleMapController controller) {
                locationController.setLocation(LatLng(
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                  double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
                ));
                if(widget.fromView) {
                  _mapController = controller;
                }else {
                  _screenMapController = controller;
                }
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
              },
            ),
          ),

          Center(child: Image.asset(Images.pickMarker, height: 30, width: 20)),

          widget.fromView ? Positioned(
            top: 10, left: 10,
            child: InkWell(
              onTap: () async {
                var p = await Get.dialog(LocationSearchDialogWidget(mapController: widget.fromView ? _mapController : _screenMapController));
                Position? position = p;
                if(position != null) {
                  _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                  if(!widget.fromView) {
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    locationController.setLocation(_cameraPosition.target);
                  }
                }
              },
              child: Container(
                height: 30, width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
              ),
            ),
          ) : const SizedBox(),

          widget.fromView ? Positioned(
            bottom: 10, right: -10,
            child: InkWell(
              onTap: () {
                Get.to(Scaffold(
                  appBar: CustomAppBarWidget(title: 'set_your_store_location'.tr),
                  body: SelectLocationViewWidget(fromView: false, mapController: _mapController),
                ));
              },
              child: Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                child: Icon(Icons.fullscreen, color: Theme.of(context).hintColor, size: 20),
              ),
            ),
          ) : const SizedBox(),

        ]),
      ),
    ) : const SizedBox();
  }
}