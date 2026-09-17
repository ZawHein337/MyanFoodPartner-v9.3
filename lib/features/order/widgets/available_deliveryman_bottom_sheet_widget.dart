import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/map_view_screen.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableDeliveryManBottomSheetWidget extends StatefulWidget {
  final int orderId;
  final int? assignedDeliveryManId;
  const AvailableDeliveryManBottomSheetWidget({super.key, required this.orderId, required this.assignedDeliveryManId});

  @override
  State<AvailableDeliveryManBottomSheetWidget> createState() => _AvailableDeliveryManBottomSheetWidgetState();
}

class _AvailableDeliveryManBottomSheetWidgetState extends State<AvailableDeliveryManBottomSheetWidget> {

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Get.find<DeliveryManController>().getAvailableDeliveryManList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryManController>(builder: (deliveryManController) {
      return deliveryManController.availableDeliveryManList != null ? Container(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(
                "available_delivery_man".tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)
              ),

              Text(
                "${deliveryManController.availableDeliveryManList!.length} ${"delivery_man_available".tr}",
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),

            ]),

            deliveryManController.availableDeliveryManList != null && deliveryManController.availableDeliveryManList!.isNotEmpty ? InkWell(
              onTap: () => Get.to(()=> MapViewScreen(deliveryManList: deliveryManController.availableDeliveryManList)),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: const Color(0xFF006FBD)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Text(
                  "view_on_map".tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF006FBD),
                  ),
                ),
              ),
            ) : const SizedBox(),

          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          deliveryManController.availableDeliveryManList!.isNotEmpty ? Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                itemCount: deliveryManController.availableDeliveryManList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool isAssigned = deliveryManController.availableDeliveryManList![index].id == widget.assignedDeliveryManId;
                  return Column(children: [

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: Dimensions.paddingSizeDefault,
                      leading: Container(
                        height: 50, width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: CustomImageWidget(
                          image: '${deliveryManController.availableDeliveryManList![index].imageFullUrl}',
                        ),
                      ),

                      title: Text(
                        deliveryManController.availableDeliveryManList![index].name ?? '',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          "${"active_order".tr} : ${deliveryManController.availableDeliveryManList![index].currentOrders}",
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                        Text(
                          "${deliveryManController.availableDeliveryManList![index].distance} ${"away_from_restaurant".tr}",
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ]),

                      trailing: InkWell(
                        onTap: () {
                          _selectedIndex = index;
                          deliveryManController.assignDeliveryMan(deliveryManController.availableDeliveryManList![index].id!, widget.orderId);
                        },
                        child: Container(
                          height: 35, width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: isAssigned ? Colors.green : const Color(0xFF006FBD),
                          ),
                          child: (deliveryManController.isLoading && _selectedIndex == index)
                              ? Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor)))
                              : Text(
                            isAssigned ? 'assigned'.tr : "assign".tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 0, thickness: 0.5),

                  ]);
                },
              ),
            ),
          ) : Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Text('no_deliveryman_available'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

        ]),
      ) : const Center(child: CircularProgressIndicator());
    });
  }
}