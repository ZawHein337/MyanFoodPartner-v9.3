import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/image_to_pdf.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/invoice_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class PdfGenerateDialog extends StatefulWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  const PdfGenerateDialog({super.key, required this.order, required this.orderDetails});

  @override
  State<PdfGenerateDialog> createState() => _PdfGenerateDialogState();
}

class _PdfGenerateDialogState extends State<PdfGenerateDialog> {

  ScreenshotController screenshotController = ScreenshotController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Expanded(
          child: SingleChildScrollView(
            child: InvoiceDialogWidget(
              order: widget.order, orderDetails: widget.orderDetails,
              screenshotController: screenshotController,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: _isLoading ? const CircularProgressIndicator() : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? capturedImage) async {
                //Capture Done
                if (kDebugMode) {
                  print('its calling :  $capturedImage');
                }
                await capturedImageToPdf(
                  capturedImage: capturedImage,
                  businessName: Get.find<SplashController>().configModel?.businessName ?? AppConstants.appName,
                  orderId: widget.order!.id.toString(),
                );
                setState(() {
                  _isLoading = false;
                });

              }).catchError((onError) {
                if (kDebugMode) {
                  print(onError);
                }
                setState(() {
                  _isLoading = false;
                });
              }).then((value) {
                Get.back();
              });
            },
            child: Text('download_pdf'.tr, style: robotoMedium.copyWith(color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}
