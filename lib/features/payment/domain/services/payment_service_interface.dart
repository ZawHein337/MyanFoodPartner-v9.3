import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/bank_info_body_model.dart';

abstract class PaymentServiceInterface {
  Future<dynamic> getWithdrawList();
  Future<dynamic> updateBankInfo(BankInfoBodyModel bankInfoBody);
  Future<dynamic> requestWithdraw(Map<String?, String> data);
  Future<dynamic> getWithdrawMethodList();
  Future<dynamic> makeCollectCashPayment(double amount, String paymentGatewayName);
  Future<dynamic> makeWalletAdjustment();
  Future<dynamic> getWalletPaymentList();
}