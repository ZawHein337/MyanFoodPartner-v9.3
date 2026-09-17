import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';

abstract class AuthServiceInterface {
  Future<dynamic> login(String? email, String password, String type);
  Future<bool> saveUserToken(String token, String zoneTopic, String type);
  Future<dynamic> updateToken({String notificationDeviceToken = ''});
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserCredentials(String number, String password, String type);
  String getUserNumber();
  String getUserPassword();
  Future<bool> clearUserCredentials();
  String getUserToken();
  void setNotificationActive(bool isActive);
  Future<dynamic> toggleRestaurantClosedStatus();
  Future<dynamic> deleteVendor();
  Future<dynamic> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
  Future<FilePickerResult?> picFile(MediaData mediaData);
  Future<XFile?> pickImageFromGallery();
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments);
  Future<ResponseModel?> manageLogin(Response response, String type);
  String? getSubscriptionType (Response response);
  String? getExpiredToken (Response response, int? subscription);
  ProfileModel? getProfileModel(Response response, int? subscription);
  Future<bool> saveIsRestaurantRegistration(bool status);
  bool getIsRestaurantRegistration();
  Future<PackageModel?> getPackageList();
  String getUserType();
}