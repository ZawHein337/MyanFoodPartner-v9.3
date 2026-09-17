import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/auth_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _notification = true;
  bool get notification => _notification;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

 XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  String? _subscriptionType;
  String? get subscriptionType => _subscriptionType;

  String? _expiredToken;
  String? get expiredToken => _expiredToken;

  double _storeStatus = 0.1;
  double get storeStatus => _storeStatus;

  String _storeMinTime = '10';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '15';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  List<Data>? _dataList;
  List<Data>? get dataList => _dataList;

  List<dynamic>? _additionalList;
  List<dynamic>? get additionalList => _additionalList;

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  int _businessIndex = 0;
  int get businessIndex => _businessIndex;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  int _ownerTypeIndex = 0;
  int get ownerTypeIndex => _ownerTypeIndex;

  final List<FilePickerResult> _tinFiles = [];
  List<FilePickerResult>? get tinFiles => _tinFiles;

  String? _tinExpireDate;
  String? get tinExpireDate => _tinExpireDate;

  void setJoinUsPageData({bool willUpdate = true}) {
    _dataList = [];
    _additionalList = [];
    if(Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData != null) {
      for (var data in Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData!.data!) {
        int index = Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData!.data!.indexOf(data);
        _dataList!.add(data);
        if(data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone'){
          _additionalList!.add(TextEditingController());
        } else if(data.fieldType == 'date') {
          _additionalList!.add(null);
        } else if(data.fieldType == 'check_box') {
          _additionalList!.add([]);
          if(data.checkData != null) {
            for(int i=0; i<data.checkData!.length; i++) {
              _additionalList![index].add(0);
            }
          }
        } else if(data.fieldType == 'file') {
          _additionalList!.add([]);
        }
      }
    }
    if(willUpdate) {
      update();
    }
  }

  void setAdditionalDate(int index, String date) {
    _additionalList![index] = date;
    update();
  }

  void setAdditionalCheckData(int index, int i, String date) {
    if(_additionalList![index][i] == date){
      _additionalList![index][i] = 0;
    } else {
      _additionalList![index][i] = date;
    }
    update();
  }

  void removeAdditionalFile(int index, int subIndex) {
    _additionalList![index].removeAt(subIndex);
    update();
  }

  Future<void> pickFile(int index, MediaData mediaData) async {
    FilePickerResult? result = await authServiceInterface.picFile(mediaData);
    if(result != null) {
      _additionalList![index].add(result);
    }
    update();
  }

  Future<ResponseModel?> login(String? email, String password, String type) async {
    _isLoading = true;
    update();
    Response response = await authServiceInterface.login(email, password, type);
    ResponseModel? responseModel = await authServiceInterface.manageLogin(response, type);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForRegistration(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await authServiceInterface.pickImageFromGallery();
      } else {
        _pickedCover = await authServiceInterface.pickImageFromGallery();
      }
      update();
    }
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authServiceInterface.clearSharedData();
  }

  void saveUserCredentials(String number, String password, String type) {
    authServiceInterface.saveUserCredentials(number, password, type);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<bool> clearUserCredentials() async {
    return authServiceInterface.clearUserCredentials();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void initData() {
    _pickedFile = null;
  }

  String camelCaseToSentence(String text) {
    var result = text.replaceAll('_', " ");
    var finalResult = result[0].toUpperCase() + result.substring(1);
    return finalResult;
  }

  Future<void> toggleRestaurantClosedStatus() async {
    bool isSuccess = await authServiceInterface.toggleRestaurantClosedStatus();
    if (isSuccess) {
      Get.find<ProfileController>().getProfile();
    }
    update();
  }

  Future deleteVendor() async {
    _isLoading = true;
    update();
    bool isSuccess = await authServiceInterface.deleteVendor();
    _isLoading = false;
    if (isSuccess) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
    }
  }

  Future<void> registerRestaurant(Map<String, String> data, List<FilePickerResult> additionalDocuments, List<String> inputTypeList) async {
    _isLoading = true;
    update();

    List<FilePickerResult> tinFiles = [];

    for (FilePickerResult element in _tinFiles) {
      tinFiles.add(element);
    }

    List<MultipartDocument> multiPartsDocuments = [];
    multiPartsDocuments.addAll(authServiceInterface.prepareMultipartDocuments(inputTypeList, additionalDocuments));

    for (FilePickerResult result in tinFiles) {
      multiPartsDocuments.add(MultipartDocument('tin_certificate_image', result));
    }
    Response response = await authServiceInterface.registerRestaurant(data, _pickedLogo, _pickedCover, multiPartsDocuments);

    if(response.statusCode == 200){
      int? restaurantId = response.body['restaurant_id'];
      int? packageId = response.body['package_id'];

      if(packageId == null) {
        Get.find<BusinessController>().submitBusinessPlan(restaurantId: restaurantId!, packageId: null);
      }else{
        Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(restaurantId: restaurantId, packageId: packageId));
      }
    }

    _isLoading = false;
    update();
  }

  void storeStatusChange(double value, {bool willUpdate = true}){
    _storeStatus = value;
    if(willUpdate) {
      update();
    }
  }

  void showHidePass({bool willUpdate = true}){
    _showPassView = ! _showPassView;
    if(willUpdate) {
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void validPassCheck(String pass, {bool willUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(willUpdate) {
      update();
    }
  }

  void changeFirstTimeStatus() {
    _isFirstTime = !_isFirstTime;
  }

  void resetBusiness(){
    _businessIndex = (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    _isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? 0 : 1;
  }

  Future<void> getPackageList({bool isUpdate = true}) async {
    _packageModel = await authServiceInterface.getPackageList();
    if(isUpdate) {
      update();
    }
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }

  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  Future<bool> saveIsRestaurantRegistrationSharedPref(bool status) async {
    return await authServiceInterface.saveIsRestaurantRegistration(status);
  }

  bool getIsRestaurantRegistrationSharedPref() {
    return authServiceInterface.getIsRestaurantRegistration();
  }

  void changeOwnerType(int index, {bool isUpdate = true}){
    _ownerTypeIndex = index;
    if(isUpdate) {
      update();
    }
  }

  String getUserType() {
    return authServiceInterface.getUserType();
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.size > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          _tinFiles.add(result);
        }
      }
      update();
    }
  }

  void removeFile(int index) {
    _tinFiles.removeAt(index);
    update();
  }

  Future<void> setTinExpireDate(DateTime dateTime) async {
    _tinExpireDate = DateConverter.dateTimeForCoupon(dateTime);
    update();
  }

  void resetData(){
    _tinExpireDate = null;
    _tinFiles.clear();
    _storeMinTime = '--';
    _storeMaxTime = '--';
    _storeTimeUnit = 'minute';
  }

}