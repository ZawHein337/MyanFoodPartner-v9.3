abstract class DisbursementServiceInterface {
  Future<dynamic> addWithdraw(Map<String?, String> data);
  Future<dynamic> getDisbursementMethodList();
  Future<dynamic> makeDefaultMethod(Map<String?, String> data);
  Future<dynamic> deleteMethod(int id);
  Future<dynamic> getDisbursementReport(int offset);
}