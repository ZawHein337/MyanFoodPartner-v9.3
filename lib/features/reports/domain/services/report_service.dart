import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/earning_report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/tax_report_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/services/report_service_interface.dart';

class ReportService implements ReportServiceInterface {
  final ReportRepositoryInterface reportRepositoryInterface;
  ReportService({required this.reportRepositoryInterface});

  @override
  Future<TransactionReportModel?> getTransactionReportList({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getTransactionReportList(offset: offset, from: from, to: to);
  }

  @override
  Future<EarningReportModel?> getEarningReport({required int offset, required int restaurantId, required String? from, required String? to, required String type}) async {
    return await reportRepositoryInterface.getEarningReport(offset: offset, restaurantId: restaurantId, from: from, to: to, type: type);
  }

  @override
  Future<OrderReportModel?> getOrderReportList({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getOrderReportList(offset: offset, from: from, to: to);
  }

  @override
  Future<OrderReportModel?> getCampaignReportList({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getCampaignReportList(offset: offset, from: from, to: to);
  }

  @override
  Future<FoodReportModel?> getFoodReportList({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getFoodReportList(offset: offset, from: from, to: to);
  }

  @override
  Future<Response> getTransactionReportStatement({required int orderId}) async {
    return await reportRepositoryInterface.getTransactionReportStatement(orderId: orderId);
  }

  @override
  Future<TaxReportModel?> getTaxReport({required int offset, required String? from, required String? to}) async {
    return await reportRepositoryInterface.getTaxReport(offset: offset, from: from, to: to);
  }

}