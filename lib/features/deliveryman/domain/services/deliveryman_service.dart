import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_list_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';

class DeliverymanService implements DeliverymanServiceInterface {
  final DeliverymanRepositoryInterface deliverymanRepositoryInterface;
  DeliverymanService({required this.deliverymanRepositoryInterface});

  @override
  Future<List<DeliveryManModel>?> getDeliveryManList() async {
    return await deliverymanRepositoryInterface.getList();
  }

  @override
  Future<bool> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd) async {
    return await deliverymanRepositoryInterface.addDeliveryMan(deliveryMan, pass, image, identities, token, isAdd);
  }

  @override
  Future<bool> deleteDeliveryMan(int deliveryManID) async {
    return await deliverymanRepositoryInterface.delete(id: deliveryManID);
  }

  @override
  Future<bool> updateDeliveryManStatus(int? deliveryManID, int status) async {
    return await deliverymanRepositoryInterface.updateDeliveryManStatus(deliveryManID, status);
  }

  @override
  Future<List<ReviewModel>?> getDeliveryManReviews(int? deliveryManID) async {
    return await deliverymanRepositoryInterface.getDeliveryManReviews(deliveryManID);
  }

  @override
  Future<List<DeliveryManListModel>?> getAvailableDeliveryManList() async {
    return await deliverymanRepositoryInterface.getAvailableDeliveryManList();
  }

  @override
  Future<bool> assignDeliveryMan(int? deliveryManId, int? orderId) async {
    return await deliverymanRepositoryInterface.assignDeliveryMan(deliveryManId, orderId);
  }

}