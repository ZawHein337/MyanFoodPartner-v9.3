import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawRequestHistoryScreen extends StatelessWidget {
  const WithdrawRequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'withdraw_request_history'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem(Get.find<PaymentController>().statusList[0], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[1], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[2], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[3], context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        offset: const Offset(-25, 25),
        child: Container(
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
          ),
          child: Icon(Icons.filter_list_outlined, size: 25, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
        ),
        onSelected: (dynamic value) {
          int index = Get.find<PaymentController>().statusList.indexOf(value);
          Get.find<PaymentController>().filterWithdrawList(index);
        },
      ),
      onBackPressed: () {
        Get.find<PaymentController>().filterWithdrawList(0);
        Get.back();
      }),

      body: GetBuilder<PaymentController>(builder: (paymentController) {
        return paymentController.withdrawList!.isNotEmpty ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: paymentController.withdrawList!.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return WithdrawWidget(
              withdrawModel: paymentController.withdrawList![index],
              showDivider: index != paymentController.withdrawList!.length - 1,
            );
          },
        ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CustomAssetImageWidget(image: Images.noTransactionIcon, height: 50, width: 50),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text('${'no_transaction_yet'.tr}!' , style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
        ]));
      }),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? const Color(0xff9DA7BC) : status == 'Approved' ? const Color(0xff9DA7BC) : status == 'Denied' ? const Color(0xff9DA7BC) : null,
        fontSize: Dimensions.fontSizeLarge,
      )),
    );
  }

}