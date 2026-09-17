import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/models/bogo_offer_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/repositories/bogo_offer_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class BogoOfferRepository implements BogoOfferRepositoryInterface {
  final ApiClient apiClient;
  BogoOfferRepository({required this.apiClient});

  @override
  Future<BogoOfferModel?> getBogoOfferList(String offset, {String? search, String? type}) async {
    BogoOfferModel? bogoOfferModel;
    Response response = await apiClient.getData(
      '${AppConstants.bogoOfferListUri}?offset=$offset&limit=25&type=${type ?? 'all'}&search=${search ?? ''}',
    );
    if(response.statusCode == 200) {
      bogoOfferModel = BogoOfferModel.fromJson(response.body);
    }
    return bogoOfferModel;
  }

  @override
  Future<BogoOffer?> getBogoOfferDetails(int offerId) async {
    BogoOffer? bogoOffer;
    Response response = await apiClient.getData('${AppConstants.bogoOfferDetailsUri}$offerId');
    if(response.statusCode == 200) {
      bogoOffer = BogoOffer.fromJson(response.body);
    }
    return bogoOffer;
  }

  @override
  Future<BogoOfferJoinResponseModel?> joinBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems) async {
    BogoOfferJoinResponseModel? bogoOfferJoinResponseModel;
    Response response = await apiClient.postData('${AppConstants.bogoOfferJoinUri}$offerId', {
      'buy_items': buyItems,
      'get_items': getItems,
    });
    if(response.statusCode == 200) {
      bogoOfferJoinResponseModel = BogoOfferJoinResponseModel.fromJson(response.body);
    }
    return bogoOfferJoinResponseModel;
  }

  @override
  Future<BogoOfferJoinResponseModel?> resubmitBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems) async {
    BogoOfferJoinResponseModel? bogoOfferJoinResponseModel;
    Response response = await apiClient.postData('${AppConstants.bogoOfferResubmitUri}$offerId', {
      'buy_items': buyItems,
      'get_items': getItems,
    });
    if(response.statusCode == 200) {
      bogoOfferJoinResponseModel = BogoOfferJoinResponseModel.fromJson(response.body);
    }
    return bogoOfferJoinResponseModel;
  }

  @override
  Future<ResponseModel?> leaveBogoOffer(int offerId) async {
    ResponseModel? responseModel;
    Response response = await apiClient.deleteData('${AppConstants.bogoOfferLeaveUri}$offerId');
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel?> respondToBogoOffer(int offerId, {required String status, String? rejectionReason}) async {
    ResponseModel? responseModel;
    Response response = await apiClient.postData('${AppConstants.bogoOfferRespondUri}$offerId', {
      'status': status,
      if(rejectionReason != null && rejectionReason.isNotEmpty) 'rejection_reason': rejectionReason,
    });
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }
    return responseModel;
  }

  @override
  Future<List<Product>?> getBogoOfferFoods({String? search}) async {
    List<Product>? foods;
    Response response = await apiClient.getData(
      '${AppConstants.bogoOfferFoodsUri}${search != null && search.isNotEmpty ? '?search=$search' : ''}',
    );
    if(response.statusCode == 200) {
      foods = [];
      response.body['foods'].forEach((food) {
        if(food['is_available'] != false) {
          food['restaurant_category_name'] = food['category_name'];
          foods!.add(Product.fromJson(food));
        }
      });
    }
    return foods;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
