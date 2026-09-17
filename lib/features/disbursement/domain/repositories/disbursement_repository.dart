import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_report_model.dart' as report;
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class DisbursementRepository implements DisbursementRepositoryInterface {
  final ApiClient apiClient;
  DisbursementRepository({required this.apiClient});

  @override
  Future<ResponseModel?> addWithdraw(Map<String?, String> data) async {
    ResponseModel? responseModel;
    Response response = await apiClient.postData(AppConstants.addWithdrawMethodUri, data);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, 'add_successfully'.tr);
    }
    return responseModel;
  }

  @override
  Future<disburse.DisbursementMethodBody?> getList() async {
    disburse.DisbursementMethodBody? disbursementMethodBody;
    Response response = await apiClient.getData('${AppConstants.disbursementMethodListUri}?limit=10&offset=1');
    if(response.statusCode == 200) {
      disbursementMethodBody = disburse.DisbursementMethodBody.fromJson(response.body);
    }
    return disbursementMethodBody;
  }

  @override
  Future<ResponseModel?> makeDefaultMethod(Map<String?, String> data) async {
    ResponseModel? responseModel;
    Response response = await apiClient.postData(AppConstants.makeDefaultDisbursementMethodUri, data);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, 'set_default_method_successful'.tr);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel?> delete({int? id}) async {
    ResponseModel? responseModel;
    Response response = await apiClient.postData(AppConstants.deleteDisbursementMethodUri, {'_method': 'delete', 'id': id});
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, 'method_delete_successfully'.tr);
    }
    return responseModel;
  }

  @override
  Future<report.DisbursementReportModel?> getDisbursementReport(int offset) async {
    report.DisbursementReportModel? disbursementReportModel;
    Response response = await apiClient.getData('${AppConstants.getDisbursementReportUri}?limit=10&offset=$offset');
    if(response.statusCode == 200) {
      disbursementReportModel = report.DisbursementReportModel.fromJson(response.body);
    }
    return disbursementReportModel;
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