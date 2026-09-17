import 'package:file_picker/file_picker.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/auth_service_interface.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/screens/subscription_payment_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future<Response> login(String? email, String password, String type) async {
    return await authRepoInterface.login(email, password, type);
  }

  @override
  Future<bool> saveUserToken(String token, String zoneTopic, String type) async {
    return await authRepoInterface.saveUserToken(token, zoneTopic, type);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    return await authRepoInterface.updateToken(notificationDeviceToken: notificationDeviceToken);
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepoInterface.clearSharedData();
  }

  @override
  Future<void> saveUserCredentials(String number, String password, String type) async {
    return await authRepoInterface.saveUserCredentials(number, password, type);
  }

  @override
  String getUserNumber() {
    return authRepoInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserCredentials() async {
    return await authRepoInterface.clearUserCredentials();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  void setNotificationActive(bool isActive) {
    authRepoInterface.setNotificationActive(isActive);
  }

  @override
  Future<bool> toggleRestaurantClosedStatus() async {
    return await authRepoInterface.toggleRestaurantClosedStatus();
  }

  @override
  Future<bool> deleteVendor() async {
    return await authRepoInterface.delete();
  }

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument) async {
    return await authRepoInterface.registerRestaurant(data, logo, cover, additionalDocument);
  }

  @override
  Future<FilePickerResult?> picFile(MediaData mediaData) async{
    List<String> permission = [];
    if(mediaData.image == 1) {
      permission.add('jpg');
    }
    if(mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if(mediaData.docs == 1) {
      permission.add('doc');
    }

    FilePickerResult? result;

    result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: permission,
      allowMultiple: false,
    );
    if(result != null && result.files.isNotEmpty) {
      if(result.files.single.size > 2000000) {
        result = null;
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return result;
      }
    }
    return result;
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final extension = pickedImage.name.split('.').last.toLowerCase();
      const supportedFormats = ['jpg', 'jpeg', 'png'];

      if (!supportedFormats.contains(extension)) {
        showCustomSnackBar('only_jpg_jpeg_png_formats_are_supported'.tr);
        return null;
      }

      int size = await pickedImage.length();
      if (size > 1000000) {
        showCustomSnackBar('please_upload_lower_size_file'.tr);
        return null;
      }
    }

    return pickedImage;
  }

  @override
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments){
    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for(String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for(FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }
    return multiPartsDocuments;
  }

  @override
  String? getSubscriptionType (Response response) {
    String? subscriptionType;
    if (response.statusCode == 200 && response.body['subscribed'] != null) {
      subscriptionType = response.body['subscribed']['type'];
    }
    return subscriptionType;
  }

  @override
  String? getExpiredToken (Response response, int? subscription) {
    String? expiredToken;
    if(response.statusCode == 205 && subscription == 1) {
      expiredToken = response.body['token'];
    }
    return expiredToken;
  }

  @override
  ProfileModel? getProfileModel(Response response, int? subscription) {
    ProfileModel? profileModel;
    if(response.statusCode == 205 && subscription == 1) {
      profileModel = ProfileModel(
        restaurants: [Restaurant(id: int.parse(response.body['restaurant_id'].toString()))],
        balance: response.body['balance']?.toDouble(),
        subscription: Subscription.fromJson(response.body['subscription']),
        subscriptionOtherData: SubscriptionOtherData.fromJson(response.body['subscription_other_data']),
      );
    }
    return profileModel;
  }

  @override
  Future<bool> saveIsRestaurantRegistration(bool status) async {
    return await authRepoInterface.saveIsRestaurantRegistration(status);
  }

  @override
  bool getIsRestaurantRegistration() {
    return authRepoInterface.getIsRestaurantRegistration();
  }

  @override
  Future<PackageModel?> getPackageList() async {
    return await authRepoInterface.getList();
  }

  @override
  Future<ResponseModel?> manageLogin(Response response, String type) async {
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if(response.body['subscribed'] != null){
        int? restaurantId = response.body['subscribed']['restaurant_id'];
        int? packageId = response.body['subscribed']['package_id'];

        if(packageId == null) {

          saveUserToken(response.body['subscribed']['token'], response.body['subscribed']['zone_wise_topic'], type);
          await updateToken();
          await Get.find<ProfileController>().getProfile();

          Get.toNamed(RouteHelper.getMySubscriptionRoute(fromNotification: true));
        } else {
          Get.to(()=> SubscriptionPaymentScreen(restaurantId: restaurantId!, packageId: packageId));
          responseModel = ResponseModel(false, 'please_select_payment_method'.tr);
        }
      }else{
        saveUserToken(response.body['token'], response.body['zone_wise_topic'], type);
        await updateToken();
        Get.find<ProfileController>().getProfile();
        responseModel = ResponseModel(true, 'successful');
      }
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  String getUserType() {
    return authRepoInterface.getUserType();
  }

}