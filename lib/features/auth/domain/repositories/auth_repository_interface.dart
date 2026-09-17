import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface {
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
  Future<dynamic> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
  Future<bool> saveIsRestaurantRegistration(bool status);
  bool getIsRestaurantRegistration();
  String getUserType();
}