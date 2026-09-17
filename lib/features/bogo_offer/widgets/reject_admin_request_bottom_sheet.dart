import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class RejectAdminRequestBottomSheet extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const RejectAdminRequestBottomSheet({super.key, required this.onSubmit});

  @override
  State<RejectAdminRequestBottomSheet> createState() => _RejectAdminRequestBottomSheetState();
}

class _RejectAdminRequestBottomSheetState extends State<RejectAdminRequestBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        width: context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('rejection_reason'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeDefault),
    
          CustomTextFieldWidget(
            controller: _reasonController,
            hintText: 'write_the_reason_for_rejection'.tr,
            maxLines: 4,
            maxLength: 255,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
    
          CustomButtonWidget(
            buttonText: 'submit'.tr,
            onPressed: () {
              Get.back();
              widget.onSubmit(_reasonController.text.trim());
            },
          ),
        ]),
      ),
    );
  }
}
