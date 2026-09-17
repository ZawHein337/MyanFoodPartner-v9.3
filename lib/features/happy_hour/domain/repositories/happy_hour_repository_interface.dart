import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class HappyHourRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getHappyHourList({required int offset, required String type, String? searchText, int limit});
  Future<dynamic> getHappyHourDetails(int id);
  Future<dynamic> joinHappyHour(int id);
  Future<dynamic> respondToHappyHour(int id, String status, {String? rejectionReason});
  Future<dynamic> leaveHappyHour(int id);
}
