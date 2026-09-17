import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/earning_report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/tax_report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class ReportRepository implements ReportRepositoryInterface {
  final ApiClient apiClient;
  ReportRepository({required this.apiClient});

  @override
  Future<TransactionReportModel?> getTransactionReportList({required int offset, required String? from, required String? to}) async {
    TransactionReportModel? transactionReportModel;
    Response response = await apiClient.getData('${AppConstants.transactionReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      transactionReportModel = TransactionReportModel.fromJson(response.body);
    }
    return transactionReportModel;
  }

  @override
  Future<EarningReportModel?> getEarningReport({required int offset, required int restaurantId, required String? from, required String? to, required String type}) async {
    EarningReportModel? earningReportModel;
    Response response = await apiClient.getData('${AppConstants.earningReportUri}?restaurant_id=$restaurantId&offset=$offset&limit=10${(from != null && to != null && from.isNotEmpty && to.isNotEmpty) ? '&filter=custom&from=$from&to=$to' : ''}&type=$type');
    if(response.statusCode == 200) {
      earningReportModel = EarningReportModel.fromJson(response.body);
    }
    return earningReportModel;
  }

  @override
  Future<OrderReportModel?> getOrderReportList({required int offset, required String? from, required String? to}) async {
    OrderReportModel? orderReportModel;
    Response response = await apiClient.getData('${AppConstants.orderReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      orderReportModel = OrderReportModel.fromJson(response.body);
    }
    return orderReportModel;
  }

  @override
  Future<OrderReportModel?> getCampaignReportList({required int offset, required String? from, required String? to}) async {
    OrderReportModel? campaignReportModel;
    Response response = await apiClient.getData('${AppConstants.campaignReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      campaignReportModel = OrderReportModel.fromJson(response.body);
    }
    return campaignReportModel;
  }

  @override
  Future<FoodReportModel?> getFoodReportList({required int offset, required String? from, required String? to}) async {
    FoodReportModel? foodReportModel;
    Response response = await apiClient.getData('${AppConstants.foodReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
    if(response.statusCode == 200) {
      foodReportModel = FoodReportModel.fromJson(response.body);
    }
    return foodReportModel;
  }

  @override
  Future<Response> getTransactionReportStatement({required int orderId}) async {
    Response response = await apiClient.getData('${AppConstants.getTransactionStatement}?order_id=$orderId');
    return response;
  }

  @override
  Future<TaxReportModel?> getTaxReport({required int offset, required String? from, required String? to}) async {
    TaxReportModel? taxReportModel;
    Response response = await apiClient.getData('${AppConstants.getTaxReportUri}?limit=10&offset=$offset&from=$from&to=$to');
    if(response.statusCode == 200){
      taxReportModel = TaxReportModel.fromJson(response.body);
    }
    return taxReportModel;
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