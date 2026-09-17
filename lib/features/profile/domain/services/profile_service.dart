import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/services/profile_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService implements ProfileServiceInterface {
  final ProfileRepositoryInterface profileRepositoryInterface;
  ProfileService({required this.profileRepositoryInterface});

  @override
  Future<ProfileModel?> getProfileInfo() async {
    return await profileRepositoryInterface.getProfileInfo();
  }

  @override
  Future<ResponseModel> deleteVendor() async {
    return await profileRepositoryInterface.delete();
  }

  @override
  bool isNotificationActive() {
    return profileRepositoryInterface.isNotificationActive();
  }

  @override
  void setNotificationActive(bool isActive) {
    profileRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  String getUserToken() {
    return profileRepositoryInterface.getUserToken();
  }

  @override
  Future<bool> updateProfile(ProfileModel userInfoModel, XFile? data, String token) {
    return profileRepositoryInterface.updateProfile(userInfoModel, data, token);
  }

}