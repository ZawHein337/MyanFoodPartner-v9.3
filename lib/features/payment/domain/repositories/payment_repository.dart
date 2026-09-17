import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/bank_info_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/wallet_payment_model.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/withdraw_model.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepository implements PaymentRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PaymentRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<WithdrawModel>?> getList() async {
    List<WithdrawModel>? withdrawList = [];
    Response response = await apiClient.getData(AppConstants.withdrawListUri);
    if (response.statusCode == 200) {
      response.body.forEach((withdraw) {
        WithdrawModel withdrawModel = WithdrawModel.fromJson(withdraw);
        withdrawList.add(withdrawModel);
      });
    }
    return withdrawList;
  }

  @override
  Future<bool> updateBankInfo(BankInfoBodyModel bankInfoBody) async {
    Response response = await apiClient.putData(AppConstants.updateBankInfoUri, bankInfoBody.toJson());
    return (response.statusCode == 200);
  }

  @override
  Future<bool> requestWithdraw(Map<String?, String> data) async {
    Response response = await apiClient.postData(AppConstants.withdrawRequestUri, data);
    return (response.statusCode == 200);
  }

  @override
  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    List<WidthDrawMethodModel>? widthDrawMethodList;
    Response response = await apiClient.getData(AppConstants.withdrawRequestMethodUri);
    if (response.statusCode == 200) {
      widthDrawMethodList = [];
      response.body.forEach((method) {
        WidthDrawMethodModel withdrawMethod = WidthDrawMethodModel.fromJson(method);
        widthDrawMethodList!.add(withdrawMethod);
      });
    }
    return widthDrawMethodList;
  }

  @override
  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.makeCollectedCashPaymentUri,
      {
        "amount": amount,
        "payment_gateway": paymentGatewayName,
        "callback": RouteHelper.success,
        "token": _getUserToken(),
      }
    );
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {
        // html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(null, redirectUrl, null, false, null));
      }
      responseModel = ResponseModel(true, response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<bool> makeWalletAdjustment() async {
    Response response = await apiClient.postData(AppConstants.makeWalletAdjustmentUri, {'token': _getUserToken()});
    return (response.statusCode == 200);
  }

  @override
  Future<List<Transactions>?> getWalletPaymentList() async {
    List<Transactions>? transactions;
    Response response = await apiClient.getData(AppConstants.walletPaymentListUri);
    if (response.statusCode == 200) {
      transactions = [];
      WalletPaymentModel walletPaymentModel = WalletPaymentModel.fromJson(response.body);
      transactions.addAll(walletPaymentModel.transactions!);
    }
    return transactions;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
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