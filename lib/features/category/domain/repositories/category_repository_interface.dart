import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/assignable_food_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class CategoryRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getCategoryList({bool isRestaurantWise = false, String? search});
  Future<dynamic> getSubCategoryList(int? parentID, {bool isRestaurantWise = false});
  Future<ProductModel?> getCategoryItemList({required String offset, required int id, required int isSubCategory});
  Future<List<CategoryModel>?> getMyCategoryList({String search = ''});
  Future<CategoryDetailsModel?> getCategoryDetails(int id);
  Future<bool> addStoreCategory(List<Translation> translations, String priority, XFile? image);
  Future<bool> updateStoreCategory(int id, List<Translation> translations, String priority, XFile? image);
  Future<bool> deleteStoreCategory(int id);
  Future<bool> updateCategoryStatus(int id, int status);
  Future<ProductModel?> getStoreCategoryItems(int id, {required String offset});
  Future<AssignableFoodModel?> getAssignableFoods(int categoryId, {required String offset, String search = ''});
  Future<bool> assignFoodsToCategory(int categoryId, List<int> foodIds);
}
