import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class DeliverymanRepositoryInterface implements RepositoryInterface {
  Future<dynamic> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd);
  Future<dynamic> updateDeliveryManStatus(int? deliveryManID, int status);
  Future<dynamic> getDeliveryManReviews(int? deliveryManID);
  Future<dynamic> getAvailableDeliveryManList();
  Future<dynamic> assignDeliveryMan(int? deliveryManId, int? orderId);
}