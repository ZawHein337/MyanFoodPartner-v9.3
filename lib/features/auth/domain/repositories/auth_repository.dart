import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> login(String? email, String password, String type) async {
    return await apiClient.postData(AppConstants.loginUri, {"email": email, "password": password, 'vendor_type': type}, handleError: false);
  }

  @override
  Future<bool> saveUserToken(String token, String zoneTopic, String type) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode), type);
    sharedPreferences.setString(AppConstants.zoneTopic, zoneTopic);
    sharedPreferences.setString(AppConstants.type, type);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    String? deviceToken;
    if(notificationDeviceToken.isEmpty){
      if (GetPlatform.isIOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = await _saveDeviceToken();
        }
      }else {
        deviceToken = await _saveDeviceToken();
      }
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.maintenanceModeTopic);
      }
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": _getUserToken(), "fcm_token": notificationDeviceToken.isNotEmpty ? notificationDeviceToken : deviceToken}, handleError: false);
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if(!GetPlatform.isWeb) {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    }
    return deviceToken;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "token": _getUserToken(), "fcm_token": '@'}, handleError: false);
      FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
    }
    await sharedPreferences.remove(AppConstants.token);
    await sharedPreferences.remove(AppConstants.userAddress);
    await sharedPreferences.remove(AppConstants.type);
    return true;
  }

  @override
  Future<void> saveUserCredentials(String number, String password, String type) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.userType, type);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  Future<bool> clearUserCredentials() async {
    await sharedPreferences.remove(AppConstants.userType);
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        updateToken(notificationDeviceToken: '@');
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.zoneTopic)!);
      }
    }
    sharedPreferences.setBool(AppConstants.notification, isActive);
  }

  @override
  Future<bool> toggleRestaurantClosedStatus() async {
    Response response = await apiClient.postData(AppConstants.updateRestaurantStatusUri, {});
    return (response.statusCode == 200);
  }

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument) async {
    return apiClient.postMultipartData(
      AppConstants.restaurantRegisterUri, data, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)], additionalDocument,
    );
  }

  @override
  Future<bool> delete({int? id}) {
    return _deleteVendor();
  }

  Future<bool> _deleteVendor() async {
    Response response = await apiClient.postData(AppConstants.vendorRemove, {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> saveIsRestaurantRegistration(bool status) async {
    return await sharedPreferences.setBool(AppConstants.isRestaurantRegister, status);
  }

  @override
  bool getIsRestaurantRegistration() {
    return sharedPreferences.getBool(AppConstants.isRestaurantRegister) ?? false;
  }

  @override
  Future<PackageModel?> getList({int? offset}) async {
    PackageModel? packageModel;
    Response response = await apiClient.getData(AppConstants.restaurantPackagesUri);
    if(response.statusCode == 200) {
      packageModel = PackageModel.fromJson(response.body);
    }
    return packageModel;
  }

  @override
  String getUserType() {
    return sharedPreferences.getString(AppConstants.type) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}