import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/controllers/ai_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/widgets/animated_border_container.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class MetaSeoWidget extends StatelessWidget {
  final TextEditingController metaTitleController;
  final TextEditingController metaDescriptionController;
  final TextEditingController maxSnippetController;
  final TextEditingController maxVideoPreviewController;
  final String? metaImage;
  const MetaSeoWidget({super.key, required this.metaTitleController, required this.metaDescriptionController, required this.maxSnippetController,
    required this.maxVideoPreviewController, this.metaImage});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<AiController>(builder: (aiController) {
        return AnimatedBorderContainer(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
          isLoading: aiController.otherDataLoading,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            CustomTextFieldWidget(
              hintText: 'meta_title'.tr,
              labelText: 'meta_title'.tr,
              controller: metaTitleController,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            CustomTextFieldWidget(
              hintText: 'meta_description'.tr,
              labelText: 'meta_description'.tr,
              controller: metaDescriptionController,
              capitalization: TextCapitalization.sentences,
              maxLines: 5,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Text('meta_image'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraLarge),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(children: [

                Stack(clipBehavior: Clip.none, children: [

                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: restController.pickedMetaImage != null ? GetPlatform.isWeb ? Image.network(
                        restController.pickedMetaImage!.path, width: 120, height: 120, fit: BoxFit.cover) : Image.file(
                        File(restController.pickedMetaImage!.path), width: 120, height: 120, fit: BoxFit.cover) : CustomImageWidget(
                        image: metaImage ?? '',
                        height: 120, width: 120, fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => restController.pickMetaImage(),
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          dashPattern: const [8, 4],
                          strokeWidth: 1,
                          color: Theme.of(context).hintColor,
                        ),
                        child: const SizedBox(width: 120, height: 120),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -10, right: -10,
                    child: InkWell(
                      onTap: () => restController.pickMetaImage(),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 0.5),
                        ),
                        child: const Icon(Icons.edit, color: Colors.blue, size: 16),
                      ),
                    ),
                  ),

                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), children: [
                    TextSpan(text: 'jpg_jpeg_png_less_than_1mb'.tr),
                    TextSpan(text: ' (${'ratio_1_1'.tr})'.tr, style: robotoBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                  ]),
                ),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    InkWell(
                      onTap: () => restController.setMetaIndex('index'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          SizedBox(
                            height: 20, width: 20,
                            child: RadioGroup<String>(
                              groupValue: restController.metaIndex,
                              onChanged: (value) {
                                restController.setMetaIndex(value!);
                              },
                              child: Radio<String>(value: 'index'),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Text('index'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,  color: Theme.of(context).textTheme.bodyLarge?.color)),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    MetaSeoItem(
                      title: 'no_follow'.tr,
                      value: restController.noFollow == 'nofollow' ? true : false,
                      callback: (bool? value){
                        restController.setNoFollow(value! ? 'nofollow' : '0');
                      },
                    ),

                    MetaSeoItem(
                      title: 'no_image_index'.tr,
                      value: restController.noImageIndex == 'noimageindex' ? true : false,
                      callback: (bool? value){
                        restController.setNoImageIndex(value! ? 'noimageindex' : '0');
                      },
                    ),

                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    InkWell(
                      onTap: () => restController.setMetaIndex('noindex'),
                      child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        SizedBox(
                          height: 20, width: 20,
                          child: RadioGroup<String>(
                            groupValue: restController.metaIndex,
                            onChanged: (value) {
                              restController.setMetaIndex(value!);
                              restController.setNoFollow('nofollow');
                              restController.setNoImageIndex('noimageindex');
                              restController.setNoArchive('noarchive');
                              restController.setNoSnippet('1');
                            },
                            child: Radio<String>(value: 'noindex'),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Text('no_index'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,  color: Theme.of(context).textTheme.bodyLarge?.color)),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                      ]),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    MetaSeoItem(
                      title: 'no_archive'.tr,
                      value: restController.noArchive == 'noarchive' ? true : false,
                      callback: (bool? value){
                        restController.setNoArchive(value! ? 'noarchive' : '0');
                      },
                    ),

                    MetaSeoItem(
                      title: 'no_snippet'.tr,
                      value: restController.noSnippet == '1' ? true : false,
                      callback: (bool? value){
                        restController.setNoSnippet(value! ? '1' : '0');
                      },
                    ),

                  ]),
                ),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Row(children: [

                Expanded(
                  flex: 3,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    MetaSeoItem(
                      title: 'max_snippet'.tr,
                      value: restController.maxSnippet == '1' ? true : false,
                      callback: (bool? value){
                        restController.setMaxSnippet(value! ? '1' : '0');
                      },
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    MetaSeoItem(
                      title: 'max_video_preview'.tr,
                      value: restController.maxVideoPreview == '1' ? true : false,
                      callback: (bool? value){
                        restController.setMaxVideoPreview(value! ? '1' : '0');
                      },
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    MetaSeoItem(
                      title: 'max_image_preview'.tr,
                      value: restController.maxImagePreview == '1' ? true : false,
                      callback: (bool? value){
                        restController.setMaxImagePreview(value! ? '1' : '0');
                      },
                    ),

                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  flex: 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    SizedBox(
                      height: 45,
                      child: CustomTextFieldWidget(
                        hintText: 'ex_1'.tr,
                        showLabelText: false,
                        inputType: TextInputType.number,
                        controller: maxSnippetController,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    SizedBox(
                      height: 45,
                      child: CustomTextFieldWidget(
                        hintText: 'ex_1'.tr,
                        showLabelText: false,
                        inputType: TextInputType.number,
                        controller: maxVideoPreviewController,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: DropdownButton<String>(
                        value: restController.imagePreviewSelectedType,
                        items: restController.imagePreviewType.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          restController.setImagePreviewType(value!);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),

                  ]),
                ),

              ]),
            ),

          ]),
        );
      });
    });
  }
}

class MetaSeoItem extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool?) callback;
  const MetaSeoItem({super.key, required this.title, required this.value, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: () => callback(!value),
        child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: Dimensions.paddingSizeDefault, width: Dimensions.paddingSizeDefault,
            child: Checkbox(
              checkColor: Theme.of(context).cardColor,
              value: value,
              onChanged: callback,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Flexible(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))),
        ]),
      ),
    );
  }
}

