import 'package:stackfood_multivendor_restaurant/api/api_checker.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/repositories/happy_hour_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class HappyHourRepository implements HappyHourRepositoryInterface {
  final ApiClient apiClient;
  HappyHourRepository({required this.apiClient});

  @override
  Future<HappyHourBodyModel?> getHappyHourList({required int offset, required String type, String? searchText, int limit = 10}) async {
    HappyHourBodyModel? happyHourBody;
    Response response = await apiClient.getData('${AppConstants.happyHourListUri}?limit=$limit&offset=$offset&type=$type&search=${searchText ?? ''}');
    if(response.statusCode == 200) {
      happyHourBody = HappyHourBodyModel.fromJson(response.body);
    }
    return happyHourBody;
  }

  @override
  Future<({HappyHourModel? happyHour, bool isNotFound})> getHappyHourDetails(int id) async {
    Response response = await apiClient.getData('${AppConstants.happyHourDetailsUri}/$id', handleError: false);
    if(response.statusCode == 200) {
      return (happyHour: HappyHourModel.fromJson(response.body), isNotFound: false);
    }
    if(response.statusCode == 404) {
      return (happyHour: null, isNotFound: true);
    }
    ApiChecker.checkApi(response);
    return (happyHour: null, isNotFound: false);
  }

  @override
  Future<ResponseModel> joinHappyHour(int id) async {
    Response response = await apiClient.postData('${AppConstants.happyHourJoinUri}/$id', {}, handleError: false);
    return _toResponseModel(response);
  }

  @override
  Future<ResponseModel> respondToHappyHour(int id, String status, {String? rejectionReason}) async {
    Response response = await apiClient.postData(
      '${AppConstants.happyHourRespondUri}/$id',
      {'status': status, if(rejectionReason != null && rejectionReason.isNotEmpty) 'rejection_reason': rejectionReason},
      handleError: false,
    );
    return _toResponseModel(response);
  }

  @override
  Future<ResponseModel> leaveHappyHour(int id) async {
    Response response = await apiClient.deleteData('${AppConstants.happyHourLeaveUri}/$id', handleError: false);
    return _toResponseModel(response);
  }

  ResponseModel _toResponseModel(Response response) {
    if(response.statusCode == 200) {
      return ResponseModel(true, response.body['message']);
    }
    if(response.statusCode == 404){
      return ResponseModel(false, 'happy_hour_no_longer_available'.tr);
    }
    return ResponseModel(false, response.statusText);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}
