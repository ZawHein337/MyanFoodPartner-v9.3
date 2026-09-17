abstract class CouponServiceInterface {
  Future<dynamic> getCouponList(int offset);
  Future<dynamic> getCouponDetails(int id);
  Future<dynamic> changeStatus(int? couponId, int status);
  Future<dynamic> addCoupon(Map<String, String?> data);
  Future<dynamic> updateCoupon(Map<String, String?> data);
  Future<dynamic> deleteCoupon(int couponId);
}