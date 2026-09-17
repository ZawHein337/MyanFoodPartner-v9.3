import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class CouponRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getCouponList(int offset);
  Future<dynamic> changeStatus(int? couponId, int status);
  Future<dynamic> addCoupon(Map<String, String?> data);
}