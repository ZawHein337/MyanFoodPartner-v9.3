import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialogWidget extends StatefulWidget {
  final String icon;
  final String? title;
  final String description;
  final Function(String? value) onPressed;
  const InputDialogWidget({super.key, required this.icon, this.title, required this.description, required this.onPressed});

  @override
  State<InputDialogWidget> createState() => _InputDialogWidgetState();
}

class _InputDialogWidgetState extends State<InputDialogWidget> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Image.asset(widget.icon, width: 50, height: 50),
            ),

            widget.title != null ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                widget.title!, textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).colorScheme.error),
              ),
            ) : const SizedBox(),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Text(widget.description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            CustomTextFieldWidget(
              maxLines: 1,
              controller: _textEditingController,
              hintText: 'enter_processing_time'.tr,
              isEnabled: true,
              inputType: TextInputType.phone,
              inputAction: TextInputAction.done,
              showLabelText: false,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            GetBuilder<OrderController>(builder: (orderController) {
              return (orderController.isLoading) ? const Center(child: CircularProgressIndicator()) : Row(children: [

                Expanded(child: CustomButtonWidget(
                  buttonText: 'submit'.tr,
                  onPressed: () {
                    if(_textEditingController.text.trim().isEmpty) {
                      showCustomSnackBar('please_provide_processing_time'.tr);
                    }else {
                      widget.onPressed(_textEditingController.text.trim());
                    }
                  },
                  height: 40,
                )),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Expanded(child: TextButton(
                  onPressed: ()  => Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                  ),
                  child: Text(
                    'cancel'.tr, textAlign: TextAlign.center,
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                )),

              ]);
            }),

          ]),
        ),
      )),
    );
  }
}