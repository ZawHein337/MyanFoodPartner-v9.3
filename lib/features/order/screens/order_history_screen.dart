import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/count_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/order_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  @override
  void initState() {
    super.initState();

    if(Get.find<ProfileController>().profileModel != null) {
      _initOrderType();
    } else {
      Get.find<ProfileController>().getProfile().then((_) {
        if(mounted && Get.find<ProfileController>().profileModel != null) {
          _initOrderType();
        }
      });
    }
  }

  void _initOrderType() {
    Get.find<OrderController>().changeOrderTypeIndex(
      (Get.find<ProfileController>().modulePermission?.regularOrder ?? false) ? 0 : 1, isUpdate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'order_history'.tr, isBackButtonExist: false, elevation: 0.5),

      body: GetBuilder<ProfileController>(builder: (profileController) {
        if(profileController.profileModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return (profileController.modulePermission?.regularOrder ?? false) || (profileController.modulePermission?.subscriptionOrder ?? false) ? GetBuilder<OrderController>(builder: (orderController) {
        return Column(children: [
          // const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
            ),
            child: Row(children: [

              Expanded(
                child: InkWell(
                  onTap: () {
                    if(profileController.modulePermission?.regularOrder ?? false){
                      orderController.changeOrderTypeIndex(0);
                    }else {
                      showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text(
                          'regular_order'.tr,
                          style: robotoMedium.copyWith(color: orderController.orderTypeIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.3)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: orderController.orderTypeIndex == 0 ? Theme.of(context).primaryColor : null,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: () {
                    if(profileController.modulePermission?.subscriptionOrder ?? false){
                      orderController.changeOrderTypeIndex(1);
                    }else {
                      showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text(
                          'subscription_order'.tr,
                          style: robotoMedium.copyWith(color: orderController.orderTypeIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.3)),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: orderController.orderTypeIndex == 1 ? Theme.of(context).primaryColor : null,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,),
                      ),
                    ],
                  ),
                ),
              ),

            ]),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
            
                GetBuilder<ProfileController>(builder: (profileController) {
                  return profileController.profileModel != null ? Container(
                    decoration: BoxDecoration(
                      color: Get.find<ThemeController>().darkTheme ? Theme.of(context).disabledColor.withValues(alpha: 0.2) : const Color(0xffF5F5FF),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(children: [

                      CountWidget(title: 'today'.tr, count: profileController.profileModel!.todaysOrderCount),
                      Container(
                        width: 1, height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),

                      CountWidget(title: 'this_week'.tr, count: profileController.profileModel!.thisWeekOrderCount),
                      Container(
                        width: 1, height: 40,
                        decoration: BoxDecoration(
                          color:  Theme.of(context).disabledColor,
                        ),
                      ),

                      CountWidget(title: 'this_month'.tr, count: profileController.profileModel!.thisMonthOrderCount),

                    ]),
                  ) : const SizedBox();
                }),
                const SizedBox(height: Dimensions.paddingSizeLarge),
            
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: orderController.statusList.length,
                          itemBuilder: (context, index) {
                            return OrderButtonWidget(
                              title: orderController.statusList[index].tr, index: index, orderController: orderController, fromHistory: true,
                              orderCount: orderController.statusList[index] == 'all' ? orderController.pageSize :
                              orderController.statusList[index] == 'delivered' ? orderController.deliveredOrderCount :
                              orderController.statusList[index] == 'refunded' ? orderController.refundedOrderCount :
                              orderController.statusList[index] == 'canceled' ? orderController.canceledOrderCount :
                              orderController.failedOrderCount,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
            
                      Expanded(
                        child: orderController.historyOrderList != null ? orderController.historyOrderList!.isNotEmpty ? const OrderViewWidget() : Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const CustomAssetImageWidget(image: Images.noOrderIcon, height: 50, width: 50),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
            
                            Text('${'no_order_yet'.tr}!', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),
                          ]),
                        ) : const Center(child: CircularProgressIndicator()),
                      ),
            
                    ]),
                  ),
                ),
            
              ]),
            ),
          ),
        ]);
        }) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
      }),
    );
  }
}