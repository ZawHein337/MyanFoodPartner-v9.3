import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AnnouncementBottomSheet extends StatefulWidget {
  final int announcementStatus;
  final String announcementMessage;
  const AnnouncementBottomSheet({super.key, required this.announcementStatus, required this.announcementMessage});

  @override
  State<AnnouncementBottomSheet> createState() => _AnnouncementBottomSheetState();
}

class _AnnouncementBottomSheetState extends State<AnnouncementBottomSheet> {

  final tooltipController = JustTheController();
  final TextEditingController _announcementController = TextEditingController();
  bool announcementStatus = false;

  @override
  void initState() {
    super.initState();
    announcementStatus = widget.announcementStatus == 1 ? true : false;
    _announcementController.text = widget.announcementMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: GetBuilder<RestaurantController>(builder: (restaurantController) {
          return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 15),

            Center(
              child: Container(
                height: 5, width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('make_an_announcement'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('announcement_visibility'.tr, style: robotoSemiBold),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('turn_on_to_display_this_announcement_on_the_user_app_web'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: 8, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('status'.tr, style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Switch(
                          value: announcementStatus,
                          onChanged: (value) {
                            setState(() {
                              announcementStatus = value;
                            });
                          },
                        ),

                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('announcement_content'.tr, style: robotoSemiBold),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomTextFieldWidget(
                      hintText: "type_announcement".tr,
                      controller: _announcementController,
                      maxLines: 5,
                      inputAction: TextInputAction.done,
                    ),
                  ]),
                ),
              ]),
            ),
      
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: Row(children: [
      
                Expanded(
                  child: CustomButtonWidget(
                    onPressed: () {
                      setState(() {
                        _announcementController.clear();
                        announcementStatus = false;
                      });
                    },
                    buttonText: 'reset'.tr,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                    textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
      
                Expanded(
                  child: CustomButtonWidget(
                    isLoading: restaurantController.isLoading,
                    onPressed: () {
                      if(_announcementController.text.isEmpty) {
                        showCustomSnackBar('enter_announcement'.tr);
                      }else {
                        restaurantController.updateAnnouncement(announcementStatus ? 1 : 0, _announcementController.text);
                      }
                    },
                    buttonText: 'submit'.tr,
                  ),
                ),
      
              ]),
            ),
      
          ]);
        }),
      ),
      
      Positioned(
        top: 10, right: 10,
        child: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.close, size: 20, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
        ),
      ),
    ]);
  }
}
