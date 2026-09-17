import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCouponScreen extends StatefulWidget {
  final CouponBodyModel? coupon;
  const AddCouponScreen({super.key, this.coupon});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> with TickerProviderStateMixin{

  final List<TextEditingController> _titleController = [];
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();
  final TextEditingController _minPurchaseController = TextEditingController();

  final List<FocusNode> _titleNode = [];
  final FocusNode _codeNode = FocusNode();
  final FocusNode _limitNode = FocusNode();
  final FocusNode _minNode = FocusNode();
  final FocusNode _discountNode = FocusNode();
  final FocusNode _maxDiscountNode = FocusNode();
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  TabController? _tabController;
  final List<Tab> _tabs =[];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _languageList!.length, vsync: this);
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _titleController.add(TextEditingController());
      _titleNode.add(FocusNode());
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    if(widget.coupon != null){
      for (int index = 0; index < _languageList.length; index++) {
        if(widget.coupon!.translations!.isNotEmpty) {
          if (widget.coupon != null && widget.coupon!.translations != null) {
            var translation = widget.coupon!.translations!.firstWhere((element) => element.locale == _languageList[index].key, orElse: () => Translation(value: widget.coupon!.title));
            _titleController[index].text = translation.value ?? '';
          }
        } else {
          _titleController.add(TextEditingController());
        }
        _titleNode.add(FocusNode());
      }
      _codeController.text = widget.coupon!.code!;
      _limitController.text = widget.coupon!.limit?.toString()??'0';
      _startDateController.text = widget.coupon!.startDate.toString();
      _expireDateController.text = widget.coupon!.expireDate.toString();
      _discountController.text = widget.coupon!.discount.toString();
      _maxDiscountController.text = widget.coupon!.maxDiscount.toString();
      _minPurchaseController.text = widget.coupon!.minPurchase.toString();
      Get.find<CouponController>().setCouponTypeIndex(widget.coupon!.couponType == 'default' ? 0 : 1 , false);
      Get.find<CouponController>().initDiscountType(widget.coupon!.discountType!);
    } else{
      Get.find<CouponController>().setCouponTypeIndex(-1, false);
      Get.find<CouponController>().initDiscountType('percent');
      for (var language in _languageList) {
        log(language.value ?? '');
        _titleController.add(TextEditingController());
        _titleNode.add(FocusNode());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    late bool selfDelivery;
    if(Get.find<ProfileController>().profileModel != null && Get.find<ProfileController>().profileModel!.restaurants != null){
      selfDelivery = Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1;
    }
    if(!selfDelivery){
      Get.find<CouponController>().setCouponTypeIndex(0, false);
    }

    return Scaffold(

      appBar: CustomAppBarWidget(title: widget.coupon != null ? 'update_coupon'.tr : 'add_coupon'.tr),

      body: GetBuilder<CouponController>(builder: (couponController) {
        return Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

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
                        onTap: (int ? value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      child: Divider(height: 0),
                    ),

                    CustomTextFieldWidget(
                      hintText: '${'title'.tr} (${_languageList?[_tabController!.index].value!})',
                      labelText: 'title'.tr,
                      controller: _titleController[_tabController!.index],
                      focusNode: _titleNode[_tabController!.index],
                      nextFocus: _tabController!.index != _languageList!.length-1 ? _titleNode[_tabController!.index + 1 ] : _codeNode,
                      required: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                    selfDelivery ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.4), width: 1),
                      ),
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall + 2, right: Dimensions.paddingSizeExtraSmall),
                        hint: Text('coupon_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),
                        value: couponController.couponTypeIndex == -1 ? null : (couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery'),
                        items: <String>['default', 'free_delivery'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.tr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          couponController.setCouponTypeIndex(value == 'default' ? 0 : 1, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor),
                      ),
                    ) : const SizedBox(),
                    SizedBox(height: selfDelivery ? Dimensions.paddingSizeOverLarge : 0),

                    Row(children: [
                      Expanded(
                        child: CustomTextFieldWidget(
                          hintText: 'coupon_code'.tr,
                          labelText: 'coupon_code'.tr,
                          controller: _codeController,
                          focusNode: _codeNode,
                          nextFocus: _limitNode,
                          required: true,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                        ),
                        child: InkWell(
                          onTap: () {
                            String code = '';
                            for (int i = 0; i < 6; i++) {
                              code = code + (i % 2 == 0 ? String.fromCharCode(65 + DateTime.now().microsecondsSinceEpoch % 26) : DateTime.now().microsecondsSinceEpoch % 10).toString();
                            }
                            _codeController.text = code;
                          },
                          child: Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
                        ),
                      ),

                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    CustomTextFieldWidget(
                      hintText: 'limit_for_same_user'.tr,
                      labelText: 'limit_for_same_user'.tr,
                      controller: _limitController,
                      focusNode: _limitNode,
                      nextFocus: _minNode,
                      isAmount: true,
                      required: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                    CustomTextFieldWidget(
                      hintText: 'min_purchase'.tr,
                      labelText: 'min_purchase'.tr,
                      controller: _minPurchaseController,
                      isAmount: true,
                      focusNode: _minNode,
                      nextFocus: _discountNode,
                      required: true,
                    ),
                    SizedBox(height: couponController.couponTypeIndex == 0 ? Dimensions.paddingSizeOverLarge : 0),

                    couponController.couponTypeIndex == 0 ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: TextField(
                            controller: _discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              border: InputBorder.none,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              isCollapsed: true,
                              label: Text.rich(TextSpan(children: [
                                TextSpan(text: 'discount'.tr, style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                )),
                                TextSpan(text : ' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeDefault)),
                               ])),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 70,
                          child: CustomDropdownButton(
                            key: ValueKey(couponController.discountTypeKey),
                            items: ['%', Get.find<SplashController>().configModel!.currencySymbol!],
                            isBorder: false,
                            borderRadius: 0,
                            hintText: '%',
                            backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                            onChanged: (String? value) {
                              couponController.setDiscountType(value!);
                            },
                            selectedValue: couponController.discountTypeKey,
                          ),
                        ),
                      ]),
                    ) : const SizedBox(),
                    SizedBox(height: couponController.couponTypeIndex == 0 && couponController.discountType == 'percent' ? Dimensions.paddingSizeOverLarge : 0),

                    couponController.couponTypeIndex == 0 && couponController.discountType == 'percent' ? CustomTextFieldWidget(
                      hintText: 'max_discount'.tr,
                      labelText: 'max_discount'.tr,
                      controller: _maxDiscountController,
                      isAmount: true,
                      focusNode: _maxDiscountNode,
                      inputAction: TextInputAction.done,
                    ) : const SizedBox(),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    CustomTextFieldWidget(
                      controller: _startDateController,
                      hintText: 'start_date'.tr,
                      labelText: 'start_date'.tr,
                      readOnly: true,
                      suffixIcon: Icons.calendar_month_rounded,
                      suffixIconColor: Theme.of(context).primaryColor,
                      onSuffixPressed: (){},
                      onFocusChanged: false,
                      required: true,
                      onTap: () async{
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                          setState(() {
                            _startDateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeOverLarge),

                    CustomTextFieldWidget(
                      controller: _expireDateController,
                      hintText: 'end_date'.tr,
                      labelText: 'end_date'.tr,
                      readOnly: true,
                      suffixIcon: Icons.calendar_month_rounded,
                      suffixIconColor: Theme.of(context).primaryColor,
                      onSuffixPressed: (){},
                      onFocusChanged: false,
                      required: true,
                      onTap: () async{
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                          setState(() {
                            _expireDateController.text = formattedDate;
                          });
                        }
                      },
                    ),

                  ]),
                ),

              ]),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
            ),
            child: !couponController.isLoading ? CustomButtonWidget(
              buttonText: widget.coupon == null ? 'add'.tr : 'update'.tr,
              onPressed: (){
                bool defaultNameNull = false;
                for(int index=0; index<_languageList.length; index++) {
                  if(_languageList[index].key == 'en') {
                    if (_titleController[index].text.trim().isEmpty) {
                      defaultNameNull = true;
                    }
                    break;
                  }
                }
                String code = _codeController.text.trim();
                String startDate = _startDateController.text.trim();
                String expireDate = _expireDateController.text.trim();
                String discount = _discountController.text.trim();
                if(defaultNameNull){
                  showCustomSnackBar('please_fill_up_your_coupon_title'.tr);
                }else if(code.isEmpty){
                  showCustomSnackBar('please_fill_up_your_coupon_code'.tr);
                }else if(_limitController.text.isEmpty){
                  showCustomSnackBar('please_fill_up_your_limit_for_same_user'.tr);
                }else if(_minPurchaseController.text.isEmpty){
                  showCustomSnackBar('please_fill_up_your_min_purchase'.tr);
                }else if(startDate.isEmpty){
                  showCustomSnackBar('please_select_your_coupon_start_date'.tr);
                }else if(expireDate.isEmpty){
                  showCustomSnackBar('please_select_your_coupon_expire_date'.tr);
                }else if(couponController.couponTypeIndex == 0 && discount.isEmpty){
                  showCustomSnackBar('please_fill_up_your_coupon_discount'.tr);
                }else if(couponController.couponTypeIndex == 0 && _limitController.text.isNotEmpty && (int.parse(_limitController.text.trim()) > 100)){
                  showCustomSnackBar('limit_for_same_user_cant_be_more_then_100'.tr);
                }else {
                  List<Translation> translation = [];
                  for(int index=0; index<_languageList.length; index++) {
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'title',
                      value: _titleController[index].text.trim().isNotEmpty ? _titleController[index].text.trim()
                          : _titleController[0].text.trim(),
                    ));
                  }

                  if(widget.coupon == null){
                    couponController.addCoupon(title: jsonEncode(translation), code: code, startDate: startDate, expireDate: expireDate,
                      couponType: couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery', discount: discount,
                      discountType: couponController.discountType, limit: _limitController.text.trim(),
                      maxDiscount: couponController.discountType == 'percent' ? _maxDiscountController.text.trim() : '0',
                      minPurchase: _minPurchaseController.text.trim(),
                    );
                  }else{
                    couponController.updateCoupon(couponId: widget.coupon!.id.toString(), title: jsonEncode(translation), code: code, startDate: startDate, expireDate: expireDate,
                      couponType: couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery', discount: discount,
                      discountType: couponController.discountType, limit: _limitController.text.trim(),
                      maxDiscount: couponController.discountType == 'percent' ? _maxDiscountController.text.trim() : '0',
                      minPurchase: _minPurchaseController.text.trim(),
                    );
                  }
                }
              },
            ) : const Center(child: CircularProgressIndicator()),
          ),
        ]);
      }),
    );
  }
}