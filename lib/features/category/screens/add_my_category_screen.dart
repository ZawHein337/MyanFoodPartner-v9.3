import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/screens/assign_my_category_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AddMyCategoryScreen extends StatefulWidget {
  final CategoryModel? category;
  const AddMyCategoryScreen({super.key, this.category});

  @override
  State<AddMyCategoryScreen> createState() => _AddMyCategoryScreenState();
}

class _AddMyCategoryScreenState extends State<AddMyCategoryScreen> with TickerProviderStateMixin {

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  final List<TextEditingController> _nameControllers = [];
  final List<FocusNode> _nameNodes = [];
  final List<Tab> _tabs = [];
  TabController? _tabController;
  late bool _update;

  @override
  void initState() {
    super.initState();
    _update = widget.category != null;
    _tabController = TabController(length: _languageList!.length, initialIndex: 0, vsync: this);

    for (int i = 0; i < _languageList.length; i++) {
      _nameControllers.add(TextEditingController(
        text: _update && i == 0 ? (widget.category!.name ?? '') : '',
      ));
      _nameNodes.add(FocusNode());
      _tabs.add(Tab(text: i == 0 ? 'default'.tr : _languageList[i].value));
    }

    final controller = Get.find<CategoryController>();
    // Clear any leftover priority/image from a previous session before the first
    // build, so opening "add new" never shows stale data.
    controller.resetMyCategoryForm();
    if (_update) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setSelectedPriority(controller.priorityKeyFromInt(widget.category!.priority));
       // controller.setSelectedTaxRate(widget.category!.taxRate);
      });
      // The list API returns only the default name; the per-language names come
      // from the details endpoint, so fetch them and fill the language tabs.
      _loadCategoryTranslations(controller);
    }
  }

  Future<void> _loadCategoryTranslations(CategoryController controller) async {
    final CategoryDetailsModel? details = await controller.getCategoryDetails(widget.category!.id!);
    if (!mounted || details?.translations == null) {
      return;
    }
    for (final t in details!.translations!) {
      final idx = _languageList!.indexWhere((l) => l.key == t.locale);
      if (idx != -1 && t.key == 'name' && _nameControllers[idx].text.isEmpty) {
        _nameControllers[idx].text = t.value ?? '';
      }
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) { c.dispose(); }
    for (final n in _nameNodes) { n.dispose(); }
    _tabController?.dispose();
    super.dispose();
  }

  String get _nameHint {
    final isDefault = _tabController!.index == 0;
    final label = isDefault ? 'default'.tr : (_languageList?[_tabController!.index].value ?? '');
    return '${'name'.tr} ($label)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: _update ? 'update_my_category'.tr : 'add_my_category'.tr),

      body: GetBuilder<CategoryController>(builder: (controller) {
        return Column(children: [

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomCard(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    if (!_update) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E7),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: const Color(0xFFFFE082), width: 1),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            height: 28, width: 28,
                            decoration: const BoxDecoration(color: Color(0xFFFFA726), shape: BoxShape.circle),
                            child: const Icon(Icons.info_outline, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Text(
                              'my_category_list_note'.tr,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF7A5C00)),
                            ),
                          ),
                        ]),
                      ),
                    ],

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('category_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text('setup_category_information_here'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      CustomCard(
                        color:Color(0xffF7F8FA),
                        showShadow: false,
                        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
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
                                labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                indicatorPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                tabs: _tabs,
                                onTap: (_) => setState(() {}),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                              child: Divider(height: 0),
                            ),

                            CustomTextFieldWidget(
                              hintText: _nameHint,
                              labelText: '$_nameHint *',
                              controller: _nameControllers[_tabController!.index],
                              focusNode: _nameNodes[_tabController!.index],
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              showTitle: false,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                          ],
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      CustomCard(
                        color:Color(0xffF7F8FA),
                        showShadow: false,
                        borderColor: Colors.transparent,
                        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownButton(
                              hintText: 'select_priority'.tr,
                              isRequired: true,
                              items: controller.priorityList,
                              selectedValue: controller.selectedPriority,
                              onChanged: controller.setSelectedPriority,
                            ),

                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            CustomCard(
                              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'category_image'.tr,
                                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                                      children: [
                                        TextSpan(text: ' *', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.error)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Text('jpg_jpeg_png_less_2mb_ratio_1_1'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

                                  const SizedBox(height: Dimensions.paddingSizeLarge),
                                  Center(
                                    child: InkWell(
                                      onTap: controller.pickCategoryImage,
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          color: Theme.of(context).primaryColor,
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.butt,
                                          dashPattern: const [5, 5],
                                          padding: const EdgeInsets.all(0),
                                          radius: const Radius.circular(Dimensions.radiusDefault),
                                        ),
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: controller.pickedCategoryImage != null ? ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            child: GetPlatform.isWeb
                                                ? Image.network(controller.pickedCategoryImage!.path, fit: BoxFit.cover)
                                                : Image.file(File(controller.pickedCategoryImage!.path), fit: BoxFit.cover),
                                          ) : (widget.category?.imageFullUrl?.isNotEmpty ?? false) ? ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            child: CustomImageWidget(image: widget.category!.imageFullUrl!, height: 100, width: 100, fit: BoxFit.cover),
                                          ) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(CupertinoIcons.photo, size: 28, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                            Text('click_to_add'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),

                    ]),

                  ]),
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: CustomButtonWidget(
              buttonText: _update ? 'update'.tr : 'submit'.tr,
              isLoading: controller.isSubmitLoading,
              onPressed: controller.isSubmitLoading ? null : () => _submit(controller),
            ),
          ),

        ]);
      }),
    );
  }

  void _submit(CategoryController controller) {
    final name = _nameControllers[0].text.trim();
    if (name.isEmpty) {
      showCustomSnackBar('enter_category_name'.tr);
      return;
    }
    if (controller.selectedPriority == null) {
      showCustomSnackBar('select_priority'.tr);
      return;
    }
    final bool hasExistingImage = widget.category?.imageFullUrl?.isNotEmpty ?? false;
    if (controller.pickedCategoryImage == null && !hasExistingImage) {
      showCustomSnackBar('please_add_category_image'.tr);
      return;
    }

    final List<Translation> translations = [];
    for (int i = 0; i < _languageList!.length; i++) {
      translations.add(Translation(
        locale: _languageList[i].key,
        key: 'name',
        value: _nameControllers[i].text.trim().isNotEmpty
            ? _nameControllers[i].text.trim()
            : name,
      ));
    }

    final String priorityValue = controller.priorityValueFromKey(controller.selectedPriority!);
    if (_update) {
      controller.updateStoreCategoryApi(widget.category!.id!, translations, priorityValue);
    } else {
      controller.addStoreCategoryApi(translations, priorityValue, onCreated: (id, name) {
        AssignMyCategoryScreen.show(categoryId: id, categoryName: name);
      });
    }
  }
}
