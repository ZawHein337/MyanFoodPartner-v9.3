import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/controllers/ai_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/widgets/ai_generator_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/ai/widgets/animated_border_container.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/stock_section_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/time_picker_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/variation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/variation_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/type_converter.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, required this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _maxOrderQuantityController = TextEditingController();
  final TextEditingController _stockTextController = TextEditingController();
  TextEditingController _addonController = TextEditingController();
  TextEditingController _nutritionSuggestionController = TextEditingController();
  TextEditingController _allergicIngredientsSuggestionController = TextEditingController();

  final FocusNode _priceNode = FocusNode();
  final FocusNode _discountNode = FocusNode();

  late bool _update;
  Product? _product;
  bool _startTimeError = false;
  bool _endTimeError = false;
  bool _imageError = false;
  bool _hasAttemptedSubmit = false;


  final List<int> _deletedVariationIds = [];
  final List<int> _deletedVariationOptionIds = [];

  final List<TextEditingController> _nameControllerList = [];
  final List<TextEditingController> _descriptionControllerList = [];

  final List<FocusNode> _nameFocusList = [];
  final List<FocusNode> _descriptionFocusList = [];

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  TabController? _tabController;
  final List<Tab> _tabs =[];
  final bool restaurantHalalActive = Get.find<ProfileController>().profileModel!.restaurants![0].isHalalActive!;

  @override
  void initState() {
    super.initState();
    RestaurantController restaurantController = Get.find<RestaurantController>();
    CategoryController categoryController = Get.find<CategoryController>();

    _product = widget.product;
    _update = widget.product != null;

    categoryController.initCategoryData(widget.product);
    restaurantController.getAttributeList(widget.product);
    restaurantController.initNutritionAndAllergicIngredientsData(widget.product);
    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      restaurantController.getVatTaxList();
    }
    restaurantController.clearVatTax();
    restaurantController.clearMetaImage();

    _tabController = TabController(length: _languageList!.length, vsync: this);
    _tabs.addAll(_languageList.map((lang) => Tab(text: lang.value)));

    for(int index = 0; index < _languageList.length; index++) {
      _nameControllerList.add(TextEditingController());
      _descriptionControllerList.add(TextEditingController());
      _nameFocusList.add(FocusNode());
      _descriptionFocusList.add(FocusNode());

      if(widget.product?.translations != null){
        for (var translation in widget.product!.translations!) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _nameControllerList[index] = TextEditingController(text: translation.value ?? '');
          }else if(_languageList[index].key == translation.locale && translation.key == 'description') {
            _descriptionControllerList[index] = TextEditingController(text: translation.value ?? '');
          }
        }
      }
    }

    restaurantController.initializeTags();
    if(_update) {
      restaurantController.setAvailableTimeStarts(startTime: widget.product?.availableTimeStarts, willUpdate: false);
      restaurantController.setAvailableTimeEnds(endTime: widget.product?.availableTimeEnds, willUpdate: false);
      if(_product!.tags != null && _product!.tags!.isNotEmpty){
        for (var tag in _product!.tags!) {
          restaurantController.setTag(tag.tag, willUpdate: false);
        }
      }
      _priceController.text = _product!.price.toString();
      _discountController.text = _product!.discount.toString();
      _maxOrderQuantityController.text = _product!.maxOrderQuantity.toString();
      _stockTextController.text = _product!.itemStock == 0 ? '0' : _product!.itemStock!.toString();
      restaurantController.setDiscountTypeIndex(_product!.discountType == 'percent' ? 0 : 1, false);
      restaurantController.setSelectedDiscountType(_product!.discountType, willUpdate: false);
      _setStockType(_product!.stockType, restaurantController);
      restaurantController.setVeg(_product!.veg == 1, false);
      restaurantController.setExistingVariation(_product!.variations);
      restaurantController.initSetup();
      if(_product?.isHalal == 1) {
        restaurantController.toggleHalal(willUpdate: false);
      }
    }else {
      restaurantController.setSelectedDiscountType('amount', willUpdate: false);
      restaurantController.setDiscountTypeIndex(1, false);
      restaurantController.setEmptyVariationList();
      _product = Product();
      restaurantController.pickImage(false, true);
      restaurantController.setVeg(false, false);
      restaurantController.setStockTypeIndex(0, false);
    }

  }

  void _setStockType(String? type, RestaurantController restaurantController) {
    if(type == 'limited') {
      restaurantController.setStockTypeIndex(1, false);
    } else if (type == 'daily') {
      restaurantController.setStockTypeIndex(2, false);
    } else {
      restaurantController.setStockTypeIndex(0, false);
    }
  }

  void _validateDiscount() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    if (Get.find<RestaurantController>().discountTypeIndex == 0) {
      if (discount > 100) {
        showCustomSnackBar('discount_cannot_be_more_than_100'.tr, isError: true);
        _discountController.text = '100';
      }
    } else if (Get.find<RestaurantController>().discountTypeIndex == 1) {
      if (discount > price) {
        showCustomSnackBar('discount_cannot_be_more_than_price'.tr, isError: true);
        _discountController.text = price.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: widget.product != null ? 'update_food'.tr : 'add_food'.tr),
      
      floatingActionButton: Get.find<SplashController>().configModel!.aiStatus! ? Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          child: CustomAssetImageWidget(image: Images.useAi),
          onPressed: () {
            Get.bottomSheet(
              isScrollControlled: true, useRootNavigator: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
              ),
              AiGeneratorBottomSheet(
              languageList: _languageList,
              tabController: _tabController,
              nameControllerList: _nameControllerList,
              descriptionControllerList: _descriptionControllerList,
              priceController: _priceController,
              discountController: _discountController,
              maxOrderQuantityController: _maxOrderQuantityController,
            ),
            );
          },
        ),
      ) : null,

      body: SafeArea(
        child: GetBuilder<RestaurantController>(builder: (restController) {
          return GetBuilder<AiController>(builder: (aiController) {
            return GetBuilder<CategoryController>(builder: (categoryController) {

              List<int> nutritionSuggestion = [];
              if(restController.nutritionSuggestionList != null) {
                for(int index = 0; index<restController.nutritionSuggestionList!.length; index++) {
                  nutritionSuggestion.add(index);
                }
              }

              List<int> allergicIngredientsSuggestion = [];
              if(restController.allergicIngredientsSuggestionList != null) {
                for(int index = 0; index<restController.allergicIngredientsSuggestionList!.length; index++) {
                  allergicIngredientsSuggestion.add(index);
                }
              }

              if(_update){
                if (restController.vatTaxList != null && restController.selectedVatTaxIdList.isEmpty && widget.product!.taxVatIds != null && widget.product!.taxVatIds!.isNotEmpty) {
                  restController.preloadVatTax(vatTaxList: widget.product!.taxVatIds!);
                }
              }

              if(categoryController.categoryList != null && categoryController.selectedCategoryID != null) {
                if(!categoryController.categoryList!.map((e) => e.id.toString()).toList().contains(categoryController.selectedCategoryID)) {
                  categoryController.setSelectedCategory(null);
                }
              }

              return categoryController.categoryList != null ? Column(children: [

                Expanded(child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('food_info'.tr, style: robotoMedium),

                        Get.find<SplashController>().configModel!.aiStatus! ? InkWell(
                          onTap: () {
                            if(_nameControllerList[_tabController!.index].text.isEmpty) {
                              showCustomSnackBar('food_name_required'.tr);
                            }else{
                              aiController.generateTitleAndDes(
                                title: _nameControllerList[_tabController!.index].text.trim(),
                                langCode: _languageList![_tabController!.index].key!,
                              ).then((value) {
                                if(aiController.titleDesModel != null){
                                  _nameControllerList[_tabController!.index].text = aiController.titleDesModel!.title ?? '';
                                  _descriptionControllerList[_tabController!.index].text = aiController.titleDesModel!.description ?? '';
                                }
                              });
                            }
                          },
                          child: !aiController.titleLoading ? Icon(Icons.auto_awesome, color: Colors.blue) : Shimmer(
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

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.titleLoading,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          SizedBox(
                            height: 40,
                            child: TabBar(
                              tabAlignment: TabAlignment.start,
                              controller: _tabController,
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorWeight: 3,
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Theme.of(context).hintColor,
                              unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                              labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                              labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              tabs: _tabs,
                              onTap: (int ? value) {
                                setState(() {});
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                            child: Divider(height: 0),
                          ),

                          Text('insert_language_wise_product_name_and_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomTextFieldWidget(
                            hintText: 'food_name'.tr,
                            labelText: 'food_name'.tr,
                            controller: _nameControllerList[_tabController!.index],
                            capitalization: TextCapitalization.words,
                            focusNode: _nameFocusList[_tabController!.index],
                            nextFocus: _tabController!.index != _languageList!.length-1 ? _descriptionFocusList[_tabController!.index] : _descriptionFocusList[0],
                            showTitle: false,
                            required: true,
                            validator: (value) => (value == null || value.isEmpty) ? 'enter_food_name'.tr : null,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

                          CustomTextFieldWidget(
                            hintText: 'description'.tr,
                            labelText: 'description'.tr,
                            controller: _descriptionControllerList[_tabController!.index],
                            focusNode: _descriptionFocusList[_tabController!.index],
                            capitalization: TextCapitalization.sentences,
                            maxLines: 3,
                            inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                            nextFocus: _tabController!.index != _languageList.length-1 ? _nameFocusList[_tabController!.index + 1] : null,
                            showTitle: false,
                            required: true,
                            validator: (value) => (value == null || value.isEmpty) ? 'enter_food_description'.tr : null,
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('restaurants_and_category_info'.tr, style: robotoMedium),

                        Get.find<SplashController>().configModel!.aiStatus! ? InkWell(
                          onTap: () {
                            if(_nameControllerList[0].text.isEmpty) {
                              showCustomSnackBar('food_name_required_for_en'.tr);
                            }else if(_descriptionControllerList[0].text.isEmpty){
                              showCustomSnackBar('description_required'.tr);
                            }else{
                              restController.generateAndSetOtherData(
                                title: _nameControllerList[0].text.trim(),
                                description: _descriptionControllerList[0].text.trim(),
                                priceController: _priceController,
                                discountController: _discountController,
                                maxOrderQuantityController: _maxOrderQuantityController,
                              );
                            }
                          },
                          child: !aiController.otherDataLoading ? Icon(Icons.auto_awesome, color: Colors.blue) : Shimmer(
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

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.otherDataLoading,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          ListTile(
                            onTap: () => restController.toggleHalal(),
                            leading: Checkbox(
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              activeColor: Theme.of(context).primaryColor,
                              value: restController.isHalal,
                              onChanged: (bool? isChecked) => restController.toggleHalal(),
                            ),
                            title: Text('is_it_halal'.tr, style: robotoRegular),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            horizontalTitleGap: 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomDropdownButton(
                            hintText: 'category'.tr,
                            isRequired: true,
                            dropdownMenuItems: categoryController.categoryList?.map((item) => DropdownItem<String>(
                              value: item.id.toString(),
                              child: Text(item.name ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            )).toList(),
                            onChanged: (String? value) {
                              categoryController.setSelectedCategory(value!);
                            },
                            selectedValue: categoryController.selectedCategoryID,
                            validator: (value) => (value == null || value.isEmpty) ? 'select_a_category'.tr : null,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

                          categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ?
                          CustomDropdownButton(
                            hintText: categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ? 'sub_category'.tr : 'no_sub_category_found'.tr,
                            dropdownMenuItems: categoryController.subCategoryList?.map((item) => DropdownItem<String>(
                              value: item.id.toString(),
                              child: Text(item.name ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            )).toList(),
                            onChanged: (String? value) {
                              categoryController.setSelectedSubCategory(value!);
                            },
                            selectedValue: categoryController.selectedSubCategoryID,
                            validator: (value) => null,
                          ) : SizedBox(),
                          SizedBox(height: categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty ? Dimensions.paddingSizeOverExtraLarge : 0),

                          if (Get.find<SplashController>().configModel?.restaurantCategoryStatus ?? false) ...[
                            CustomDropdownButton(
                              hintText: 'my_category'.tr,
                              isRequired: categoryController.myCategories != null && categoryController.myCategories!.isNotEmpty,
                              dropdownMenuItems: (categoryController.myCategories != null && categoryController.myCategories!.isNotEmpty)
                                  ? categoryController.myCategories!.map((item) => DropdownItem<String>(
                                      value: item.id.toString(),
                                      child: Text(item.name ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                    )).toList()
                                  : null,
                              onChanged: (categoryController.myCategories != null && categoryController.myCategories!.isNotEmpty)
                                  ? (String? value) => categoryController.setSelectedMyCategory(value)
                                  : null,
                              selectedValue: categoryController.selectedMyCategoryID,
                              validator: (value) => null,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),
                          ],

                          Column(children: [
                            Row(children: [
                              Expanded(
                                flex: 8,
                                child: Autocomplete<int>(
                                  optionsBuilder: (TextEditingValue value) {
                                    if(value.text.isEmpty) {
                                      return const Iterable<int>.empty();
                                    }else {
                                      return nutritionSuggestion.where((nutrition) => restController.nutritionSuggestionList![nutrition]!.toLowerCase().contains(value.text.toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                                    List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        color: Theme.of(context).primaryColorLight,
                                        elevation: 4.0,
                                        child: Container(
                                            color: Theme.of(context).cardColor,
                                            width: MediaQuery.of(context).size.width - 110,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(8.0),
                                              itemCount: result.length,
                                              separatorBuilder: (context, i) {
                                                return const Divider(height: 0,);
                                              },
                                              itemBuilder: (BuildContext context, int index) {
                                                return CustomInkWellWidget(
                                                  onTap: () {
                                                    if(restController.selectedNutritionList!.length >= 5) {
                                                      showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                                                    }else {
                                                      _nutritionSuggestionController.text = '';
                                                      restController.setSelectedNutritionIndex(result[index], true);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                                    child: Text(restController.nutritionSuggestionList![result[index]]!),
                                                  ),
                                                );
                                              },
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                  fieldViewBuilder: (context, controller, node, onComplete) {
                                    _nutritionSuggestionController = controller;
                                    return Container(
                                      height: 50,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                      child: TextField(
                                        controller: controller,
                                        focusNode: node,
                                        onEditingComplete: () {
                                          onComplete();
                                          controller.text = '';
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'nutrition'.tr,
                                          labelText: 'nutrition'.tr,
                                          labelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.8)),
                                          hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.8)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.3),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                          ),
                                          suffixIcon: CustomToolTip(
                                            message: 'specify_the_necessary_keywords_relating_to_energy_values_for_the_item'.tr,
                                            preferredDirection: AxisDirection.up,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  displayStringForOption: (value) => restController.nutritionSuggestionList![value]!,
                                  onSelected: (int value) {
                                    if(restController.selectedNutritionList!.length >= 5) {
                                      showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                                    }else {
                                      _nutritionSuggestionController.text = '';
                                      restController.setSelectedNutritionIndex(value, true);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),

                              Expanded(
                                flex: 2,
                                child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                                  if(restController.selectedNutritionList!.length >= 5) {
                                    showCustomSnackBar('you_can_select_or_add_maximum_5_nutrition'.tr, isError: true);
                                  }else{
                                    if(_nutritionSuggestionController.text.isNotEmpty) {
                                      restController.setNutrition(_nutritionSuggestionController.text.trim());
                                      _nutritionSuggestionController.text = '';
                                    }
                                  }
                                }),
                              ),
                            ]),
                            SizedBox(height: restController.selectedNutritionList != null ? Dimensions.paddingSizeSmall : 0),

                            restController.selectedNutritionList != null ? SizedBox(
                              height: restController.selectedNutritionList!.isNotEmpty ? 40 : 0,
                              child: ListView.builder(
                                itemCount: restController.selectedNutritionList!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    child: Row(children: [

                                      Text(
                                        restController.selectedNutritionList![index]!,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                      ),

                                      InkWell(
                                        onTap: () => restController.removeNutrition(index),
                                        child: Padding(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                          child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                        ),
                                      ),

                                    ]),
                                  );
                                },
                              ),
                            ) : const SizedBox(),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

                          Column(children: [
                            Row(children: [
                              Expanded(
                                flex: 8,
                                child: Autocomplete<int>(
                                  optionsBuilder: (TextEditingValue value) {
                                    if(value.text.isEmpty) {
                                      return const Iterable<int>.empty();
                                    }else {
                                      return allergicIngredientsSuggestion.where((allergicIngredients) => restController.allergicIngredientsSuggestionList![allergicIngredients]!.toLowerCase().contains(value.text.toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                                    List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        color: Theme.of(context).primaryColorLight,
                                        elevation: 4.0,
                                        child: Container(
                                            color: Theme.of(context).cardColor,
                                            width: MediaQuery.of(context).size.width - 110,
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(8.0),
                                              itemCount: result.length,
                                              separatorBuilder: (context, i) {
                                                return const Divider(height: 0,);
                                              },
                                              itemBuilder: (BuildContext context, int index) {
                                                return CustomInkWellWidget(
                                                  onTap: () {
                                                    if(restController.selectedAllergicIngredientsList!.length >= 5) {
                                                      showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                                                    }else {
                                                      _allergicIngredientsSuggestionController.text = '';
                                                      restController.setSelectedAllergicIngredientsIndex(result[index], true);
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                                    child: Text(restController.allergicIngredientsSuggestionList![result[index]]!),
                                                  ),
                                                );
                                              },
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                  fieldViewBuilder: (context, controller, node, onComplete) {
                                    _allergicIngredientsSuggestionController = controller;
                                    return Container(
                                      height: 50,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                      child: TextField(
                                        controller: controller,
                                        focusNode: node,
                                        onEditingComplete: () {
                                          onComplete();
                                          controller.text = '';
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'allergic_ingredients'.tr,
                                          labelText: 'allergic_ingredients'.tr,
                                          hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.8)),
                                          labelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.8)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.3),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                          ),
                                          suffixIcon: CustomToolTip(
                                            message: 'specify_the_ingredients_of_the_item_which_can_make_a_reaction_as_an_allergen'.tr,
                                            preferredDirection: AxisDirection.up,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  displayStringForOption: (value) => restController.allergicIngredientsSuggestionList![value]!,
                                  onSelected: (int value) {
                                    if(restController.selectedAllergicIngredientsList!.length >= 5) {
                                      showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                                    }else {
                                      _allergicIngredientsSuggestionController.text = '';
                                      restController.setSelectedAllergicIngredientsIndex(value, true);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),

                              Expanded(
                                flex: 2,
                                child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                                  if(restController.selectedAllergicIngredientsList!.length >= 5) {
                                    showCustomSnackBar('you_can_select_or_add_maximum_5_allergic_ingredients'.tr, isError: true);
                                  }else{
                                    if(_allergicIngredientsSuggestionController.text.isNotEmpty) {
                                      restController.setAllergicIngredients(_allergicIngredientsSuggestionController.text.trim());
                                      _allergicIngredientsSuggestionController.text = '';
                                    }
                                  }
                                }),
                              ),
                            ]),
                            SizedBox(height: restController.selectedAllergicIngredientsList != null ? Dimensions.paddingSizeSmall : 0),

                            restController.selectedAllergicIngredientsList != null ? SizedBox(
                              height: restController.selectedAllergicIngredientsList!.isNotEmpty ? 40 : 0,
                              child: ListView.builder(
                                itemCount: restController.selectedAllergicIngredientsList!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    ),
                                    child: Row(children: [

                                      Text(
                                        restController.selectedAllergicIngredientsList![index]!,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                      ),

                                      InkWell(
                                        onTap: () => restController.removeAllergicIngredients(index),
                                        child: Padding(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                          child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                        ),
                                      ),

                                    ]),
                                  );
                                },
                              ),
                            ) : const SizedBox(),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

                          Text('food_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                          Row(children: [
                            Expanded(child: RadioGroup<String>(
                              groupValue: restController.isVeg ? 'veg' : 'non_veg',
                              onChanged: (String? value) => restController.setVeg(value == 'veg', true),
                              child: RadioListTile<String>(
                                title: Text('veg'.tr, style: robotoMedium.copyWith(color: restController.isVeg ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor, fontSize: 13)),
                                value: 'veg',
                                contentPadding: EdgeInsets.zero,
                                activeColor: Theme.of(context).primaryColor,
                                dense: false,
                                fillColor: WidgetStateProperty.all(restController.isVeg ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.6)),
                              ),
                            )),

                            Expanded(child: RadioGroup<String>(
                              groupValue: restController.isVeg ? 'veg' : 'non_veg',
                              onChanged: (String? value) => restController.setVeg(value == 'veg', true),
                              child: RadioListTile<String>(
                                title: Text('non_veg'.tr, style: robotoMedium.copyWith(color: !restController.isVeg ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor, fontSize: 13)),
                                value: 'non_veg',
                                contentPadding: EdgeInsets.zero,
                                activeColor: Theme.of(context).primaryColor,
                                fillColor: WidgetStateProperty.all(!restController.isVeg ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.6)),
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            )),

                          ]),
                          SizedBox(height: Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' ? Dimensions.paddingSizeExtraLarge : 0),

                          Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            CustomDropdownButton(
                              dropdownMenuItems: restController.vatTaxList?.map((e) {
                                bool isInVatTaxList = restController.selectedVatTaxNameList.contains(e.name);
                                return DropdownItem<String>(
                                  value: e.name,
                                  child: Row(
                                    children: [
                                      Text('${e.name!} (${e.taxRate}%)', style: robotoRegular),
                                      const Spacer(),
                                      if (isInVatTaxList)
                                        const Icon(Icons.check, color: Colors.green),
                                    ],
                                  ),
                                );
                              }).toList(),
                              showTitle: false,
                              hintText: 'select_vat_tax'.tr,
                              onChanged: (String? value) {
                                final selectedVatTax = restController.vatTaxList?.firstWhere((vatTax) => vatTax.name == value);
                                if (selectedVatTax != null) {
                                  restController.setSelectedVatTax(selectedVatTax.name, selectedVatTax.id, selectedVatTax.taxRate);
                                }
                              },
                              selectedValue: restController.selectedVatTaxName,
                              isRequired: true,
                              validator: (value) {
                                if (restController.selectedVatTaxIdList.isEmpty) {
                                  return 'select_vat_tax'.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: restController.selectedVatTaxNameList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                            Wrap(
                              children: List.generate(restController.selectedVatTaxNameList.length, (index) {
                                final vatTaxName = restController.selectedVatTaxNameList[index];
                                final vatTaxId = restController.selectedVatTaxIdList[index];
                                final taxRate = restController.selectedTaxRateList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  child: Stack(clipBehavior: Clip.none, children: [
                                    FilterChip(
                                      label: Text('$vatTaxName ($taxRate%)'),
                                      selected: false,
                                      onSelected: (bool value) {},
                                    ),

                                    Positioned(
                                      right: -5,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          restController.removeVatTax(vatTaxName, vatTaxId, taxRate);
                                          if (_hasAttemptedSubmit) {
                                            _formKey.currentState?.validate();
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.red, width: 1),
                                          ),
                                          child: const Icon(Icons.close, size: 15, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              }),
                            ),
                          ]) : const SizedBox(),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('addons'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.otherDataLoading,
                        child: Column(children: [

                          GetBuilder<AddonController>(builder: (addonController) {
                            List<int> addons = [];
                            if(addonController.addonList != null) {
                              for(int index=0; index<addonController.addonList!.length; index++) {
                                if(addonController.addonList![index].status == 1 && !restController.selectedAddons!.contains(index)) {
                                  addons.add(index);
                                }
                              }
                            }
                            return Autocomplete<int>(
                              optionsBuilder: (TextEditingValue value) {
                                if(value.text.isEmpty) {
                                  return const Iterable<int>.empty();
                                }else {
                                  return addons.where((addon) => addonController.addonList![addon].name!.toLowerCase().contains(value.text.toLowerCase()));
                                }
                              },
                              fieldViewBuilder: (context, controller, node, onComplete) {
                                _addonController = controller;
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    focusNode: node,
                                    onEditingComplete: () {
                                      onComplete();
                                      controller.text = '';
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'addons'.tr,
                                      labelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                      ),
                                    ),

                                  ),
                                );
                              },
                              optionsViewBuilder: (context, Function(int i) onSelected, data) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: context.width *0.4),
                                    child: ListView.builder(
                                      itemCount: data.length,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => Material(
                                        child: InkWell(
                                          onTap: () => onSelected(data.elementAt(index)),
                                          child: Container(
                                            decoration: BoxDecoration(color: Theme.of(context).cardColor),
                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                                            child: Text(addonController.addonList![data.elementAt(index)].name ?? ''),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              displayStringForOption: (value) => addonController.addonList![value].name!,
                              onSelected: (int value) {
                                _addonController.text = '';
                                restController.setSelectedAddonIndex(value, true);
                                //_addons.removeAt(value);
                              },
                            );
                          }),
                          SizedBox(height: restController.selectedAddons!.isNotEmpty ? Dimensions.paddingSizeDefault : 0),

                          SizedBox(
                            height: restController.selectedAddons!.isNotEmpty ? 40 : 0,
                            child: ListView.builder(
                              itemCount: restController.selectedAddons!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Row(children: [

                                    GetBuilder<AddonController>(builder: (addonController) {
                                      return Text(
                                        addonController.addonList![restController.selectedAddons![index]].name!,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                      );
                                    }),

                                    InkWell(
                                      onTap: () => restController.removeAddon(index),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor),
                                      ),
                                    ),

                                  ]),
                                );
                              },
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('availability'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.otherDataLoading,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          TimePickerWidget(
                            title: 'start_time'.tr,
                            time: restController.availableTimeStarts,
                            showError: _startTimeError,
                            errorMessage: 'pick_start_time'.tr,
                            onTimeChanged: (time) {
                              restController.setAvailableTimeStarts(startTime: time);
                              setState(() => _startTimeError = false);
                            },

                          ),
                          const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),

                          TimePickerWidget(
                            title: 'ends_time'.tr, time: restController.availableTimeEnds,
                            showError: _startTimeError,
                            errorMessage: 'pick_end_time'.tr,
                            onTimeChanged: (time) {
                              restController.setAvailableTimeEnds(endTime: time);
                              setState(() => _endTimeError = false);
                            },
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('price_info'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.otherDataLoading,
                        child: Column(children: [

                          CustomTextFieldWidget(
                            hintText: 'price'.tr,
                            labelText: 'price'.tr,
                            controller: _priceController,
                            focusNode: _priceNode,
                            nextFocus: _discountNode,
                            isAmount: true,
                            showTitle: false,
                            required: true,
                            validator: (value) => (value == null || value.isEmpty) ? 'enter_food_price'.tr : null,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeOverLarge),

                          StackSectionWidget(restaurantController: restController, stockTextController: _stockTextController),
                          const SizedBox(height: Dimensions.paddingSizeOverLarge),

                          Row(children: [

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Container(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 1),
                                ),
                                child: SizedBox(
                                  height: 45,
                                  child: DropdownButton<String>(
                                    icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                                    value: restController.selectedDiscountType,
                                    hint: Text('discount_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),
                                    items: <String>['percent', 'amount'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeDefault)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      restController.setSelectedDiscountType(value);
                                      restController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                                      _validateDiscount();
                                    },
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ),

                            ])),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(child: CustomTextFieldWidget(
                              hintText: 'discount'.tr,
                              labelText: 'discount'.tr,
                              controller: _discountController,
                              focusNode: _discountNode,
                              isAmount: true,
                              showTitle: false,
                              required: true,
                              validator: (value) => (value == null || value.isEmpty) ? 'enter_food_discount'.tr : null,
                              onChanged: (value) => _validateDiscount(),
                            )),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeOverLarge),

                          CustomTextFieldWidget(
                            hintText: 'maximum_order_quantity'.tr,
                            labelText: 'maximum_order_quantity'.tr,
                            controller: _maxOrderQuantityController,
                            isAmount: true,
                            showTitle: false,
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('tag'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      AnimatedBorderContainer(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        isLoading: aiController.otherDataLoading,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Row(children: [

                            Expanded(
                              flex: 8,
                              child: CustomTextFieldWidget(
                                hintText: 'tag'.tr,
                                labelText: 'tag'.tr,
                                showTitle: false,
                                controller: _tagController,
                                inputAction: TextInputAction.done,
                                onSubmit: (name){
                                  if(name.isNotEmpty) {
                                    restController.setTag(name);
                                    _tagController.text = '';
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Expanded(
                              flex: 2,
                              child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                                if(_tagController.text.isNotEmpty) {
                                  restController.setTag(_tagController.text.trim());
                                  _tagController.text = '';
                                }
                              }),
                            ),

                          ]),
                          SizedBox(height: restController.tagList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                          restController.tagList.isNotEmpty ? SizedBox(
                            height: 40,
                            child: ListView.builder(
                              shrinkWrap: true, scrollDirection: Axis.horizontal,
                              itemCount: restController.tagList.length,
                              itemBuilder: (context, index){
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: Center(child: Row(children: [

                                    Text(restController.tagList[index]!, style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    InkWell(onTap: () => restController.removeTag(index), child: Icon(Icons.clear, size: 18, color: Theme.of(context).hintColor)),

                                  ])),
                                );
                              },
                            ),
                          ) : const SizedBox(),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      VariationViewWidget(
                        deletedVariationId: (int? value) {
                          if(value != null) {
                            _deletedVariationIds.add(value);
                          }
                        },
                        deletedVariationOptionId: (int? value) {
                          if(value != null) {
                            _deletedVariationOptionIds.add(value);
                          }
                        },
                        generateVariation: () {
                          if(_nameControllerList[0].text.isEmpty) {
                            showCustomSnackBar('food_name_required_for_en'.tr);
                          }else if(_descriptionControllerList[0].text.isEmpty){
                            showCustomSnackBar('description_required'.tr);
                          }else{
                            restController.generateAndSetVariationData(
                              title: _nameControllerList[0].text.trim(),
                              description: _descriptionControllerList[0].text.trim(),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('image'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: _imageError ? Border.all(color: Colors.red.withValues(alpha: 0.5), width: 1) : null,
                          boxShadow: [BoxShadow(color: _imageError ? Colors.red.withValues(alpha: 0.5) : Colors.black12, spreadRadius: 0, blurRadius: 5)],
                        ),
                        child: Column(children: [

                          Align(alignment: Alignment.center, child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: restController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                                restController.pickedLogo!.path, width: 150, height: 150, fit: BoxFit.cover,
                              ) : Image.file(
                                File(restController.pickedLogo!.path), width: 150, height: 150, fit: BoxFit.cover,
                              ) : _product!.imageFullUrl != null ? CustomImageWidget(
                                image: _product!.imageFullUrl ?? '',
                                height: 150, width: 150, fit: BoxFit.cover,
                              ): SizedBox(
                                width: 150, height: 150,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(CupertinoIcons.camera_fill, color: Theme.of(context).hintColor.withValues(alpha: 0.5), size: 38),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text('upload_item_image'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall)),

                                ]),
                              ),
                            ),
                            Positioned(
                              bottom: 0, right: 0, top: 0, left: 0,
                              child: InkWell(
                                onTap: () => restController.pickImage(true, false),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: Theme.of(context).primaryColor,
                                    strokeWidth: 1,
                                    strokeCap: StrokeCap.butt,
                                    dashPattern: const [5, 5],
                                    padding: const EdgeInsets.all(0),
                                    radius: const Radius.circular(Dimensions.radiusDefault),
                                  ),
                                  child: Center(
                                    child: Visibility(
                                      visible: restController.pickedLogo != null || _product!.imageFullUrl != null ? true : false,
                                      child: Container(
                                        padding: const EdgeInsets.all(25),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2, color: Colors.white),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.camera_alt, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          SizedBox(
                            width: 150,
                            child: Text(
                              _imageError ? 'please_upload_food_image_less_than_2_mb'.tr : 'upload_jpg_png_gif_maximum_2_mb'.tr,
                              style: robotoRegular.copyWith(color: _imageError ? Colors.red : Theme.of(context).hintColor.withValues(alpha: 0.6), fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ]),
                      ),

                    ]),
                  ),
                )),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: CustomButtonWidget(
                    buttonText: _update ? 'update'.tr : 'submit'.tr,
                    isLoading: restController.isLoading,
                    height: 50,
                    onPressed: () async {

                      String price = _priceController.text.trim();
                      String discount = _discountController.text.trim();
                      int itemStock = 0;
                      try{
                        itemStock = int.parse(_stockTextController.text.trim());
                      } catch(e) {
                        itemStock = 0;
                      }
                      int maxOrderQuantity = _maxOrderQuantityController.text.isNotEmpty ? int.parse(_maxOrderQuantityController.text) : 0;
                      // bool variationNameEmpty = false;
                      // bool variationMinMaxEmpty = false;
                      bool variationOptionNameEmpty = false;
                      bool variationOptionPriceEmpty = false;
                      bool variationOptionStockEmpty = false;
                      bool variationMinLessThenZero = false;
                      bool variationMaxSmallThenMin = false;
                      bool variationMaxBigThenOptions = false;

                      for(VariationModel variationModel in restController.variationList!){
                         if(!variationModel.isSingle){
                           if(int.parse(variationModel.minController!.text) < 1){
                            variationMinLessThenZero = true;
                          }else if(int.parse(variationModel.maxController!.text) < int.parse(variationModel.minController!.text)){
                            variationMaxSmallThenMin = true;
                          }else if(int.parse(variationModel.maxController!.text) > variationModel.options!.length){
                            variationMaxBigThenOptions = true;
                          }
                        }else {
                          for(Option option in variationModel.options!){
                            if(option.optionNameController!.text.isEmpty){
                              variationOptionNameEmpty = true;
                            }else if(option.optionPriceController!.text.isEmpty){
                              variationOptionPriceEmpty = true;
                            } else if(option.optionStockController!.text.isEmpty && restController.stockTypeIndex != 0) {
                              variationOptionStockEmpty = true;
                            }
                          }
                        }
                      }

                      bool defaultDataNull = false;
                      for(int index=0; index<_languageList.length; index++) {
                        if(_languageList[index].key == 'en') {
                          if (_nameControllerList[index].text.trim().isEmpty || _descriptionControllerList[index].text.trim().isEmpty) {
                            defaultDataNull = true;
                          }
                          break;
                        }
                      }
                      bool isFormValid = _formKey.currentState!.validate();
                      setState(() {
                        _hasAttemptedSubmit = true;
                        _startTimeError = restController.availableTimeStarts == null;
                        _endTimeError   = restController.availableTimeEnds == null;
                        _imageError     = restController.pickedLogo == null && _product!.imageFullUrl == null;
                      });
                      if(_startTimeError || _endTimeError || _imageError || !isFormValid) {
                        return;

                     /*} else if(defaultDataNull) {
                        showCustomSnackBar('enter_data_for_english'.tr);
                      }else if(categoryController.selectedCategoryID == null) {
                        showCustomSnackBar('select_a_category'.tr);
                      }else if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise' && restController.selectedVatTaxIdList.isEmpty) {
                        showCustomSnackBar('select_vat_tax'.tr);
                      }  if(restController.availableTimeStarts == null) {
                        showCustomSnackBar('pick_start_time'.tr);
                      }else if(restController.availableTimeEnds == null) {
                        showCustomSnackBar('pick_end_time'.tr);
                      }else if(price.isEmpty) {
                        showCustomSnackBar('enter_food_price'.tr);
                      }else if(_stockTextController.text.isEmpty && restController.stockTypeIndex != 0){
                        showCustomSnackBar('enter_the_item_stock'.tr);
                      }else if(discount.isEmpty) {
                        showCustomSnackBar('enter_food_discount'.tr);
                      }else if(variationNameEmpty){
                        showCustomSnackBar('enter_name_for_every_variation'.tr);
                      }else if(variationMinMaxEmpty){
                        showCustomSnackBar('enter_min_max_for_every_multipart_variation'.tr);
                      }else if(variationOptionNameEmpty){
                        showCustomSnackBar('enter_option_name_for_every_variation'.tr);
                      }else if(variationOptionPriceEmpty){
                        showCustomSnackBar('enter_option_price_for_every_variation'.tr);
                      }else if(variationOptionStockEmpty){
                        showCustomSnackBar('enter_option_stock_for_every_variation'.tr);*/
                      }else if(variationMinLessThenZero){
                        showCustomSnackBar('minimum_type_cant_be_less_then_1'.tr);
                      }else if(variationMaxSmallThenMin){
                        showCustomSnackBar('max_type_cant_be_less_then_minimum_type'.tr);
                      }else if(variationMaxBigThenOptions){
                        showCustomSnackBar('max_type_length_should_not_be_more_then_options_length'.tr);
                      } else if(maxOrderQuantity < 0) {
                        showCustomSnackBar('maximum_item_order_quantity_can_not_be_negative'.tr);
                      } else if((Get.find<SplashController>().configModel?.restaurantCategoryStatus ?? false) && categoryController.myCategories != null && categoryController.myCategories!.isNotEmpty && categoryController.selectedMyCategoryID == null) {
                        showCustomSnackBar('select_restaurant_category'.tr);
                      } else if(restController.pickedLogo != null && (await File(restController.pickedLogo!.path).length() > 2000000)) {
                        showCustomSnackBar('please_upload_food_image_less_than_2_mb'.tr);
                      }else {
                        _product!.veg = restController.isVeg ? 1 : 0;
                        _product!.isHalal = restController.isHalal ? 1 : 0;
                        _product!.price = double.parse(price);
                        _product!.discount = double.parse(discount);
                        _product!.discountType = restController.discountTypeIndex == 0 ? 'percent' : 'amount';
                        _product!.maxOrderQuantity = maxOrderQuantity;
                        _product!.availableTimeStarts = restController.availableTimeStarts;
                        _product!.availableTimeEnds = restController.availableTimeEnds;
                        _product!.categoryIds = [];
                        _product!.categoryIds!.add(CategoryIds(id: categoryController.selectedCategoryID));
                        if(categoryController.selectedSubCategoryID != null) {
                          _product!.categoryIds!.add(CategoryIds(id: categoryController.selectedSubCategoryID));
                        }
                        _product!.addOns = [];
                        for (var index in restController.selectedAddons!) {
                          _product!.addOns!.add(Get.find<AddonController>().addonList![index]);
                        }
                        _product!.itemStock = itemStock == 0 ? null : itemStock;
                        _product!.stockType = restController.stockTypeIndex == 0 ? 'unlimited' : restController.stockTypeIndex == 1 ? 'limited' : 'daily';
                        _product!.variations = [];
                        if(restController.variationList!.isNotEmpty){
                          for (var variation in restController.variationList!) {
                            List<VariationOption> values = [];
                            for (var option in variation.options!) {
                              values.add(VariationOption(
                                level: option.optionNameController!.text.trim(),
                                optionPrice: option.optionPriceController!.text.trim(),
                                totalStock: option.optionStockController!.text.trim() == '' ? '0' : option.optionStockController!.text.trim(),
                                optionId: option.optionId,
                              ));
                            }

                            _product!.variations!.add(Variation(
                              id: variation.id,
                              name: variation.nameController!.text.trim(), type: variation.isSingle ? 'single' : 'multi', min: variation.minController!.text.trim(),
                              max: variation.maxController!.text.trim(), required: variation.required ? 'on' : 'off', variationValues: values),
                            );
                          }
                        }

                        if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
                          _product?.taxVatIds = [];
                          _product?.taxVatIds = restController.selectedVatTaxIdList;
                        }
                        _product!.restaurantCategoryId = categoryController.selectedMyCategoryID != null
                            ? int.tryParse(categoryController.selectedMyCategoryID!)
                            : null;

                        List<Translation> translations = [];
                        for(int index=0; index<_languageList.length; index++) {
                          translations.add(Translation(
                            locale: _languageList[index].key, key: 'name',
                            value: _nameControllerList[index].text.trim().isNotEmpty ? _nameControllerList[index].text.trim() : _nameControllerList[0].text.trim(),
                          ));
                          translations.add(Translation(
                            locale: _languageList[index].key, key: 'description',
                            value: _descriptionControllerList[index].text.trim().isNotEmpty ? _descriptionControllerList[index].text.trim() : _descriptionControllerList[0].text.trim(),
                          ));
                        }
                        _product!.translations = [];
                        _product!.translations!.addAll(translations);

                        restController.addProduct(_product!, widget.product == null, _deletedVariationIds, _deletedVariationOptionIds).then((value){
                          Get.offNamed(RouteHelper.getAllProductsRoute());
                        });
                      }
                    },
                  ),
                ),

              ]) : const Center(child: CircularProgressIndicator());
            });
          });
        }),
      ),
    );
  }
}
 