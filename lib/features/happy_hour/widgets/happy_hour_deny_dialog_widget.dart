import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HappyHourDenyDialogWidget extends StatefulWidget {
  final Function(String? reason) onSubmit;
  const HappyHourDenyDialogWidget({super.key, required this.onSubmit});

  static Future<T?> show<T>({required Function(String? reason) onSubmit}) {
    return Get.dialog<T>(HappyHourDenyDialogWidget(onSubmit: onSubmit));
  }

  @override
  State<HappyHourDenyDialogWidget> createState() => _HappyHourDenyDialogWidgetState();
}

class _HappyHourDenyDialogWidgetState extends State<HappyHourDenyDialogWidget> {

  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              'deny'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              'rejection_reason'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFieldWidget(
              controller: _reasonController,
              hintText: 'rejection_reason'.tr,
              maxLines: 3,
              maxLength: 255,
              inputAction: TextInputAction.done,
              showLabelText: false,
              capitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [

              Expanded(child: CustomButtonWidget(
                buttonText: 'cancel'.tr,
                color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
                height: 45,
                onPressed: () => Get.back(),
              )),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: CustomButtonWidget(
                buttonText: 'deny'.tr,
                color: Theme.of(context).colorScheme.error,
                height: 45,
                onPressed: () {
                  Get.back();
                  final String reason = _reasonController.text.trim();
                  widget.onSubmit(reason.isEmpty ? null : reason);
                },
              )),

            ]),

          ]),
        ),
      )),
    );
  }
}
