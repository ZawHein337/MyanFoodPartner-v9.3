abstract class BogoOfferServiceInterface {
  Future<dynamic> getBogoOfferList(String offset, {String? search, String? type});
  Future<dynamic> getBogoOfferDetails(int offerId);
  Future<dynamic> joinBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems);
  Future<dynamic> resubmitBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems);
  Future<dynamic> leaveBogoOffer(int offerId);
  Future<dynamic> respondToBogoOffer(int offerId, {required String status, String? rejectionReason});
  Future<dynamic> getBogoOfferFoods({String? search});
}
