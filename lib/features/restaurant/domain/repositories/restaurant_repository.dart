import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/food_review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/vat_tax_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class RestaurantRepository implements RestaurantRepositoryInterface{
  final ApiClient apiClient;
  RestaurantRepository({required this.apiClient});

  @override
  Future<CuisineModel?> getList() async {
    CuisineModel? cuisineModel;
    Response response = await apiClient.getData(AppConstants.cuisineUri);
    if(response.statusCode == 200) {
      cuisineModel = CuisineModel.fromJson(response.body);
    }
    return cuisineModel;
  }

  @override
  Future<ProductModel?> getProductList(String offset, String type, String stockType, int? categoryId, String? search) async {
    ProductModel? productModel;
    Response response = await apiClient.getData('${AppConstants.productListUri}?offset=$offset&limit=10&type=$type&category_id=$categoryId&stock=$stockType&search=$search');
    if(response.statusCode == 200) {
      productModel = ProductModel.fromJson(response.body);
    }
    return productModel;
  }

  @override
  Future<ProductModel?> getReelAssignableProducts() async {
    Response response = await apiClient.getData('${AppConstants.productListUri}?offset=1&limit=999999&active=1');
    if(response.statusCode == 200) {
      return ProductModel.fromJson(response.body);
    }
    return null;
  }

  @override
  Future<bool> updateRestaurantBasicInfo(Restaurant restaurant, XFile? logo, XFile? cover, List<Translation> translation, XFile? metaImage) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put',
      'translations': jsonEncode(translation),
      'contact_number': restaurant.phone ?? '',
      'meta_index' : restaurant.metaData?.metaIndex ?? '',
      'meta_no_follow' : restaurant.metaData?.metaNoFollow ?? '',
      'meta_no_image_index' : restaurant.metaData?.metaNoImageIndex ?? '',
      'meta_no_archive' : restaurant.metaData?.metaNoArchive ?? '',
      'meta_no_snippet' : restaurant.metaData?.metaNoSnippet ?? '',
      'meta_max_snippet' : restaurant.metaData?.metaMaxSnippet ?? '',
      'meta_max_snippet_value' : restaurant.metaData?.metaMaxSnippetValue ?? '',
      'meta_max_video_preview' : restaurant.metaData?.metaMaxVideoPreview ?? '',
      'meta_max_video_preview_value' : restaurant.metaData?.metaMaxVideoPreviewValue ?? '',
      'meta_max_image_preview' : restaurant.metaData?.metaMaxImagePreview ?? '',
      'meta_max_image_preview_value' : restaurant.metaData?.metaMaxImagePreviewValue ?? '',
    });
    Response response = await apiClient.postMultipartData(AppConstants.restaurantBasicInfoUpdateUri, fields, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover), MultipartBody('meta_image', metaImage)], []);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant, List<String> cuisines, String characteristics, String tags) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put',
      'schedule_order': restaurant.scheduleOrder! ? '1' : '0',
      'characteristics': characteristics,
      'minimum_order': restaurant.minimumOrder.toString(), 'delivery': restaurant.delivery! ? '1' : '0',
      'take_away': restaurant.takeAway! ? '1' : '0', 'gst_status': restaurant.gstStatus! ? '1' : '0', 'gst': restaurant.gstCode!,
      'veg': restaurant.veg.toString(), 'non_veg': restaurant.nonVeg.toString(), 'cuisine_ids': jsonEncode(cuisines), 'order_subscription_active': restaurant.orderSubscriptionActive! ? '1' : '0',
      'cutlery': restaurant.cutlery! ? '1' : '0', 'instant_order': restaurant.instanceOrder! ? '1' : '0',
      'extra_packaging_status' : restaurant.extraPackagingStatus.toString(), 'extra_packaging_amount': restaurant.extraPackagingAmount.toString(),
      'is_extra_packaging_active' : restaurant.isExtraPackagingActive! ? '1' : '0',
      'is_dine_in_active' : restaurant.isDineInActive! ? '1' : '0', 'schedule_advance_dine_in_booking_duration' : restaurant.scheduleAdvanceDineInBookingDuration.toString(),
      'schedule_advance_dine_in_booking_duration_time_format' : restaurant.scheduleAdvanceDineInBookingDurationTimeFormat ?? '',
      'customer_date_order_sratus' : restaurant.customDateOrderStatus! ? '1' : '0', 'customer_order_date' : restaurant.customOrderDate.toString(),
      'free_delivery' : restaurant.freeDelivery! ? '1' : '0',
      'tags': tags, 'halal_tag_status' : restaurant.isHalalActive! ? '1' : '0',
    });
    if(restaurant.minimumShippingCharge != null && restaurant.perKmShippingCharge != null && restaurant.maximumShippingCharge != null) {
      fields.addAll(<String, String>{
        'minimum_delivery_charge': restaurant.minimumShippingCharge.toString(),
        'maximum_delivery_charge': restaurant.maximumShippingCharge.toString(),
        'per_km_delivery_charge': restaurant.perKmShippingCharge.toString(),
      });
    }
    Response response = await apiClient.postData(AppConstants.restaurantUpdateUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> addProduct(Product product, XFile? image, bool isAdd, String tags, List<int> deletedVariationIds, List<int> deletedVariationOptionIds, String nutrition, String allergicIngredients, XFile? metaImage) async {
    Map<String, String> fields = {};
    if (kDebugMode) {
      print('-========>R Ids>>>> :$deletedVariationIds // $deletedVariationOptionIds');
    }
    String deleteVariationIds = '';
    for(int index=0; index<deletedVariationIds.length; index++) {
      deleteVariationIds = '$deleteVariationIds${index == 0 ? deletedVariationIds[index] : ',${deletedVariationIds[index]}'}';
    }
    String deleteVariationOptionIds = '';
    for(int index=0; index<deletedVariationOptionIds.length; index++) {
      deleteVariationOptionIds = '$deleteVariationOptionIds${index == 0 ? deletedVariationOptionIds[index] : ',${deletedVariationOptionIds[index]}'}';
    }

    fields.addAll(<String, String> {'nutritions': nutrition, 'allergies': allergicIngredients});

    if (kDebugMode) {
      print('============eee====> $deleteVariationIds // $deleteVariationOptionIds');
    }
    fields.addAll(<String, String>{
      'price': product.price.toString(), 'discount': product.discount.toString(),
      'discount_type': product.discountType!, 'category_id': product.categoryIds![0].id!,
      'available_time_starts': product.availableTimeStarts!,
      'available_time_ends': product.availableTimeEnds!, 'veg': product.veg.toString(),
      'removedVariationIDs': deleteVariationIds,
      'removedVariationOptionIDs': deleteVariationOptionIds,
      'translations': jsonEncode(product.translations), 'tags': tags, 'maximum_cart_quantity': product.maxOrderQuantity.toString(),
      'options': jsonEncode(product.variations), 'item_stock': product.itemStock != null ? product.itemStock.toString() : '0', 'stock_type': product.stockType.toString(),
      'is_halal' : product.isHalal.toString(),
    });
    String addon = '';
    for(int index=0; index<product.addOns!.length; index++) {
      addon = '$addon${index == 0 ? product.addOns![index].id : ',${product.addOns![index].id}'}';
    }
    fields.addAll(<String, String> {'addon_ids': addon});
    if(product.categoryIds!.length > 1) {
      fields.addAll(<String, String> {'sub_category_id': product.categoryIds![1].id!});
    }
    if(!isAdd) {
      fields.addAll(<String, String> {'_method': 'put', 'id': product.id.toString()});
    }

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      fields.addAll({'tax_ids': jsonEncode(product.taxVatIds)});
    }
    if (product.restaurantCategoryId != null) {
      fields.addAll({'restaurant_category_id': product.restaurantCategoryId?.toString() ?? '999999999'});
    }

    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.addProductUri : AppConstants.updateProductUri, fields, [MultipartBody('image', image), MultipartBody('meta_image', metaImage)], []);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete({int? id}) async {
    Response response = await apiClient.postData('${AppConstants.deleteProductUri}?id=$id', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(int? restaurantID, String? searchText) async {
    List<ReviewModel>? restaurantReviewList;
    Response response = await apiClient.getData('${AppConstants.restaurantReviewUri}?restaurant_id=$restaurantID&search=$searchText');
    if(response.statusCode == 200) {
      restaurantReviewList = [];
      response.body.forEach((review) => restaurantReviewList!.add(ReviewModel.fromJson(review)));
    }
    return restaurantReviewList;
  }

  @override
  Future<FoodReviewModel?> getProductReviewList(int? productID) async {
    FoodReviewModel? productReviewList;
    Response response = await apiClient.getData('${AppConstants.productReviewUri}/$productID');
    if(response.statusCode == 200) {
      productReviewList = FoodReviewModel.fromJson(response.body);
    }
    return productReviewList;
  }

  @override
  Future<bool> updateProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductStatusUri}?id=$productID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductRecommendedUri}?id=$productID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    int? scheduleID;
    Response response = await apiClient.postData(AppConstants.addSchedule, schedule.toJson());
    if(response.statusCode == 200) {
      scheduleID = int.parse(response.body['id'].toString());
    }
    return scheduleID;
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    Response response = await apiClient.postData('${AppConstants.deleteSchedule}$scheduleID', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<Product?> get(int id) async {
    Product? product;
    Response response = await apiClient.getData('${AppConstants.productDetailsUri}/$id');
    if(response.statusCode == 200) {
      product = Product.fromJson(response.body);
    }
    return product;
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    Map<String, String> fields = {'announcement_status': status.toString(), 'announcement_message': announcement, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.announcementUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateReply(int reviewID, String reply) async {
    Map<String, String> fields = {'id': reviewID.toString(), 'reply': reply, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.updateReplyUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<List<String?>?> getCharacteristicSuggestionList() async {
    List<String?>? characteristicSuggestionList;
    Response response = await apiClient.getData(AppConstants.getCharacteristicSuggestion);
    if(response.statusCode == 200) {
      characteristicSuggestionList = [];
      response.body.forEach((characteristic) => characteristicSuggestionList?.add(characteristic));
    }
    return characteristicSuggestionList;
  }

  @override
  Future<bool> updateProductStock(String foodId, String itemStock, Product product, List<List<String>> variationStock) async {
    Map<int, String> options = {};

    for (var variation in product.variations!) {
      for (var value in product.variations![product.variations!.indexOf(variation)].variationValues!) {
        int optionId = int.parse(value.optionId.toString());
        String currentStock = variationStock[product.variations!.indexOf(variation)][product.variations![product.variations!.indexOf(variation)].variationValues!.indexOf(value)];
        options[optionId] = currentStock;
      }
    }

    // Convert keys to strings for JSON encoding
    Map<String, String> stringOptions = options.map((key, value) => MapEntry(key.toString(), value));

    Map<String, dynamic> fields = {};

    fields.addAll(<String, dynamic>{
      'food_id': foodId,
      'item_stock': itemStock,
      'option': jsonEncode(stringOptions),
      '_method': 'put'
    });

    Response response = await apiClient.postData(AppConstants.productUpdateStock, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<List<String?>?> getNutritionSuggestionList() async {
    List<String?>? nutritionSuggestionList;
    Response response = await apiClient.getData(AppConstants.getNutritionSuggestionUri);
    if(response.statusCode == 200) {
      nutritionSuggestionList = [];
      response.body.forEach((nutrition) => nutritionSuggestionList?.add(nutrition));
    }
    return nutritionSuggestionList;
  }

  @override
  Future<List<String?>?> getAllergicIngredientsSuggestionList() async {
    List<String?>? allergicIngredientsSuggestionList;
    Response response = await apiClient.getData(AppConstants.getAllergicIngredientsSuggestionUri);
    if(response.statusCode == 200) {
      allergicIngredientsSuggestionList = [];
      response.body.forEach((allergicIngredients) => allergicIngredientsSuggestionList?.add(allergicIngredients));
    }
    return allergicIngredientsSuggestionList;
  }

  @override
  Future<List<VatTaxModel>?> getVatTaxList() async {
    List<VatTaxModel>? vatTaxList;
    Response response = await apiClient.getData(AppConstants.vatTaxListUri);
    if(response.statusCode == 200) {
      vatTaxList = [];
      response.body.forEach((vatTax) => vatTaxList!.add(VatTaxModel.fromJson(vatTax)));
    }
    return vatTaxList;
  }

  @override
  Future<ResponseModel> openingClosingStatus({required int openingClosingStatus, required int sameTimeForEveryDay}) async{
    Map<String, dynamic> fields = {};
    fields.addAll(<String, dynamic>{
      'opening_closing_status': openingClosingStatus,
      'same_time_for_every_day': sameTimeForEveryDay,
    });
    Response response = await apiClient.postData(AppConstants.openingClosingStatus, fields);
    if(response.statusCode == 200) {
      return ResponseModel(true, response.body['message']);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}