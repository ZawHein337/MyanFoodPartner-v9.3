import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/other_data_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_des_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_suggestion_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/variation_data_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/repositories/ai_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';

class AiRepository implements AiRepositoryInterface {
  final ApiClient apiClient;
  AiRepository({required this.apiClient});

  @override
  Future<TitleDesModel?> generateTitleAndDes({required String title, required String langCode, required String restaurantId, required String generateFrom}) async {
    TitleDesModel? titleDesModel;
    Response response = await apiClient.getData('${AppConstants.generateTitleAndDes}?name=$title&langCode=$langCode&restaurant_id=$restaurantId&requestType=$generateFrom');
    if(response.statusCode == 200) {
      titleDesModel = TitleDesModel.fromJson(response.body);
    }
    return titleDesModel;
  }

  @override
  Future<OtherDataModel?> generateOtherData({required String title, required String description, required String restaurantId, required String generateFrom}) async {
    OtherDataModel? otherDataModel;
    Response response = await apiClient.getData('${AppConstants.generateOtherData}?name=$title&description=$description&restaurant_id=$restaurantId&requestType=$generateFrom');
    if(response.statusCode == 200) {
      otherDataModel = OtherDataModel.fromJson(response.body);
    }
    return otherDataModel;
  }

  @override
  Future<VariationDataModel?> generateVariationData({required String title, required String description, required String restaurantId, required String generateFrom}) async {
    VariationDataModel? variationDataModel;
    Response response = await apiClient.getData('${AppConstants.generateVariationData}?name=$title&description=$description&restaurant_id=$restaurantId&requestType=$generateFrom');
    if(response.statusCode == 200) {
      variationDataModel = VariationDataModel.fromJson(response.body);
    }
    return variationDataModel;
  }

  @override
  Future<TitleSuggestionModel?> generateTitleSuggestions({required String keywords, required String restaurantId}) async {
    TitleSuggestionModel? titleSuggestionModel;
    Response response = await apiClient.getData('${AppConstants.generateTitleSuggestion}?keywords=$keywords&restaurant_id=$restaurantId');
    if(response.statusCode == 200) {
      titleSuggestionModel = TitleSuggestionModel.fromJson(response.body);
    }
    return titleSuggestionModel;
  }

  @override
  Future<Response> generateFromImage({required XFile image}) async {
    Map<String, String> fields = {};
    Response response = await apiClient.postMultipartData(AppConstants.generateFromImage, fields, [MultipartBody('image', image)], []);
    return response;
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
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}