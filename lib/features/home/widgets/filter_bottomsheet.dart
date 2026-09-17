import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Center(
          child: Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),

        Center(child: Text('filter_data'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge))),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Flexible(
          child: GetBuilder<OrderController>(builder: (orderController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    child: Text('sort_by'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),
                  Divider(),

                  orderController.runningOrders != null ? ListView.builder(
                    itemCount: orderController.runningOrders!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isSelected = orderController.orderIndex == index;
                      return CustomInkWellWidget(
                        radius: Dimensions.radiusDefault,
                        onTap: () {
                          orderController.setOrderIndex(index);
                        },
                        child: Row(children: [
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Text(orderController.runningOrders![index].status.tr, style: isSelected ? robotoBold : robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5))),

                          const Spacer(),

                          RadioGroup(
                            groupValue: true,
                            onChanged: (bool? value) {
                              orderController.setOrderIndex(index);
                            },
                            child: Radio(value: isSelected),
                          ),
                        ]),
                      );
                    },
                  ) : const SizedBox(),

                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeLarge),
                    child: Text('order_type'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),
                  Divider(),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    orderController.runningOrders != null ? CustomInkWellWidget(
                      onTap: () => orderController.toggleCampaignOnly(),
                      radius: Dimensions.radiusDefault,
                      child: Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Row(children: [

                          Text(
                            'campaign_order'.tr,
                            style: orderController.campaignOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                          ),
                          Spacer(),

                          Checkbox(
                            value: orderController.campaignOnly,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            onChanged: (bool? value) => orderController.toggleCampaignOnly(),
                          ),
                        ]),
                      ),
                    ) : const SizedBox(),

                    orderController.runningOrders != null ? CustomInkWellWidget(
                      onTap: () {
                        if(Get.find<ProfileController>().modulePermission?.subscriptionOrder ?? false) {
                          orderController.toggleSubscriptionOnly();
                        } else {
                          showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                        }
                      },
                      radius: Dimensions.radiusDefault,
                      child: Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Row(children: [

                          Text(
                            'subscription_order'.tr,
                            style: orderController.subscriptionOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                          ),
                          Spacer(),

                          Checkbox(
                            value: orderController.subscriptionOnly,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            onChanged: (bool? value) => orderController.toggleSubscriptionOnly(),
                          ),
                        ]),
                      ),
                    ) : const SizedBox(),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                  ]),

                ],
              ),
            );
          }),
        ),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))]
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: GetBuilder<OrderController>(
            builder: (orderController) {
              return Row(children: [
                Expanded(
                  child: CustomButtonWidget(
                    onPressed: () {
                      Get.find<OrderController>().setOrderIndex(0);
                      if(orderController.subscriptionOnly) {
                        orderController.toggleSubscriptionOnly();
                      }
                      if(orderController.campaignOnly) {
                        orderController.toggleCampaignOnly();
                      }
                      Get.back();
                    },
                    buttonText: 'reset'.tr,
                    color: Theme.of(context).disabledColor,
                    textColor: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Expanded(
                  child: CustomButtonWidget(
                    onPressed: () {
                      Get.back();
                    },
                    buttonText: 'filter'.tr,
                  ),
                ),
              ]);
            }
          ),
        )

      ]),
    );
  }
}
