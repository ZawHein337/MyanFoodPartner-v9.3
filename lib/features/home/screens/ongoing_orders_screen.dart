import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class OngoingOrdersScreen extends StatefulWidget {
  const OngoingOrdersScreen({super.key});

  @override
  State<OngoingOrdersScreen> createState() => _OngoingOrdersScreenState();
}

class _OngoingOrdersScreenState extends State<OngoingOrdersScreen> {
  ScrollController statusScrollController = ScrollController();
  ScrollController orderScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final OrderController orderController = Get.find<OrderController>();
    orderController.setRunningOffset(1);

    orderScrollController.addListener(() {
      if (orderScrollController.position.pixels == orderScrollController.position.maxScrollExtent
          && orderController.runningOrders != null && !orderController.runningPaginate && !orderController.runningOrderLoading
          && orderController.runningPageSize != null) {
        int pageSize = (orderController.runningPageSize! / 10).ceil();
        if (orderController.runningOffset < pageSize) {
          orderController.setRunningOffset(orderController.runningOffset + 1);
          orderController.showRunningBottomLoader();
          orderController.getCurrentOrders(offset: orderController.runningOffset);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedIndex();
    });
  }

  @override
  void dispose() {
    statusScrollController.dispose();
    orderScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedIndex() {
    final orderController = Get.find<OrderController>();
    if (orderController.runningOrders != null && statusScrollController.hasClients) {

      final selectedIndex = orderController.orderIndex;
      final itemWidth = 120.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final targetScroll = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      statusScrollController.animateTo(
        targetScroll.clamp(0.0, statusScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'ongoing_orders'.tr),
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return (profileController.modulePermission?.regularOrder ?? false) || (profileController.modulePermission?.subscriptionOrder ?? false) ? GetBuilder<OrderController>(builder: (orderController) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToSelectedIndex();
          });

          List<OrderModel> orderList = [];

          if(orderController.runningOrders != null) {
            orderList = orderController.runningOrders![orderController.orderIndex].orderList;
          }

          return CustomCard(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              orderController.runningOrders != null ? SizedBox(
                height: 40,
                child: ListView.builder(
                  controller: statusScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: orderController.runningOrders!.length,
                  itemBuilder: (context, index) {
                    return OrderButtonWidget(
                      title: orderController.runningOrders![index].status.tr,
                      index: index,
                      orderController: orderController,
                      fromHistory: false,
                    );
                  },
                ),
              ) : const SizedBox(),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                  orderController.runningOrders != null ? InkWell(
                    onTap: () => orderController.toggleCampaignOnly(),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: orderController.campaignOnly ? Colors.green : Theme.of(context).cardColor,
                          border: Border.all(color: orderController.campaignOnly ? Colors.transparent : Theme.of(context).hintColor),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 14, color: orderController.campaignOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                      ),

                      Text(
                        'campaign_order'.tr,
                        style: orderController.campaignOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                            : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ]),
                  ) : const SizedBox(),

                  orderController.runningOrders != null ? InkWell(
                    onTap: () {
                      if(profileController.modulePermission?.subscriptionOrder ?? false) {
                        orderController.toggleSubscriptionOnly();
                      } else {
                        showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                      }
                    },
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: orderController.subscriptionOnly ? Colors.green : Theme.of(context).cardColor,
                          border: Border.all(color: orderController.subscriptionOnly ? Colors.transparent : Theme.of(context).hintColor),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 14, color: orderController.subscriptionOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                      ),

                      Text(
                        'subscription_order'.tr,
                        style: orderController.subscriptionOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                            : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ]),
                  ) : const SizedBox(),

                ]),
              ),

              const Divider(height: Dimensions.paddingSizeOverLarge),

              Expanded(
                child: (orderController.runningOrders == null || orderController.runningOrderLoading) ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const OrderShimmerWidget(isEnabled: true);
                  },
                ) : orderList.isNotEmpty ? RefreshIndicator(
                  onRefresh: () async => await orderController.getCurrentOrders(offset: 1, reload: true),
                  child: ListView.builder(
                    controller: orderScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                    },
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: Text('no_order_found'.tr)),
                ),
              ),

              orderController.runningPaginate ? const Center(child: Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(),
              )) : const SizedBox(),

            ]),
          );
        }) : const SizedBox();
      }),
    );
  }
}
