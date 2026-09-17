import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/employed_permission_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/services/profile_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface}){
    _notification = profileServiceInterface.isNotificationActive();
  }

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  bool _notification = true;
  bool get notification => _notification;

  bool _backgroundNotification = true;
  bool get backgroundNotification => _backgroundNotification;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProfileGetLoading = false;
  bool get isProfileGetLoading => _isProfileGetLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  bool _trialWidgetNotShow = false;
  bool get trialWidgetNotShow => _trialWidgetNotShow;

  ModulePermissionModel? _modulePermission;
  ModulePermissionModel? get modulePermission => _modulePermission;

  void setTrialWidgetNotShow(bool value) {
    _trialWidgetNotShow = value;
    update();
  }

  void setProfile(ProfileModel? proModel) {
    _profileModel = proModel;
  }

  Future<ProfileModel?> getProfile({bool willLoad = false}) async {
    if(willLoad) {
      _isProfileGetLoading = true;
    }
    ProfileModel? profileModel = await profileServiceInterface.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
      _allowPermission(_profileModel?.roles);
    }
    if(willLoad) {
      _isProfileGetLoading = false;
    }
    update();
    return profileModel;
  }

  Future<void> deleteVendor() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.deleteVendor();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    profileServiceInterface.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void setBackgroundNotificationActive(bool isActive) {
    _backgroundNotification = isActive;
    update();
  }

  void initData() {
    _pickedFile = null;
  }

  String getUserToken() {
    return profileServiceInterface.getUserToken();
  }

  Future<bool> updateUserInfo(ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    bool success = await profileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    bool isSuccess;
    if (success) {
      await getProfile();
      Get.back();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> trialWidgetShow({required String route}) async {
    const Set<String> routesToHideWidget = {
      RouteHelper.mySubscription, 'show-dialog', RouteHelper.success, RouteHelper.payment, RouteHelper.signIn,
    };
    _trialWidgetNotShow = routesToHideWidget.contains(route);
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
    return _trialWidgetNotShow;
  }

  void _allowPermission(List<String>? roles) {
    debugPrint('---permission--->>$roles');
    if (roles != null && roles.isNotEmpty) {
      List<String> module = roles;
      _modulePermission = ModulePermissionModel(
        dashboard: module.contains('dashboard'),
        chat: module.contains('chat'),
        pos: module.contains('pos'),
        newAds: module.contains('new_ads'),
        adsList: module.contains('ads_list'),
        campaign: module.contains('campaign'),
        coupon: module.contains('coupon'),
        food: module.contains('food'),
        category: module.contains('category'),
        addon: module.contains('addon'),
        reviews: module.contains('reviews'),
        regularOrder: module.contains('regular_order'),
        subscriptionOrder: module.contains('subscription_order'),
        myWallet: module.contains('my_wallet'),
        walletMethod: module.contains('wallet_method'),
        roleManagement: module.contains('role_management'),
        allEmployee: module.contains('all_employee'),
        expenseReport: module.contains('expense_report'),
        transaction: module.contains('transaction'),
        disbursement: module.contains('disbursement'),
        orderReport: module.contains('order_report'),
        foodReport: module.contains('food_report'),
        taxReport: module.contains('tax_report'),
        myRestaurant: module.contains('my_restaurant'),
        restaurantConfig: module.contains('restaurant_config'),
        businessPlan: module.contains('business_plan'),
        myQrCode: module.contains('my_qr_code'),
        notificationSetup: module.contains('notification_setup'),
      );
    } else {
      _modulePermission = ModulePermissionModel(
        dashboard: true, chat: true, pos: true, newAds: true, adsList: true, campaign: true, coupon: true, food: true, category: true,
        addon: true, reviews: true, regularOrder: true, subscriptionOrder: true, myWallet: true, walletMethod: true, roleManagement: true, allEmployee: true,
        expenseReport: true, transaction: true, disbursement: true, orderReport: true, foodReport: true, taxReport: true, myRestaurant: true, restaurantConfig: true,
        businessPlan: true, myQrCode: true, notificationSetup: true,
      );
    }
  }

}