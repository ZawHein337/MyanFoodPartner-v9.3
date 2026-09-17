import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/controllers/ai_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/widgets/animated_border_container.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VariationViewWidget extends StatelessWidget {
  final Function(int?) deletedVariationId;
  final Function(int?) deletedVariationOptionId;
  final Function()? generateVariation;
  const VariationViewWidget({super.key, required this.deletedVariationId, required this.deletedVariationOptionId, this.generateVariation});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<AiController>(builder: (aiController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Row(children: [
              Text('food_variations'.tr, style: robotoMedium),

              Text(' (${'optional'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
            ]),

            Get.find<SplashController>().configModel!.aiStatus! ? InkWell(
              onTap: generateVariation,
              child: !aiController.variationDataLoading ? Icon(Icons.auto_awesome, color: Colors.blue) : Shimmer(
                duration: const Duration(seconds: 2),
                color: Colors.blue,
                child: Row(children: [
                  Icon(Icons.auto_awesome, color: Colors.blue),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text('generating'.tr, style: robotoBold.copyWith(color: Colors.blue)),
                ]),
              ),
            ) : const SizedBox(),

          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          restController.variationList!.isNotEmpty ? ListView.builder(
            itemCount: restController.variationList!.length,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.only(bottom: restController.variationList!.length - 1 == index ? 0 : Dimensions.paddingSizeLarge),
              child: AnimatedBorderContainer(
                isLoading: aiController.variationDataLoading,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                child: Column(children: [

                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        if(restController.variationList![index].id != null) {
                          deletedVariationId(int.parse(restController.variationList![index].id!));
                        }
                        restController.removeVariation(index);
                      },
                      child: Icon(Icons.clear, color: Theme.of(context).hintColor),
                    ),
                  ),

                  Column(children: [

                    SizedBox(height: restController.variationList!.length > 1 ? 0 : Dimensions.paddingSizeLarge),
                    Row(children: [

                      Expanded(
                        flex: 5,
                        child: CustomTextFieldWidget(
                          hintText: 'name'.tr,
                          labelText: 'name'.tr,
                          showTitle: false,
                          controller: restController.variationList![index].nameController,
                          borderColor: Theme.of(context).hintColor,
                          required: true,
                          validator: (value) => (value == null || value.isEmpty) ? 'enter_name_for_every_variation'.tr : null,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        flex: 3,
                        child: Row(children: [

                          Checkbox(
                            value: restController.variationList![index].required,
                            onChanged: (bool? value){
                              restController.setVariationRequired(index);
                            },
                            activeColor: Theme.of(context).primaryColor,
                            side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          ),
                          Text('required'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                        ]),
                      ),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('select_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Row(children: [

                        InkWell(
                          onTap: () =>  restController.changeSelectVariationType(index),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            RadioGroup(
                              groupValue: restController.variationList![index].isSingle,
                              onChanged: (bool? value){
                                restController.changeSelectVariationType(index);
                              },
                              child: Radio(
                                value: true,
                                activeColor: Theme.of(context).primaryColor,
                                fillColor: WidgetStateProperty.all(restController.variationList![index].isSingle ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.6)),
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text('single'.tr, style: robotoMedium.copyWith(color: restController.variationList![index].isSingle ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor, fontSize: 13)),
                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeOverExtraLarge),

                        InkWell(
                          onTap: () =>  restController.changeSelectVariationType(index),
                          child: Row(children: [
                            RadioGroup(
                              groupValue: restController.variationList![index].isSingle,
                              onChanged: (bool? value){
                                restController.changeSelectVariationType(index);
                              },
                              child: Radio(
                                value: false,
                                activeColor: Theme.of(context).primaryColor,
                                fillColor: WidgetStateProperty.all(!restController.variationList![index].isSingle ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.6)),
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text('multiple'.tr, style: robotoMedium.copyWith(color: !restController.variationList![index].isSingle ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor, fontSize: 13)),
                          ]),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ]),

                    Visibility(
                      visible: !restController.variationList![index].isSingle,
                      child: Row(children: [

                        Flexible(
                          child: CustomTextFieldWidget(
                            hintText: 'min'.tr,
                            labelText: 'min'.tr,
                            showTitle: false,
                            inputType: TextInputType.number,
                            controller: restController.variationList![index].minController,
                            borderColor: Theme.of(context).hintColor,
                            required: true,
                            validator: (value) => (value == null || value.isEmpty) ? 'enter_min_max_for_every_multipart_variation'.tr : null,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Flexible(
                          child: CustomTextFieldWidget(
                            hintText: 'max'.tr,
                            labelText: 'max'.tr,
                            inputType: TextInputType.number,
                            showTitle: false,
                            controller: restController.variationList![index].maxController,
                            borderColor: Theme.of(context).hintColor,
                            required: true,
                            validator: (value) => (value == null || value.isEmpty) ? 'enter_min_max_for_every_multipart_variation'.tr : null,
                          ),
                        ),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      ListView.builder(
                        itemCount: restController.variationList![index].options!.length,
                        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {

                          if(restController.stockTypeIndex == 0) {
                            restController.variationList![index].options![i].optionStockController?.text = '';
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: restController.variationList![index].options!.length - 1 == i ? 0 : Dimensions.paddingSizeLarge),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Row(children: [

                                Flexible(
                                  flex: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(Dimensions.radiusDefault),
                                        bottomLeft: Radius.circular(Dimensions.radiusDefault),
                                      ),
                                    ),
                                    child: Column(children: [

                                      Row(children: [

                                        Flexible(
                                          child: CustomTextFieldWidget(
                                            hintText: 'option_name'.tr,
                                            labelText: 'option_name'.tr,
                                            showTitle: false,
                                            controller: restController.variationList![index].options![i].optionNameController,
                                            borderColor: Theme.of(context).hintColor,
                                            required: true,
                                            validator: (value) => (value == null || value.isEmpty) ? 'enter_option_name_for_every_variation'.tr : null,
                                          ),
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Flexible(
                                          child: CustomTextFieldWidget(
                                            hintText: 'additional_price'.tr,
                                            labelText: 'additional_price'.tr,
                                            showTitle: false,
                                            controller: restController.variationList![index].options![i].optionPriceController,
                                            inputType: TextInputType.number,
                                            inputAction: TextInputAction.done,
                                            borderColor: Theme.of(context).hintColor,
                                            required: true,
                                            validator: (value) => (value == null || value.isEmpty) ? 'enter_option_price_for_every_variation'.tr : null,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),

                                      CustomTextFieldWidget(
                                        hintText: restController.stockTypeIndex == 0 ? 'unlimited'.tr : 'stock *'.tr,
                                        showTitle: false,
                                        controller: restController.variationList![index].options![i].optionStockController,
                                        inputType: TextInputType.phone,
                                        inputAction: TextInputAction.done,
                                        isEnabled: restController.stockTypeIndex == 0 ? false : true,
                                        required: restController.stockTypeIndex == 0 ? false : true,
                                        validator: (value) => restController.stockTypeIndex != 0 ? (value == null || value.isEmpty) ? 'enter_option_stock_for_every_variation'.tr : null : null,
                                        onChanged: (value) {
                                          // int.parse(widget.restController.variationList![index].options![i].optionStockController!.text.trim());
                                          // _calculateOptionStock();
                                        },
                                      ),
                                    ]),
                                  ),
                                ),

                                Flexible(flex: 1, child: Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                  child: restController.variationList![index].options!.length > 1 ? IconButton(
                                    icon: Icon(Icons.clear, color: Theme.of(context).primaryColor),
                                    onPressed: () {
                                      if(restController.variationList![index].options![i].optionId != null) {
                                        deletedVariationOptionId(int.parse(restController.variationList![index].options![i].optionId!));
                                      }
                                      restController.removeOptionVariation(index, i);
                                      // _calculateOptionStock();
                                    }
                                  ) : const SizedBox(),
                                )),

                              ]),

                            ]),
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      InkWell(
                        onTap: (){
                          restController.addOptionVariation(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.6)),
                          ),
                          child: Text('add_new_option'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                        ),
                      ),

                    ]),
                  ]),

                ]),
              ),
            );
          }) : const SizedBox(),

          Visibility(
            visible: restController.variationList!.isEmpty,
            child: AnimatedBorderContainer(
              isLoading: aiController.variationDataLoading,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
              child: InkWell(
                onTap: () {
                  restController.addVariation();
                },
                child: Container(
                  width: context.width,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  child: Column(children: [

                    const Icon(Icons.add, size: 24),

                    Text('add_variation'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                  ]),
                ),
              ),
            ),
          ),

          Visibility(
            visible: restController.variationList!.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  restController.addVariation();
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add, color: Theme.of(context).cardColor),
                  Text('add_new_variation'.tr, style: robotoRegular.copyWith(color: Theme.of(context).cardColor)),
                ]),
              ),
            ),
          ),

        ]);
      });
    });
  }
}