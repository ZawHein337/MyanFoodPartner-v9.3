import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/address_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/edit_delivery_address/pick_map_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_delivery_address/location_search_dialog.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_validator.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class EditDeliveryAddressScreen extends StatefulWidget {
  final DeliveryAddress deliveryAddress;
  final int orderId;
  const EditDeliveryAddressScreen({super.key, required this.deliveryAddress, required this.orderId});

  @override
  State<EditDeliveryAddressScreen> createState() => _EditDeliveryAddressScreenState();
}

class _EditDeliveryAddressScreenState extends State<EditDeliveryAddressScreen> {

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();

  String? _countryDialCode;
  String? _countryCode;

  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    AddressController addressController = Get.find<AddressController>();
    addressController.updateAddress(widget.deliveryAddress);
    _initialPosition = LatLng(
      double.parse(widget.deliveryAddress.latitude ?? '0'),
      double.parse(widget.deliveryAddress.longitude ?? '0'),
    );
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code;
    _splitPhone(widget.deliveryAddress.contactPersonNumber);
    addressController.setSelectedAddressType(widget.deliveryAddress.addressType, isUpdate: false);
    _contactPersonNameController.text = widget.deliveryAddress.contactPersonName ?? '';
    _streetNumberController.text = widget.deliveryAddress.streetNumber ?? '';
    _houseController.text = widget.deliveryAddress.house ?? '';
    _floorController.text = widget.deliveryAddress.floor ?? '';
    _addressController.text = widget.deliveryAddress.address ?? '';
  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _countryCode = phoneNumber.isoCode.name;
        _contactPersonNumberController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'edit_delivery_address'.tr),

      body: GetBuilder<AddressController>(builder: (addressController) {

        _addressController.text = addressController.address ?? '';
        
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Container(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 1)],
                ),
                child: Column(children: [

                  Stack(clipBehavior: Clip.none, children: [
                    CustomDropdownButton(
                      hintText: 'select_address_type'.tr,
                      items: addressController.addressTypeList,
                      selectedValue: addressController.selectedAddressType,
                      onChanged: (value) {
                        addressController.setSelectedAddressType(value!);
                      },
                    ),

                    Positioned(
                      left: 10, top: -10,
                      child: Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(2),
                        child: Row(children: [
                          Text('address_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                          Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'type_your_name'.tr,
                    labelText: 'name'.tr,
                    required: true,
                    controller: _contactPersonNameController,
                    focusNode: _nameNode,
                    nextFocus: _numberNode,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'xxx-xxx-xxxxx',
                    labelText: 'phone_number'.tr,
                    required: true,
                    controller: _contactPersonNumberController,
                    focusNode: _numberNode,
                    nextFocus: _streetNode,
                    inputType: TextInputType.phone,
                    isPhone: true,
                    onCountryChanged: (CountryCode countryCode) {
                      _countryDialCode = countryCode.dialCode;
                    },
                    countryDialCode: _countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: "ex_02".tr,
                    labelText: 'street_number'.tr,
                    inputType: TextInputType.streetAddress,
                    focusNode: _streetNode,
                    nextFocus: _houseNode,
                    controller: _streetNumberController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'ex_1005/2'.tr,
                    labelText: 'house'.tr,
                    inputType: TextInputType.text,
                    focusNode: _houseNode,
                    nextFocus: _floorNode,
                    controller: _houseController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'ex_02'.tr,
                    labelText: 'floor'.tr,
                    inputType: TextInputType.text,
                    focusNode: _floorNode,
                    inputAction: TextInputAction.done,
                    controller: _floorController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'address'.tr,
                    labelText: 'type_address'.tr,
                    required: true,
                    inputType: TextInputType.streetAddress,
                    focusNode: _addressNode,
                    nextFocus: _nameNode,
                    controller: _addressController,
                    maxLines: 3,
                    onChanged: (text) => addressController.setPlaceMark(text),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(width: 1.5, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: Stack(clipBehavior: Clip.none, children: [
                  
                          GoogleMap(
                            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                            onTap: (latLng) {
                              Get.toNamed(
                                RouteHelper.getPickMapRoute(),
                                arguments: PickMapScreen(
                                  googleMapController: addressController.mapController,
                                ),
                              );
                            },
                            zoomControlsEnabled: true,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            onCameraIdle: () {
                              addressController.updatePosition(_cameraPosition, true);
                            },
                            onCameraMove: ((position) => _cameraPosition = position),
                            onMapCreated: (GoogleMapController controller) {
                              addressController.setMapController(controller);
                              if (widget.deliveryAddress.address == null) {
                                addressController.getCurrentLocation(true, mapController: controller);
                              }
                            },
                            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                              Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                              Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                              Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                            },
                            style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                          ),
                  
                          addressController.isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
                  
                          Center(
                            child: !addressController.isLoading ? Image.asset(Images.pickMarker, height: 40, width: 40) : const CircularProgressIndicator(),
                          ),
                  
                          /*Positioned(
                            bottom: 10, right: 0,
                            child: InkWell(
                              onTap: () => _checkPermission(() {
                                addressController.getCurrentLocation(true, mapController: addressController.mapController);
                              }),
                              child: Container(
                                width: 30, height: 30,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor),
                                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                              ),
                            ),
                          ),*/
                  
                          Positioned(
                            bottom: 110, right: 10,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  RouteHelper.getPickMapRoute(),
                                  arguments: PickMapScreen(
                                    googleMapController: addressController.mapController,
                                  ),
                                );
                              },
                              child: Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor),
                                child: Icon(Icons.fullscreen, color: Theme.of(context).hintColor, size: 30),
                              ),
                            ),
                          ),
                  
                          Positioned(
                            top: 10, right: 10,
                            child: LocationSearchDialog(
                              mapController: addressController.mapController,
                              fromAddress: true,
                              pickedLocation: _addressController.text,
                              callBack: (Position? position) {
                                if (position != null) {
                                  _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                                  addressController.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                                  addressController.updatePosition(_cameraPosition, true);
                                }
                              },
                              child: Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)],
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  
                  ]),

                ]),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: Row(children: [

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'cancel'.tr,
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: CustomButtonWidget(
                  buttonText: 'update'.tr,
                  isLoading: addressController.updateLoading,
                  onPressed: () async {

                    String address = _addressController.text.trim();
                    String contactPersonName = _contactPersonNameController.text.trim();
                    String streetNumber = _streetNumberController.text.trim();
                    String house = _houseController.text.trim();
                    String floor = _floorController.text.trim();

                    String contactPersonNumber = _contactPersonNumberController.text.trim();
                    String numberWithCountryCode = _countryDialCode! + contactPersonNumber;
                    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
                    numberWithCountryCode = phoneValid.phone;

                    if(addressController.selectedAddressType == null) {
                      showCustomSnackBar('select_address_type'.tr);
                    }else if(contactPersonName.isEmpty){
                      showCustomSnackBar('enter_contact_person_name'.tr);
                    }else if(contactPersonNumber.isEmpty){
                      showCustomSnackBar('enter_contact_person_number'.tr);
                    } else if (!phoneValid.isValid) {
                      showCustomSnackBar('invalid_phone_number'.tr);
                    }else if(address.isEmpty){
                      showCustomSnackBar('pick_an_address'.tr);
                    }else{
                      addressController.updateDeliveryAddress(
                        DeliveryAddress(
                          contactPersonName: contactPersonName,
                          contactPersonNumber: numberWithCountryCode,
                          addressType: addressController.selectedAddressType,
                          address: address,
                          latitude: addressController.position.latitude.toString(),
                          longitude: addressController.position.longitude.toString(),
                          streetNumber: streetNumber, house: house, floor: floor,
                        ),
                        widget.orderId,
                      );
                    }
                  },
                ),
              ),

            ]),
          ),

        ]);
      }),
    );
  }

/*  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }*/

}
