import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/domain/models/reel_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/domain/models/reel_model.dart';

abstract class ReelServiceInterface {
  Future<ReelsModel?> getReelsList(String offset, String status, String sortBy, {String? search});
  Future<ReelDetailsModel?> getReelDetails(int reelId);
  Future<Response> storeReel(Map<String, String> body, List<MultipartBody> files);
  Future<Response> updateReel(Map<String, String> body, List<MultipartBody> files);
  Future<Response> deleteReel(int reelId);
  Future<Response> changeReelStatus(int reelId, int status);
}
