import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/widgets/notification_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  void _openNotification(BuildContext context, NotificationModel notificationModel) {
    if(notificationModel.data?.type == 'happy_hour' && notificationModel.data?.dataId != null) {
      Get.toNamed(RouteHelper.getHappyHourDetailsRoute(id: notificationModel.data!.dataId!));
      return;
    }

    showDialog(context: context, builder: (BuildContext context) {
      return NotificationDialogWidget(notificationModel: notificationModel);
    });
  }

  @override
  Widget build(BuildContext context) {

    Get.find<NotificationController>().getNotificationList();

    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if(fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'notification'.tr, onBackPressed: () {
          if(fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else {
            Get.back();
          }
        }),
        body: GetBuilder<NotificationController>(builder: (notificationController) {

          if(notificationController.notificationList != null) {
            notificationController.saveSeenNotificationCount(notificationController.notificationList!.length);
          }

          List<DateTime> dateTimeList = [];

          return notificationController.notificationList != null ? notificationController.notificationList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList();
            },
            child: SingleChildScrollView(child: Center(child: SizedBox(width: 1170, child: ListView.builder(
              itemCount: notificationController.notificationList!.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {

                DateTime originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList![index].updatedAt!);
                DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                bool addTitle = false;

                if(!dateTimeList.contains(convertedDate)) {
                  addTitle = true;
                  dateTimeList.add(convertedDate);
                }
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  addTitle ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(DateConverter.dateTimeStringToDateOnly(notificationController.notificationList![index].createdAt!)),
                  ) : const SizedBox(),

                  ListTile(
                    onTap: () => _openNotification(context, notificationController.notificationList![index]),
                    leading: notificationController.notificationList![index].data?.type == 'push_notification' ? ClipOval(child: CustomImageWidget(
                      image: '${notificationController.notificationList![index].imageFullUrl}',
                      height: 40, width: 40, fit: BoxFit.cover,
                    )) : notificationController.notificationList![index].data?.type == 'verified_badge' ? ClipOval(child: const Icon(Icons.verified, color: Color(0xFF1DA1F2), size: 40) ): const CustomAssetImageWidget(
                      image: Images.notificationOrderIcon, height: 40, width: 40,
                    ),
                    title: Text(
                      notificationController.notificationList![index].title ?? '',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    subtitle: Text(
                      notificationController.notificationList![index].description ?? '',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Divider(color: Theme.of(context).hintColor),
                  ),

                ]);
              },
            )))),
          ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CustomAssetImageWidget(image: Images.noNotificationIcon, height: 50, width: 50),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('no_notification'.tr, style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
          ])) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}