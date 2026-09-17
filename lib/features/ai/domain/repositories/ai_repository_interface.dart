import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/other_data_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_des_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/title_suggestion_model.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/domain/models/variation_data_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class AiRepositoryInterface implements RepositoryInterface {
  Future<TitleDesModel?> generateTitleAndDes({required String title, required String langCode, required String restaurantId, required String generateFrom});
  Future<OtherDataModel?> generateOtherData({required String title, required String description, required String restaurantId, required String generateFrom});
  Future<VariationDataModel?> generateVariationData({required String title, required String description, required String restaurantId, required String generateFrom});
  Future<TitleSuggestionModel?> generateTitleSuggestions({required String keywords, required String restaurantId});
  Future<Response> generateFromImage({required XFile image});
}