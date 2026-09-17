import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdditionalDataSectionWidget extends StatelessWidget {
  final AuthController authController;
  final ScrollController scrollController;
  const AdditionalDataSectionWidget({super.key, required this.authController, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: authController.dataList!.length,
        itemBuilder: (context, index) {

          bool showTextField = authController.dataList![index].fieldType == 'text' || authController.dataList![index].fieldType == 'number' || authController.dataList![index].fieldType == 'email' || authController.dataList![index].fieldType == 'phone';
          bool showDate = authController.dataList![index].fieldType == 'date';
          bool showCheckBox = authController.dataList![index].fieldType == 'check_box';
          bool showFile = authController.dataList![index].fieldType == 'file';

          return Padding(
            padding: EdgeInsets.only(bottom: index == authController.dataList!.length - 1 ? 0 : Dimensions.paddingSizeExtraLarge),
            child: showTextField ? CustomTextFieldWidget(
              hintText: authController.dataList![index].placeholderData ?? '',
              labelText: authController.camelCaseToSentence(authController.dataList![index].placeholderData ?? ''),
              controller: authController.additionalList![index],
              inputType: authController.dataList![index].fieldType == 'number' ? TextInputType.number
                  : authController.dataList![index].fieldType == 'phone' ? TextInputType.phone
                  : authController.dataList![index].fieldType == 'email' ? TextInputType.emailAddress
                  : TextInputType.text,
              required: authController.dataList![index].isRequired == 1,
              capitalization: TextCapitalization.words,
            ) : showDate ? Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
              ),
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              child: Row(children: [

                Expanded(child: Text(authController.additionalList![index] ?? 'not_set_yet'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor))),

                IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                      authController.setAdditionalDate(index, formattedDate);
                    }
                  },
                  icon: Icon(Icons.date_range_sharp, color: Theme.of(context).hintColor),
                ),

              ]),

            ) : showCheckBox ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text(authController.camelCaseToSentence(authController.dataList![index].inputData ?? ''), style: robotoMedium),

                Text(
                  authController.dataList![index].isRequired == 1 ? ' *' : '',
                  style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ]),

              ListView.builder(
                itemCount: authController.dataList![index].checkData!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) {
                  return Row(children: [

                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: authController.additionalList![index][i] == authController.dataList![index].checkData![i],
                      onChanged: (bool? isChecked) {
                        authController.setAdditionalCheckData(index, i, authController.dataList![index].checkData![i]);
                      }
                    ),

                    Text(authController.dataList![index].checkData![i], style: robotoRegular),

                  ]);

                  },
              ),

            ]) : showFile ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text(authController.camelCaseToSentence(authController.dataList![index].inputData ?? ''), style: robotoMedium),

                Text(
                  authController.dataList![index].isRequired == 1 ? ' *' : '',
                  style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: authController.additionalList![index].length + 1,
                shrinkWrap: true,
                itemBuilder: (context, i) {

                  FilePickerResult? file = i == authController.additionalList![index].length ? null : authController.additionalList![index][i];
                  bool isImage = false;
                  String fileName = '';
                  bool canAddMultipleImage = authController.dataList![index].mediaData!.uploadMultipleFiles == 1;
                  if(file != null) {
                    fileName = file.files.single.path!.split('/').last;
                    isImage = file.files.single.path!.contains('jpg') || file.files.single.path!.contains('jpeg') || file.files.single.path!.contains('png');
                  }

                  if(i == authController.additionalList![index].length && (authController.additionalList![index].length < (canAddMultipleImage ? 6 : 1))) {
                    return Align(alignment: Alignment.center, child: Stack(children: [

                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: SizedBox(
                            width: context.width, height: 140,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              const CustomAssetImageWidget(image: Images.documentIcon, height: 30, width: 30),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'click_to_add'.tr,
                                style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),

                            ]),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () async {
                            await authController.pickFile(index, authController.dataList![index].mediaData!);
                          },
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: Theme.of(context).hintColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              radius: const Radius.circular(Dimensions.radiusDefault),
                            ),
                            child: SizedBox(width: context.width, height: 140),
                          ),
                        ),
                      ),

                    ]));
                  }

                  return file != null ? Stack(children: [

                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: Theme.of(context).hintColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [5, 5],
                        padding: const EdgeInsets.all(0),
                        radius: const Radius.circular(Dimensions.radiusDefault),
                      ),
                      child: SizedBox(
                        width: context.width, height: 140,
                        child: Center(
                          child: isImage ? ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: Image.file(
                              File(file.files.single.path!), width: context.width, height: 140, fit: BoxFit.cover,
                            ),
                          ) : Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.asset(fileName.contains('doc') ? Images.documentIcon : Images.pdfIcon, height: 20, width: 20, fit: BoxFit.contain),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(
                                fileName,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: (){
                          authController.removeAdditionalFile(index, i);
                        },
                        icon: const Icon(CupertinoIcons.delete_simple, color: Colors.red),
                      ),
                    ),

                  ]) : const SizedBox();
                  },
              ),
            ]) : const SizedBox(),
          );
        },
      ),
    );
  }
}