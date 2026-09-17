import 'dart:async';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileServiceInterface {
  Future<dynamic> getProfileInfo();
  Future<dynamic> deleteVendor();
  void setNotificationActive(bool isActive);
  bool isNotificationActive();
  String getUserToken();
  Future<bool> updateProfile(ProfileModel userInfoModel, XFile? data, String token);
}