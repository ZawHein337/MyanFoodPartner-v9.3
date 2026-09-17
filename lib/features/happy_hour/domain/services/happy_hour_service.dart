import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/repositories/happy_hour_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/services/happy_hour_service_interface.dart';

class HappyHourService implements HappyHourServiceInterface {
  final HappyHourRepositoryInterface happyHourRepositoryInterface;
  HappyHourService({required this.happyHourRepositoryInterface});

  @override
  Future<HappyHourBodyModel?> getHappyHourList({required int offset, required String type, String? searchText, int limit = 10}) async {
    return await happyHourRepositoryInterface.getHappyHourList(offset: offset, type: type, searchText: searchText, limit: limit);
  }

  @override
  Future<({HappyHourModel? happyHour, bool isNotFound})> getHappyHourDetails(int id) async {
    return await happyHourRepositoryInterface.getHappyHourDetails(id);
  }

  @override
  Future<ResponseModel> joinHappyHour(int id) async {
    return await happyHourRepositoryInterface.joinHappyHour(id);
  }

  @override
  Future<ResponseModel> respondToHappyHour(int id, String status, {String? rejectionReason}) async {
    return await happyHourRepositoryInterface.respondToHappyHour(id, status, rejectionReason: rejectionReason);
  }

  @override
  Future<ResponseModel> leaveHappyHour(int id) async {
    return await happyHourRepositoryInterface.leaveHappyHour(id);
  }
}
