import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/base_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/package_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/models/restaurant_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/additional_data_section_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/custom_time_picker_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/select_location_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantRegistrationScreen extends StatefulWidget {
  const RestaurantRegistrationScreen({super.key});

  @override
  State<RestaurantRegistrationScreen> createState() => _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState extends State<RestaurantRegistrationScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _nameController = [];
  final List<TextEditingController> _addressController = [];
  final TextEditingController _tinNumberController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final List<FocusNode> _nameFocus = [];
  final List<FocusNode> _addressFocus = [];
  final FocusNode _tinFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool firstTime = true;
  TabController? _tabController;
  final List<Tab> _tabs =[];

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  String? _countryDialCode;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _nameFocus.add(FocusNode());
      _addressFocus.add(FocusNode());
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    Get.find<AuthController>().resetData();
    Get.find<AuthController>().pickImageForRegistration(false, true);
    Get.find<AuthController>().setJoinUsPageData(willUpdate: false);
    Get.find<AuthController>().storeStatusChange(0.1, willUpdate: false);
    Get.find<RestaurantController>().getCuisineList();
    Get.find<LocationController>().getZoneList();
    Get.find<AuthController>().resetBusiness();
    Get.find<AuthController>().getPackageList(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<LocationController>(builder: (locationController) {
        return GetBuilder<RestaurantController>(builder: (restaurantController) {

          if(locationController.storeAddress != null && _languageList!.isNotEmpty){
            _addressController[0].text = locationController.storeAddress.toString();
          }
          List<int> cuisines = [];
          if(restaurantController.cuisineModel != null) {
            for(int index=0; index<restaurantController.cuisineModel!.cuisines!.length; index++) {
              if(restaurantController.cuisineModel!.cuisines![index].status == 1 && !restaurantController.selectedCuisines!.contains(index)) {
                cuisines.add(index);
              }
            }
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async{
              if(authController.storeStatus == 0.6 && firstTime){
                authController.storeStatusChange(0.1);
                firstTime = false;
              }else if(authController.storeStatus == 0.9){
                authController.storeStatusChange(0.6);
              }else {
                await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
              }
            },
            child: Scaffold(

              appBar: AppBar(
                title: Text(
                  'restaurant_registration'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () async {
                    if(authController.storeStatus == 0.6 && firstTime){
                      authController.storeStatusChange(0.1);
                      firstTime = false;
                    }else if(authController.storeStatus == 0.9){
                      authController.storeStatusChange(0.6);
                    }else {
                      await _showBackPressedDialogue('your_registration_not_setup_yet'.tr);
                    }
                  },
                ),
                backgroundColor: Theme.of(context).cardColor,
                surfaceTintColor: Theme.of(context).cardColor,
                shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                elevation: 2,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    height: 2,
                    child: Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                      Expanded(
                        child: Container(
                          height: 2,
                          color: authController.storeStatus == 0.1 ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : Theme.of(context).primaryColor,
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 2,
                          color: authController.storeStatus == 0.6 ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : authController.storeStatus == 0.9 ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.5),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 2,
                          color: authController.storeStatus == 0.9 ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : Theme.of(context).hintColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              body: Column(children: [

                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Column(children: [

                        Visibility(
                          visible: authController.storeStatus == 0.1,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('restaurant_name'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                SizedBox(
                                  height: 40,
                                  child: TabBar(
                                    tabAlignment: TabAlignment.start,
                                    controller: _tabController,
                                    indicatorColor: Theme.of(context).primaryColor,
                                    indicatorWeight: 3,
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor: Theme.of(context).hintColor,
                                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                    labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                    indicatorPadding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: _tabs,
                                    dividerColor: Colors.transparent,
                                    onTap: (int ? value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                  child: Divider(height: 0),
                                ),

                                Text('insert_language_wise_restaurant_name'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                CustomTextFieldWidget(
                                  hintText: '${'restaurant_name'.tr} (${_languageList?[_tabController!.index].value!})',
                                  labelText: '${'restaurant_name'.tr} (${_languageList?[_tabController!.index].value!})',
                                  controller: _nameController[_tabController!.index],
                                  focusNode: _nameFocus[_tabController!.index],
                                  nextFocus: _tabController!.index != _languageList!.length-1 ? _addressFocus[_tabController!.index] : _addressFocus[0],
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                  required: true,
                                ),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Text('zone_and_address'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(children: [

                                locationController.zoneList != null ? const SelectLocationViewWidget(fromView: true) : Column(children: [

                                  Shimmer(
                                    child: Container(
                                      height: 45, width: context.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),

                                  Shimmer(
                                    child: Container(
                                      height: 220, width: context.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).shadowColor,
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      ),
                                    ),
                                  ),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                CustomTextFieldWidget(
                                  hintText: 'enter_restaurant_address'.tr,
                                  labelText: 'address'.tr,
                                  controller: _addressController[0],
                                  focusNode: _addressFocus[0],
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.sentences,
                                  maxLines: 3,
                                  required: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                /*CustomTextFieldWidget(
                                  hintText: 'vat_tax'.tr,
                                  labelText: 'vat_tax'.tr,
                                  controller: _vatController,
                                  focusNode: _vatFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.number,
                                  isAmount: true,
                                  required: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),*/

                                Column(children: [

                                  Autocomplete<int>(
                                    optionsBuilder: (TextEditingValue value) {
                                      if(value.text.isEmpty) {
                                        return const Iterable<int>.empty();
                                      }else {
                                        return cuisines.where((cuisine) => restaurantController.cuisineModel!.cuisines![cuisine].name!.toLowerCase().contains(value.text.toLowerCase()));
                                      }
                                    },
                                    fieldViewBuilder: (context, controller, node, onComplete) {
                                      _c = controller;
                                      return Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        ),
                                        child: TextField(
                                          controller: controller,
                                          focusNode: node,
                                          textInputAction: TextInputAction.done,
                                          onEditingComplete: () {
                                            onComplete();
                                            controller.text = '';
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'cuisines'.tr,
                                            hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                            labelText: 'cuisines'.tr,
                                            labelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              borderSide: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              borderSide: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                              borderSide: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    optionsViewBuilder: (context, Function(int i) onSelected, data) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: context.width *0.4),
                                          child: ListView.builder(
                                            itemCount: data.length,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) => Material(
                                              child: InkWell(
                                                onTap: () => onSelected(data.elementAt(index)),
                                                child: Container(
                                                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                                                  child: Text(restaurantController.cuisineModel!.cuisines![data.elementAt(index)].name ?? ''),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    displayStringForOption: (value) => restaurantController.cuisineModel!.cuisines![value].name!,
                                    onSelected: (int value) {
                                      _c.text = '';
                                      restaurantController.setSelectedCuisineIndex(value, true);
                                    },
                                  ),
                                  SizedBox(height: restaurantController.selectedCuisines!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                                  SizedBox(
                                    height: restaurantController.selectedCuisines!.isNotEmpty ? 40 : 0,
                                    child: ListView.builder(
                                      itemCount: restaurantController.selectedCuisines!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          ),
                                          child: Row(children: [

                                            Text(
                                              restaurantController.cuisineModel!.cuisines![restaurantController.selectedCuisines![index]].name!,
                                              style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                                            ),

                                            InkWell(
                                              onTap: () => restaurantController.removeCuisine(index),
                                              child: Padding(
                                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                                child: Icon(Icons.close, size: 15, color: Theme.of(context).cardColor),
                                              ),
                                            ),

                                          ]),
                                        );
                                      },
                                    ),
                                  ),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                InkWell(
                                  onTap: () {
                                    Get.dialog(const CustomTimePickerWidget());
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          border: Border.all(color: Theme.of(context).hintColor, width: 0.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                        child: Row(children: [
                                          Expanded(child: Text(
                                            '${authController.storeMinTime} : ${authController.storeMaxTime} ${authController.storeTimeUnit}',
                                            style: robotoMedium,
                                          )),

                                          Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor),
                                        ]),
                                      ),

                                      Positioned(
                                        left: 10, top: -15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              Text('delivery_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                              Text(' *', style: robotoRegular.copyWith(color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Text('business_tin'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                CustomTextFieldWidget(
                                  hintText: 'taxpayer_identification_number_tin'.tr,
                                  labelText: 'tin'.tr,
                                  controller: _tinNumberController,
                                  focusNode: _tinFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.number,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                InkWell(
                                  onTap: () async {
                                    final DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      authController.setTinExpireDate(pickedDate);
                                    }
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          border: Border.all(color: Theme.of(context).hintColor, width: 0.5),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                        child: Row(children: [
                                          Expanded(child: Text(
                                            authController.tinExpireDate ?? 'select_date'.tr,
                                            style: robotoMedium,
                                          )),
                                          Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                                        ]),
                                      ),

                                      Positioned(
                                        left: 10, top: -15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Text('expire_date'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                Text('tin_certificate'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                Text('doc_format'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                authController.tinFiles!.isEmpty ? InkWell(
                                  onTap: () {
                                    authController.pickFiles();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: const Radius.circular(Dimensions.radiusDefault),
                                        dashPattern: const [8, 4],
                                        strokeWidth: 1,
                                        color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                      ),
                                      child: Container(
                                        height: 120,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(width: Dimensions.paddingSizeSmall),
                                            CustomAssetImageWidget(image: Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                            const SizedBox(width: Dimensions.paddingSizeSmall),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'click_to_upload'.tr,
                                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      radius: const Radius.circular(Dimensions.radiusDefault),
                                      dashPattern: const [8, 4],
                                      strokeWidth: 1,
                                      color: const Color(0xFFE5E5E5),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                                            height: 120,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFAFAFA),
                                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Builder(
                                                        builder: (context) {
                                                          final filePath = authController.tinFiles![0].paths[0];
                                                          final fileName = filePath!.split('/').last.toLowerCase();

                                                          if (fileName.endsWith('.pdf')) {
                                                            // Show PDF preview
                                                            return Row(
                                                              children: [
                                                                const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                                                const SizedBox(width: 10),
                                                                Expanded(
                                                                  child: Text(
                                                                    fileName,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 35),
                                                              ],
                                                            );
                                                          } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
                                                            // Show Word document preview
                                                            return Row(
                                                              children: [
                                                                const Icon(Icons.description, size: 40, color: Colors.blue),
                                                                const SizedBox(width: 10),
                                                                Expanded(
                                                                  child: Text(
                                                                    fileName,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 35),
                                                              ],
                                                            );
                                                          } else {
                                                            // Show generic file preview
                                                            return Row(
                                                              children: [
                                                                const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                                                                const SizedBox(width: 10),
                                                                Expanded(
                                                                  child: Text(
                                                                    fileName,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 35),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                authController.removeFile(0);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                child: Icon(Icons.delete_forever, color: Colors.red),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Container(
                              width: context.width,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'restaurant_logo'.tr,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text('image_format_and_ratio_for_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                Align(alignment: Alignment.center, child: Stack(children: [

                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                        authController.pickedLogo!.path, width: 120, height: 120, fit: BoxFit.cover,
                                      ) : Image.file(
                                        File(authController.pickedLogo!.path), width: 120, height: 120, fit: BoxFit.cover,
                                      ) : SizedBox(
                                        width: 120, height: 120,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                          CustomAssetImageWidget(image: Images.pictureIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                          Text(
                                            'click_to_add'.tr,
                                            style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                          ),

                                        ]),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0, right: 0, top: 0, left: 0,
                                    child: InkWell(
                                      onTap: () => authController.pickImageForRegistration(true, false),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          color: Theme.of(context).hintColor,
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.butt,
                                          dashPattern: const [5, 5],
                                          padding: const EdgeInsets.all(0),
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: const SizedBox(width: 120, height: 120),
                                      ),
                                    ),
                                  ),

                                ])),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Container(
                              width: context.width,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'restaurant_cover'.tr,
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text('image_format_and_ratio_for_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40, right: 40, top: 20, bottom: 20,
                                  ),
                                  child: Stack(children: [

                                    Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                                          authController.pickedCover!.path, width: context.width, height: 140, fit: BoxFit.cover,
                                        ) : Image.file(
                                          File(authController.pickedCover!.path), width: context.width, height: 140, fit: BoxFit.cover,
                                        ) : SizedBox(
                                          width: context.width, height: 140,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                            CustomAssetImageWidget(image: Images.pictureIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                                            const SizedBox(width: Dimensions.paddingSizeSmall),

                                            Text(
                                              'click_to_add'.tr,
                                              style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                            ),

                                          ]),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0, right: 0, top: 0, left: 0,
                                      child: InkWell(
                                        onTap: () => authController.pickImageForRegistration(false, false),
                                        child: DottedBorder(
                                          options: RoundedRectDottedBorderOptions(
                                            color: Theme.of(context).hintColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.butt,
                                            dashPattern: const [5, 5],
                                            padding: const EdgeInsets.all(0),
                                            radius: const Radius.circular(Dimensions.radiusDefault),
                                          ),
                                          child: SizedBox(width: context.width, height: 140),
                                        ),
                                      ),
                                    ),

                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                              ]),
                            ),
                          ]),
                        ),

                        Visibility(
                          visible: authController.storeStatus == 0.6,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('owner_information'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(children: [

                                CustomTextFieldWidget(
                                  hintText : 'first_name'.tr,
                                  labelText: 'first_name'.tr,
                                  controller: _fNameController,
                                  focusNode: _fNameFocus,
                                  nextFocus: _lNameFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                  required: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                CustomTextFieldWidget(
                                  hintText : 'last_name'.tr,
                                  labelText: 'last_name'.tr,
                                  controller: _lNameController,
                                  focusNode: _lNameFocus,
                                  nextFocus: _phoneFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                  required: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                CustomTextFieldWidget(
                                  hintText : 'enter_phone_number'.tr,
                                  labelText: 'phone_number'.tr,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  nextFocus: _emailFocus,
                                  inputType: TextInputType.phone,
                                  isPhone: true,
                                  required: true,
                                  showTitle: ResponsiveHelper.isDesktop(context),
                                  onCountryChanged: (CountryCode countryCode) {
                                    _countryDialCode = countryCode.dialCode;
                                  },
                                  countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                      : Get.find<LocalizationController>().locale.countryCode,
                                ),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            Text('account_information'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                CustomTextFieldWidget(
                                  hintText: 'email'.tr,
                                  labelText: 'email'.tr,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                  required: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                CustomTextFieldWidget(
                                  hintText: 'password'.tr,
                                  labelText: 'password'.tr,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  nextFocus: _confirmPasswordFocus,
                                  inputType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  required: true,
                                  onChanged: (value){
                                    if(value != null && value.isNotEmpty){
                                      if(!authController.showPassView){
                                        authController.showHidePass();
                                      }
                                      authController.validPassCheck(value);
                                    }else{
                                      if(authController.showPassView){
                                        authController.showHidePass();
                                      }
                                    }
                                  },
                                ),

                                authController.showPassView ? const PassViewWidget() : const SizedBox(),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                CustomTextFieldWidget(
                                  hintText: 'confirm_password'.tr,
                                  labelText: 'confirm_password'.tr,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  inputType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  required: true,
                                ),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            Text('additional_data'.tr, style: robotoBold),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            AdditionalDataSectionWidget(authController: authController, scrollController: _scrollController),

                          ]),
                        ),

                        Visibility(
                          visible: authController.storeStatus == 0.9,
                          child: (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) && (authController.packageModel != null && authController.packageModel!.packages!.isEmpty) ? Padding(
                            padding: EdgeInsets.only(top: context.height * 0.3),
                            child: Text('no_subscription_package_is_available'.tr, style: robotoMedium),
                          ) : Column(children: [

                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeOverLarge),
                              child: Center(child: Text('choose_your_business_plan'.tr, style: robotoBold)),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Row(children: [

                                Get.find<SplashController>().configModel!.commissionBusinessModel != 0 ? Expanded(
                                  child: BaseCardWidget(authController: authController, title: 'commission_base'.tr,
                                    index: 0, onTap: ()=> authController.setBusiness(0),
                                  ),
                                ) : const SizedBox(),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                (Get.find<SplashController>().configModel!.subscriptionBusinessModel != 0) && (authController.packageModel != null && authController.packageModel!.packages!.isNotEmpty) ? Expanded(
                                  child: BaseCardWidget(authController: authController, title: 'subscription_base'.tr,
                                    index: 1, onTap: ()=> authController.setBusiness(1),
                                  ),
                                ) : const SizedBox(),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            authController.businessIndex == 0 ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Text(
                                "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                              ),
                            ) : (authController.packageModel != null && authController.packageModel!.packages!.isNotEmpty) ? Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Text(
                                  'run_restaurant_by_purchasing_subscription_packages'.tr,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              SizedBox(
                                height: 440,
                                child: authController.packageModel != null ? authController.packageModel!.packages!.isNotEmpty ? Swiper(
                                  itemCount: authController.packageModel!.packages!.length,
                                  viewportFraction: authController.packageModel!.packages!.length > 1 ? 0.7 : 1,
                                  physics: authController.packageModel!.packages!.length > 1 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {

                                    Packages package = authController.packageModel!.packages![index];

                                    return PackageCardWidget(
                                      currentIndex: authController.activeSubscriptionIndex == index ? index : null,
                                      package: package,
                                    );
                                  },
                                  onIndexChanged: (index) {
                                    authController.selectSubscriptionCard(index);
                                  },

                                ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('no_package_available'.tr, style: robotoMedium),
                                    ]),
                                ) : const Center(child: CircularProgressIndicator()),
                              ),

                            ]) : const SizedBox(),

                          ]),
                        ),

                      ]),
                    ),
                  ),
                ),

                ((authController.storeStatus == 0.9) && (Get.find<SplashController>().configModel!.commissionBusinessModel == 0)
                && (authController.packageModel != null && authController.packageModel!.packages!.isEmpty)) ? const SizedBox() : !authController.isLoading ? Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: CustomButtonWidget(
                    buttonText: authController.storeStatus == 0.1 || authController.storeStatus == 0.6 ? 'next'.tr : 'submit'.tr,
                    onPressed: () {

                      bool defaultNameNull = false;
                      bool defaultAddressNull = false;
                      bool customFieldEmpty = false;

                      for(int index=0; index<_languageList.length; index++) {
                        if(_languageList[index].key == 'en') {
                          if (_nameController[index].text.trim().isEmpty) {
                            defaultNameNull = true;
                          }
                          if(_addressController[index].text.trim().isEmpty){
                            defaultAddressNull = true;
                          }
                          break;
                        }
                      }

                      Map<String, dynamic> additionalData = {};
                      List<FilePickerResult> additionalDocuments = [];
                      List<String> additionalDocumentsInputType = [];

                      if(authController.storeStatus != 0.1) {
                        for (Data data in authController.dataList!) {

                          bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
                          bool isDate = data.fieldType == 'date';
                          bool isCheckBox = data.fieldType == 'check_box';
                          bool isFile = data.fieldType == 'file';
                          int index = authController.dataList!.indexOf(data);
                          bool isRequired = data.isRequired == 1;

                          if(isTextField) {
                            if(authController.additionalList![index].text != '') {
                              additionalData.addAll({data.inputData! : authController.additionalList![index].text});
                            } else {
                              if(isRequired) {
                                customFieldEmpty = true;
                                showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                                break;
                              }
                            }
                          } else if(isDate) {
                            if(authController.additionalList![index] != null) {
                              additionalData.addAll({data.inputData! : authController.additionalList![index]});
                            } else {
                              if(isRequired) {
                                customFieldEmpty = true;
                                showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
                                break;
                              }
                            }
                          } else if(isCheckBox) {
                            List<String> checkData = [];
                            bool noNeedToGoElse = false;
                            for(var e in authController.additionalList![index]) {
                              if(e != 0) {
                                checkData.add(e);
                                customFieldEmpty = false;
                                noNeedToGoElse = true;
                              } else if(!noNeedToGoElse) {
                                customFieldEmpty = true;
                              }
                            }
                            if(customFieldEmpty && isRequired) {
                              showCustomSnackBar( '${'please_set_data_in'.tr} ${authController.dataList![index].inputData!.replaceAll('_', ' ')} ${'field'.tr}');
                              break;
                            } else {
                              additionalData.addAll({data.inputData! : checkData});
                            }

                          } else if(isFile) {
                            if(authController.additionalList![index].length == 0 && isRequired) {
                              customFieldEmpty = true;
                              showCustomSnackBar('${'please_add'.tr} ${authController.dataList![index].inputData!.replaceAll('_', ' ')}');
                              break;
                            } else {
                              authController.additionalList![index].forEach((file) {
                                additionalDocuments.add(file);
                                additionalDocumentsInputType.add(authController.dataList![index].inputData!);
                              });
                            }
                          }
                        }
                      }

                      String tin = _tinNumberController.text.trim();
                      String minTime = authController.storeMinTime;
                      String maxTime = authController.storeMaxTime;
                      String fName = _fNameController.text.trim();
                      String lName = _lNameController.text.trim();
                      String phone = _phoneController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      String confirmPassword = _confirmPasswordController.text.trim();
                      String phoneWithCountryCode = _countryDialCode != null ? _countryDialCode! + phone : phone;

                      bool valid = false;
                      try {
                        double.parse(maxTime);
                        double.parse(minTime);
                        valid = true;
                      } on FormatException {
                        valid = false;
                      }

                      if(authController.storeStatus == 0.1 || authController.storeStatus == 0.6){
                        if(authController.storeStatus == 0.1){
                          if(defaultNameNull) {
                            showCustomSnackBar('enter_restaurant_name'.tr);
                            FocusScope.of(context).requestFocus(_nameFocus[0]);
                          }else if(locationController.selectedZoneIndex == -1) {
                            showCustomSnackBar('please_select_zone'.tr);
                          }else if(locationController.restaurantLocation == null) {
                            showCustomSnackBar('set_restaurant_location'.tr);
                          }else if(defaultAddressNull) {
                            showCustomSnackBar('enter_restaurant_address'.tr);
                            FocusScope.of(context).requestFocus(_addressFocus[0]);
                          }else if(minTime.isEmpty) {
                            showCustomSnackBar('enter_minimum_delivery_time'.tr);
                          }else if(maxTime.isEmpty) {
                            showCustomSnackBar('enter_maximum_delivery_time'.tr);
                          }else if(!valid) {
                            showCustomSnackBar('please_enter_the_max_min_delivery_time'.tr);
                          }else if(valid && double.parse(minTime) > double.parse(maxTime)) {
                            showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                          }else if(authController.pickedLogo == null) {
                            showCustomSnackBar('select_restaurant_logo'.tr);
                          }else if(authController.pickedCover == null) {
                            showCustomSnackBar('select_restaurant_cover_photo'.tr);
                          }else{
                            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            authController.storeStatusChange(0.6);
                            firstTime = true;
                          }
                        }else if(authController.storeStatus == 0.6){
                          if(fName.isEmpty) {
                            showCustomSnackBar('enter_your_first_name'.tr);
                            FocusScope.of(context).requestFocus(_fNameFocus);
                          }else if(lName.isEmpty) {
                            showCustomSnackBar('enter_your_last_name'.tr);
                            FocusScope.of(context).requestFocus(_lNameFocus);
                          }else if(phone.isEmpty) {
                            showCustomSnackBar('enter_your_phone_number'.tr);
                            FocusScope.of(context).requestFocus(_phoneFocus);
                          }else if(email.isEmpty) {
                            showCustomSnackBar('enter_your_email_address'.tr);
                            FocusScope.of(context).requestFocus(_emailFocus);
                          }else if(!GetUtils.isEmail(email)) {
                            showCustomSnackBar('enter_a_valid_email_address'.tr);
                            FocusScope.of(context).requestFocus(_emailFocus);
                          }else if(password.isEmpty) {
                            showCustomSnackBar('enter_password'.tr);
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          }else if(password.length < 8) {
                            showCustomSnackBar('password_should_be'.tr);
                          }else if(password != confirmPassword) {
                            showCustomSnackBar('confirm_password_does_not_matched'.tr);
                            FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                          }else if(customFieldEmpty) {
                            if (kDebugMode) {
                              print('not provide addition data');
                            }
                          }else {
                            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            authController.storeStatusChange(0.9);
                          }
                        }else{
                          authController.storeStatusChange(0.9);
                        }
                      }else{
                        List<Translation> translation = [];
                        for(int index=0; index<_languageList.length; index++) {
                          translation.add(Translation(
                            locale: _languageList[index].key, key: 'name',
                            value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim() : _nameController[0].text.trim(),
                          ));
                          translation.add(Translation(
                            locale: _languageList[index].key, key: 'address',
                            value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim() : _addressController[0].text.trim(),
                          ));
                        }

                        List<String> cuisines = [];
                        for (var index in restaurantController.selectedCuisines!) {
                          cuisines.add(restaurantController.cuisineModel!.cuisines![index].id.toString());
                        }

                        Map<String, String> data = {};

                        data.addAll(RestaurantBodyModel(
                          deliveryTimeType: authController.storeTimeUnit,
                          translation: jsonEncode(translation), minDeliveryTime: minTime,
                          maxDeliveryTime: maxTime, lat: locationController.restaurantLocation!.latitude.toString(), email: email,
                          lng: locationController.restaurantLocation!.longitude.toString(), fName: fName, lName: lName, phone: phoneWithCountryCode,
                          password: password, zoneId: locationController.zoneList![locationController.selectedZoneIndex!].id.toString(),
                          cuisineId: cuisines,
                          businessPlan: authController.businessIndex == 0 ? 'commission' : 'subscription',
                          packageId: authController.packageModel!.packages != null && authController.packageModel!.packages!.isNotEmpty ? authController.packageModel!.packages![authController.activeSubscriptionIndex].id!.toString() : '',
                          tin: tin, tinExpireDate: authController.tinExpireDate,
                        ).toJson());

                        data.addAll({
                          'additional_data': jsonEncode(additionalData),
                        });

                        authController.registerRestaurant(data, additionalDocuments, additionalDocumentsInputType);
                      }
                    },
                  ),
                ) : const Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: CircularProgressIndicator(),
                )),

              ]),
            ),
          );
        });
      });
    });
  }

  Future<void> _showBackPressedDialogue(String title) async{
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
    ), useSafeArea: false);
  }

}