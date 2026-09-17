import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/assignable_food_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/categoty_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface categoryRepositoryInterface;
  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<List<CategoryModel>?> getCategoryList({bool isRestaurantWise = false, String? search}) async {
    return await categoryRepositoryInterface.getCategoryList(isRestaurantWise: isRestaurantWise, search: search);
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID, {bool isRestaurantWise = false}) async {
    return await categoryRepositoryInterface.getSubCategoryList(parentID, isRestaurantWise: isRestaurantWise);
  }

  @override
  Future<ProductModel?> getCategoryItemList({required String offset, required int id, required int isSubCategory}) async {
    return await categoryRepositoryInterface.getCategoryItemList(offset: offset, id: id, isSubCategory: isSubCategory);
  }

  @override
  Future<List<CategoryModel>?> getMyCategoryList({String search = ''}) async {
    return await categoryRepositoryInterface.getMyCategoryList(search: search);
  }

  @override
  Future<CategoryDetailsModel?> getCategoryDetails(int id) async {
    return await categoryRepositoryInterface.getCategoryDetails(id);
  }

  @override
  Future<bool> addStoreCategory(List<Translation> translations, String priority, XFile? image) async {
    return await categoryRepositoryInterface.addStoreCategory(translations, priority, image);
  }

  @override
  Future<bool> updateStoreCategory(int id, List<Translation> translations, String priority, XFile? image) async {
    return await categoryRepositoryInterface.updateStoreCategory(id, translations, priority, image);
  }

  @override
  Future<bool> deleteStoreCategory(int id) async {
    return await categoryRepositoryInterface.deleteStoreCategory(id);
  }

  @override
  Future<bool> updateCategoryStatus(int id, int status) async {
    return await categoryRepositoryInterface.updateCategoryStatus(id, status);
  }

  @override
  Future<ProductModel?> getStoreCategoryItems(int id, {required String offset}) async {
    return await categoryRepositoryInterface.getStoreCategoryItems(id, offset: offset);
  }

  @override
  Future<AssignableFoodModel?> getAssignableFoods(int categoryId, {required String offset, String search = ''}) async {
    return await categoryRepositoryInterface.getAssignableFoods(categoryId, offset: offset, search: search);
  }

  @override
  Future<bool> assignFoodsToCategory(int categoryId, List<int> foodIds) async {
    return await categoryRepositoryInterface.assignFoodsToCategory(categoryId, foodIds);
  }

}
