import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/other_data_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_des_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_suggestion_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/variation_data_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/repositories/ai_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/services/ai_service_interface.dart';

class AiService implements AiServiceInterface {
  final AiRepositoryInterface aiRepositoryInterface;
  AiService({required this.aiRepositoryInterface});

  @override
  Future<TitleDesModel?> generateTitleAndDes({required String title, required String langCode, required String restaurantId, required String generateFrom}) async {
    return await aiRepositoryInterface.generateTitleAndDes(title: title, langCode: langCode, restaurantId: restaurantId, generateFrom: generateFrom);
  }

  @override
  Future<OtherDataModel?> generateOtherData({required String title, required String description, required String restaurantId, required String generateFrom}) async {
    return await aiRepositoryInterface.generateOtherData(title: title, description: description, restaurantId: restaurantId, generateFrom: generateFrom);
  }

  @override
  Future<VariationDataModel?> generateVariationData({required String title, required String description, required String restaurantId, required String generateFrom}) async {
    return await aiRepositoryInterface.generateVariationData(title: title, description: description, restaurantId: restaurantId, generateFrom: generateFrom);
  }

  @override
  Future<TitleSuggestionModel?> generateTitleSuggestions({required String keywords, required String restaurantId}) async {
    return await aiRepositoryInterface.generateTitleSuggestions(keywords: keywords, restaurantId: restaurantId);
  }

  @override
  Future<Response> generateFromImage({required XFile image}) async {
    return await aiRepositoryInterface.generateFromImage(image: image);
  }

}