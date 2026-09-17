import 'package:get/get_connect/http/src/response/response.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/models/advertisement_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class AdvertisementRepositoryInterface<T> implements RepositoryInterface<T> {
  Future<Response> submitNewAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile);
  Future<Response> copyAddAdvertisement(Map<String, String> body, List<MultipartBody> selectedFile);
  Future<AdvertisementModel?> getAdvertisementList(String offset, String type);
  Future<Response> editAdvertisement({required String id, required Map<String, String> body, List<MultipartBody>? selectedFile});
  Future<bool> changeAdvertisementStatus({required String note, required String status, required int id});
}