import 'package:stackfood_multivendor_restaurant/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderViewWidget extends StatefulWidget {
  const OrderViewWidget({super.key});

  @override
  State<OrderViewWidget> createState() => _OrderViewWidgetState();
}

class _OrderViewWidgetState extends State<OrderViewWidget> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    OrderController orderController = Get.find<OrderController>();

    orderController.setOffset(1);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && orderController.historyOrderList != null && !orderController.paginate) {
        int pageSize = (orderController.pageSize! / 10).ceil();
        if (orderController.offset < pageSize) {
          orderController.setOffset(Get.find<OrderController>().offset+1);
          customPrint('end of the page');
          orderController.showBottomLoader();
          orderController.getPaginatedOrders(Get.find<OrderController>().offset, false, isSubscription: orderController.orderTypeIndex == 1 ? 1 : 0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Column(children: [

        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await orderController.getPaginatedOrders(1, true, isSubscription: orderController.orderTypeIndex == 1 ? 1 : 0),
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orderController.historyOrderList!.length,
              itemBuilder: (context, index) {
                return OrderWidget(
                  orderModel: orderController.historyOrderList![index],
                  hasDivider: index != orderController.historyOrderList!.length-1, isRunning: false,
                  showStatus: orderController.historyIndex == 0,
                );
              },
            ),
          ),
        ),

        orderController.paginate ? const Center(child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CircularProgressIndicator(),
        )) : const SizedBox(),

      ]);
    });
  }
}