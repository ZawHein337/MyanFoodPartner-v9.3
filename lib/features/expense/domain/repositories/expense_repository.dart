import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/models/expense_model.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/repositories/expense_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class ExpenseRepository implements ExpenseRepositoryInterface {
  final ApiClient apiClient;
  ExpenseRepository({required this.apiClient});

  @override
  Future<ExpenseBodyModel?> getExpenseList({required int offset, required int? restaurantId, required String? from, required String? to,  required String? searchText}) async {
    ExpenseBodyModel? expenseModel;
    Response response = await apiClient.getData('${AppConstants.expanseListUri}?limit=10&offset=$offset&restaurant_id=$restaurantId&from=$from&to=$to&search=${searchText ?? ''}');
    if(response.statusCode == 200){
      expenseModel = ExpenseBodyModel.fromJson(response.body);
    }
    return expenseModel;
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
  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}