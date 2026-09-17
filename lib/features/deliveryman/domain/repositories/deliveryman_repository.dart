import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_list_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliverymanRepository implements DeliverymanRepositoryInterface {
  final ApiClient apiClient;
  DeliverymanRepository({required this.apiClient});

  @override
  Future<List<DeliveryManModel>?> getList() async{
    List<DeliveryManModel>? deliveryManList;
    Response response = await apiClient.getData(AppConstants.dmListUri);
    if(response.statusCode == 200) {
      deliveryManList = [];
      response.body.forEach((deliveryMan) => deliveryManList!.add(DeliveryManModel.fromJson(deliveryMan)));
    }
    return deliveryManList;
  }

  @override
  Future<bool> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd) async {
    List<MultipartBody> images = [];
    if(GetPlatform.isMobile && image != null) {
      images.add(MultipartBody('image', image));
    }
    if(GetPlatform.isMobile && identities.isNotEmpty) {
      for (var identity in identities) {
        images.add(MultipartBody('identity_image[]', identity));
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': deliveryMan.fName!, 'l_name': deliveryMan.lName!, 'email': deliveryMan.email!, 'password': pass,
      'phone': deliveryMan.phone!, 'identity_type': deliveryMan.identityType!, 'identity_number': deliveryMan.identityNumber!,
    });
    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.addDmUri : '${AppConstants.updateDmUri}${deliveryMan.id}', fields, images, []);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete({int? id}) async {
    Response response = await apiClient.postData(AppConstants.deleteDmUri, {'_method': 'delete', 'delivery_man_id': id});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateDeliveryManStatus(int? deliveryManID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateDmStatusUri}?delivery_man_id=$deliveryManID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<List<ReviewModel>?> getDeliveryManReviews(int? deliveryManID) async {
    List<ReviewModel>? dmReviewList;
    Response response = await apiClient.getData('${AppConstants.dmReviewUri}?delivery_man_id=$deliveryManID');
    if(response.statusCode == 200) {
      dmReviewList = [];
      response.body['reviews'].forEach((review) => dmReviewList!.add(ReviewModel.fromJson(review)));
    }
    return dmReviewList;
  }

  @override
  Future<List<DeliveryManListModel>?> getAvailableDeliveryManList() async {
    List<DeliveryManListModel>? availableDeliveryManList;
    Response response = await apiClient.getData(AppConstants.deliverymanListUri);
    if(response.statusCode == 200) {
      availableDeliveryManList = [];
      response.body.forEach((deliveryMan) {
        availableDeliveryManList!.add(DeliveryManListModel.fromJson(deliveryMan));
      });
    }
    return availableDeliveryManList;
  }

  @override
  Future<bool> assignDeliveryMan(int? deliveryManId, int? orderId) async {
    Response response = await apiClient.getData('${AppConstants.assignDeliverymanUri}?delivery_man_id=$deliveryManId&order_id=$orderId');
    return (response.statusCode == 200);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}