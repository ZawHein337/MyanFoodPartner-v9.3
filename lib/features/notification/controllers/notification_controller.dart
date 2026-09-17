import 'package:stackfood_multivendor_restaurant/features/notification/domain/services/notification_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationServiceInterface notificationServiceInterface;
  NotificationController({required this.notificationServiceInterface});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  Future<void> getNotificationList() async {
    List<NotificationModel>? notificationList = await notificationServiceInterface.getNotificationList();
    if (notificationList != null) {
      _notificationList = [];
      _notificationList!.addAll(notificationList);
      _notificationList!.sort((NotificationModel n1, NotificationModel n2) {
        return DateConverter.dateTimeStringToDate(n1.updatedAt!).compareTo(DateConverter.dateTimeStringToDate(n2.updatedAt!));
      });
      _notificationList = _notificationList!.reversed.toList();
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationServiceInterface.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationServiceInterface.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }

}