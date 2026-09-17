import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/assignable_food_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;
  CategoryRepository({required this.apiClient});

  @override
  Future<List<CategoryModel>?> getCategoryList({bool isRestaurantWise = false, String? search}) async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(isRestaurantWise ? '${AppConstants.restaurantWiseCategoryUri}?search=$search' : AppConstants.categoryUri);
    if(response.statusCode == 200) {
      categoryList = [];
      response.body.forEach((category) => categoryList!.add(CategoryModel.fromJson(category)));
    }
    return categoryList;
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID, {bool isRestaurantWise = false}) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${isRestaurantWise ? AppConstants.restaurantWiseSubCategoryUri : AppConstants.subCategoryUri}$parentID');
    if(response.statusCode == 200) {
      subCategoryList = [];
      response.body.forEach((subCategory) => subCategoryList!.add(CategoryModel.fromJson(subCategory)));
    }
    return subCategoryList;
  }

  @override
  Future<ProductModel?> getCategoryItemList({required String offset, required int id, required int isSubCategory}) async {
    ProductModel? productModel;
    Response response = await apiClient.getData('${AppConstants.categoryWiseProducts}?offset=$offset&limit=10&category_id=$id&sub_category=$isSubCategory');
    if(response.statusCode == 200) {
      productModel = ProductModel.fromJson(response.body);
    }
    return productModel;
  }

  @override
  Future<List<CategoryModel>?> getMyCategoryList({String search = ''}) async {
    List<CategoryModel>? list;
    final Response response = await apiClient.getData('${AppConstants.categoryListUri}?search=$search');
    if (response.statusCode == 200) {
      list = [];
      for (final item in response.body) {
        list.add(CategoryModel.fromJson(item));
      }
    }
    return list;
  }

  @override
  Future<CategoryDetailsModel?> getCategoryDetails(int id) async {
    final Response response = await apiClient.getData('${AppConstants.categoryDetailsUri}/$id');
    if (response.statusCode == 200) {
      return CategoryDetailsModel.fromJson(response.body);
    }
    return null;
  }

  @override
  Future<bool> deleteStoreCategory(int id) async {
    final Response response = await apiClient.deleteData('${AppConstants.deleteCategoryUri}?id=$id',);
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateCategoryStatus(int id, int status) async {
    final Response response = await apiClient.postData(AppConstants.statusCategoryUri, {'id': id, 'status': status});
    return response.statusCode == 200;
  }

  @override
  Future<ProductModel?> getStoreCategoryItems(int id, {required String offset}) async {
    final Response response = await apiClient.getData('${AppConstants.storeCategoryItemsUri}/$id?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.body);
    }
    return null;
  }

  @override
  Future<bool> addStoreCategory(List<Translation> translations, String priority, XFile? image) async {
    final Map<String, String> fields = {
      'translations': jsonEncode(translations),
      'priority': priority,
    };
    final Response response = await apiClient.postMultipartData(
      AppConstants.createCategoryUri, fields, [MultipartBody('image', image)], [],
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateStoreCategory(int id, List<Translation> translations, String priority, XFile? image) async {
    final Map<String, String> fields = {
      'translations': jsonEncode(translations),
      'priority': priority,
      'id': id.toString(),
    };
    final Response response = await apiClient.postMultipartData(
      AppConstants.updateCategoryUri, fields, [MultipartBody('image', image)], [],
    );
    return response.statusCode == 200;
  }

  @override
  Future<AssignableFoodModel?> getAssignableFoods(int categoryId, {required String offset, String search = ''}) async {
    final Response response = await apiClient.getData('${AppConstants.assignFoodToCategoryUri}/$categoryId?offset=$offset&limit=25&search=${Uri.encodeQueryComponent(search)}');
    if (response.statusCode == 200) {
      return AssignableFoodModel.fromJson(response.body);
    }
    return null;
  }

  @override
  Future<bool> assignFoodsToCategory(int categoryId, List<int> foodIds) async {
    final Response response = await apiClient.postData(AppConstants.assignFoodsUri, {
      'category_id': categoryId,
      'food_ids': foodIds,
    });
    return response.statusCode == 200;
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
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getList() {
    throw UnimplementedError();
  }

}
