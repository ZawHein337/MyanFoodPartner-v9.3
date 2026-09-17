import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<PaymentController>().getWalletPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'payment_history'.tr),

      body: GetBuilder<PaymentController>(builder: (paymentController) {
        return paymentController.transactions != null ? paymentController.transactions!.isNotEmpty ? ListView.builder(
          itemCount: paymentController.transactions!.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                child: Row(children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        PriceConverter.convertPrice(paymentController.transactions![index].amount),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        '${'paid_via'.tr} ${paymentController.transactions![index].method?.replaceAll('_', ' ').capitalize??''}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                      ),

                    ]),
                  ),

                  Text(
                    paymentController.transactions![index].paymentTime.toString(),
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),

                ]),
              ),

              const Divider(height: 1),

            ]);
          },
        ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CustomAssetImageWidget(image: Images.noTransactionIcon, height: 50, width: 50),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text('${'no_transaction_yet'.tr}!' , style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
        ])) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}