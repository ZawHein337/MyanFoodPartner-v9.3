import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_report_model.dart' as report;

class DisbursementService implements DisbursementServiceInterface {
  final DisbursementRepositoryInterface disbursementRepositoryInterface;
  DisbursementService({required this.disbursementRepositoryInterface});

  @override
  Future<ResponseModel?> addWithdraw(Map<String?, String> data) async {
    return await disbursementRepositoryInterface.addWithdraw(data);
  }

  @override
  Future<disburse.DisbursementMethodBody?> getDisbursementMethodList() async {
    return await disbursementRepositoryInterface.getList();
  }

  @override
  Future<ResponseModel?> makeDefaultMethod(Map<String?, String> data) async {
    return await disbursementRepositoryInterface.makeDefaultMethod(data);
  }

  @override
  Future<ResponseModel?> deleteMethod(int id) async {
    return await disbursementRepositoryInterface.delete(id: id);
  }

  @override
  Future<report.DisbursementReportModel?> getDisbursementReport(int offset) async {
    return await disbursementRepositoryInterface.getDisbursementReport(offset);
  }

}