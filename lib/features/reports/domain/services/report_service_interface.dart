import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/tax_report_model.dart';

abstract class ReportServiceInterface {
  Future<dynamic> getTransactionReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getEarningReport({required int offset, required int restaurantId, required String? from, required String? to, required String type});
  Future<dynamic> getOrderReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getCampaignReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getFoodReportList({required int offset, required String? from, required String? to});
  Future<Response> getTransactionReportStatement({required int orderId});
  Future<TaxReportModel?> getTaxReport({required int offset, required String? from, required String? to});
}