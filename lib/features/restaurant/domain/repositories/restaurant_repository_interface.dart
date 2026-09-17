import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/vat_tax_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getProductList(String offset, String type, String stockType, int? categoryId, String? search);
  Future<dynamic> getReelAssignableProducts();
  Future<dynamic> updateRestaurantBasicInfo(Restaurant restaurant, XFile? logo, XFile? cover, List<Translation> translation, XFile? metaImage);
  Future<dynamic> updateRestaurant(Restaurant restaurant, List<String> cuisines, String characteristics, String tags);
  Future<dynamic> addProduct(Product product, XFile? image, bool isAdd, String tags, List<int> deletedVariationIds, List<int> deletedVariationOptionIds, String nutrition, String allergicIngredients, XFile? metaImage);
  Future<dynamic> getRestaurantReviewList(int? restaurantID, String? searchText);
  Future<dynamic> getProductReviewList(int? productID);
  Future<dynamic> updateProductStatus(int? productID, int status);
  Future<dynamic> updateRecommendedProductStatus(int? productID, int status);
  Future<dynamic> addSchedule(Schedules schedule);
  Future<dynamic> deleteSchedule(int? scheduleID);
  Future<dynamic> updateAnnouncement(int status, String announcement);
  Future<bool> updateReply(int reviewID, String reply);
  Future<List<String?>?> getCharacteristicSuggestionList();
  Future<bool> updateProductStock(String foodId, String itemStock, Product product, List<List<String>> variationStock);
  Future<List<String?>?> getAllergicIngredientsSuggestionList();
  Future<List<String?>?> getNutritionSuggestionList();
  Future<List<VatTaxModel>?> getVatTaxList();
  Future<ResponseModel> openingClosingStatus({required int openingClosingStatus, required int sameTimeForEveryDay});
}