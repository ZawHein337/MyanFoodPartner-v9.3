import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_form_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/gap_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/switch_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/home/screens/ongoing_orders_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/custom_radio_list_tile.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/custom_switch_tile.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/setting_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/daily_time_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/type_converter.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantSettingsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantSettingsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantSettingsScreen> createState() => _RestaurantSettingsScreenState();
}

class _RestaurantSettingsScreenState extends State<RestaurantSettingsScreen> with TickerProviderStateMixin{

  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _minimumChargeController = TextEditingController();
  final TextEditingController _maximumChargeController = TextEditingController();
  final TextEditingController _perKmChargeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _extraPackagingController = TextEditingController();
  TextEditingController _characteristicSuggestionController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final TextEditingController _dineInAdvanceTimeController = TextEditingController();
  final TextEditingController _customerOrderDaysController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _minimumChargeNode = FocusNode();
  final FocusNode _maximumChargeNode = FocusNode();
  final FocusNode _perKmChargeNode = FocusNode();
  final FocusNode _customerOrderDaysNode = FocusNode();
  late Restaurant _restaurant;
  List<DropdownItem<int>> timeList = [];

  /// The distance unit the panel is configured for — 'mi' as readily as 'km' — so the
  /// per-unit delivery charge is labelled in whatever the admin actually bills in.
  String get _distanceUnitLabel {
    final ConfigModel? config = Get.find<SplashController>().configModel;
    return config?.distanceUnitLabel ?? config?.distanceUnit ?? 'km';
  }

  @override
  void initState() {
    super.initState();

    _getTimeList();
    Get.find<ProfileController>().getProfile(willLoad: true).then((profileModel) {
      if(profileModel != null) {
        Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;

        if(restaurant != null) {
          Get.find<RestaurantController>().initRestaurantData(restaurant);
          _orderAmountController.text = restaurant.minimumOrder.toString();
          _minimumChargeController.text = restaurant.minimumShippingCharge != null ? restaurant.minimumShippingCharge.toString() : '';
          _maximumChargeController.text = restaurant.maximumShippingCharge != null ? restaurant.maximumShippingCharge.toString() : '';
          _perKmChargeController.text = restaurant.perKmShippingCharge != null ? restaurant.perKmShippingCharge.toString() : '';
          _gstController.text = restaurant.gstCode!;
          _extraPackagingController.text = restaurant.extraPackagingAmount != null ? restaurant.extraPackagingAmount.toString() : '';
          _restaurant = restaurant;
          _dineInAdvanceTimeController.text = restaurant.scheduleAdvanceDineInBookingDuration != null ? restaurant.scheduleAdvanceDineInBookingDuration.toString() : '';
          _customerOrderDaysController.text = restaurant.customOrderDate != null ? restaurant.customOrderDate.toString() : '';
        }
      }
    });
  }

  void _getTimeList() {
    for(int i = 0; i < Get.find<RestaurantController>().timeTypes.length; i++) {
      timeList.add(DropdownItem<int>(value: i, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Get.find<RestaurantController>().timeTypes[i].tr),
        ),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'restaurant_config'.tr),

      body: GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<RestaurantController>(builder: (restController) {

          List<int> cuisines0 = [];
          if(restController.cuisineModel != null) {
            for(int index=0; index<restController.cuisineModel!.cuisines!.length; index++) {
              if(restController.cuisineModel!.cuisines![index].status == 1 && !restController.selectedCuisines!.contains(index)) {
                cuisines0.add(index);
              }
            }
          }

          List<int> characteristicSuggestion = [];
          if(restController.characteristicSuggestionList != null) {
            for(int index = 0; index<restController.characteristicSuggestionList!.length; index++) {
              characteristicSuggestion.add(index);
            }
          }

          Restaurant? restaurant = profileController.profileModel != null ? profileController.profileModel!.restaurants![0] : null;

          return profileController.isProfileGetLoading ? Center(child: CircularProgressIndicator()) : Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                restController.showSaveButtonInstruction ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.info, color: Theme.of(context).primaryColor),
                    const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'after_making_changes_please_click_the'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                          ),
                          TextSpan(
                            text: ' ${'save_button'.tr} ',
                            style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                          ),
                          TextSpan(
                            text: 'to_apply_them'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                          ),
                        ]),
                      ),
                    ),
                    const Gap.horizontal(Dimensions.paddingSizeSmall),

                    InkWell(
                      onTap: (){
                        restController.setShowSaveButtonInstruction(false);
                      },
                      child: Icon(CupertinoIcons.clear_circled, color: Theme.of(context).hintColor, size: 20),
                    ),
                  ]),
                ) : const SizedBox(),
                Gap(restController.showSaveButtonInstruction ? Dimensions.paddingSizeLarge : 0),

                profileController.modulePermission?.restaurantConfig ?? false ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('restaurant_availability'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('restaurant_availability_description'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).disabledColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('status'.tr, style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        profileController.profileModel != null ? Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: profileController.profileModel!.restaurants![0].active!,
                            activeTrackColor: Theme.of(context).primaryColor,
                            inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                            onChanged: (bool isActive) {
                              if(Get.find<ProfileController>().modulePermission!.restaurantConfig!){
                                Get.dialog(ConfirmationDialogWidget(
                                  icon: Images.warning,
                                  description: !isActive ? 'are_you_sure_to_close_restaurant'.tr : 'are_you_sure_to_open_restaurant'.tr,
                                  onYesPressed: () {
                                    Get.back();
                                    Get.find<AuthController>().toggleRestaurantClosedStatus();
                                  },
                                ));
                              }else{
                                showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                              }
                            },
                          ),
                        ) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),

                      ]),
                    ),
                  ]),
                ) : SizedBox(),
                Gap(profileController.modulePermission?.restaurantConfig ?? false ? Dimensions.paddingSizeLarge : 0),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('order_type'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('order_type_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    CustomSwitchTile(
                      title: 'home_delivery'.tr,
                      subtitle: 'home_delivery_description'.tr,
                      isButtonActive: restController.isDeliveryEnabled,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isDeliveryEnabled ? 'want_to_disable_the_home_delivery_option'.tr : 'want_to_enable_the_home_delivery_option'.tr,
                            description: restController.isDeliveryEnabled ? 'if_disabled_the_home_delivery_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_order_food_for_home_delivery'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.setHomeDelivery(!restController.isDeliveryEnabled);
                            },
                          ),
                        );
                      },
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Get.find<SplashController>().configModel!.takeAway! ? CustomSwitchTile(
                      title: 'take_away'.tr,
                      subtitle: 'take_away_description'.tr,
                      isButtonActive: restController.isTakeAwayEnabled,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isTakeAwayEnabled ? 'want_to_disable_the_takeaway_option'.tr : 'want_to_enable_the_takeaway_option'.tr,
                            description: restController.isTakeAwayEnabled ? 'if_disabled_the_takeaway_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_place_takeaway_self_pickup_orders'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.setTakeAway(!restController.isTakeAwayEnabled);
                            },
                          ),
                        );
                      },
                    ) : const SizedBox(),
                    Gap(Get.find<SplashController>().configModel!.takeAway! ? Dimensions.paddingSizeLarge : 0),

                    CustomSwitchTile(
                      title: 'dine_in'.tr,
                      subtitle: 'dine_in_description'.tr,
                      isButtonActive: restController.isDineInEnabled!,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isDineInEnabled! ? 'want_to_disable_the_dine_in_option'.tr : 'want_to_enable_the_dine_in_option'.tr,
                            description: restController.isDineInEnabled! ? 'if_disabled_the_dine_in_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_place_dine_in_orders'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.toggleDineIn();
                            },
                          ),
                        );
                      },
                    ),
                    Gap(Dimensions.paddingSizeExtraLarge),

                    CustomTextFieldWidget(
                      hintText: 'eg_18'.tr,
                      labelText: '${'minimum_order_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                      controller: _orderAmountController,
                      focusNode: _orderAmountNode,
                      nextFocus: _restaurant.selfDeliverySystem == 1 ? _perKmChargeNode : null,
                      inputAction: _restaurant.selfDeliverySystem == 1 ? TextInputAction.done : TextInputAction.next,
                      inputType: TextInputType.number,
                      isAmount: true,
                      required: true,
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor),
                      ),
                      child: Row(children: [
                        Expanded(
                          flex: 4,
                          child: CustomTextFormFieldWidget(
                            hintText: 'minimum_time_for_dine_in_order'.tr,
                            controller: _dineInAdvanceTimeController,
                            inputAction: TextInputAction.done,
                            showTitle: false,
                            isEnabled: restController.isDineInEnabled,
                            isBorderEnabled: false,
                            inputType: TextInputType.number,
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radiusDefault),
                                bottomRight: Radius.circular(Dimensions.radiusDefault),
                              ),
                            ),
                            child: CustomDropdownWidget<int>(
                              onChange: (int? value, int index) {
                                restController.setTimeType(type: restController.timeTypes[index]);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeExtraSmall,
                                ),
                                primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              dropdownStyle: DropdownStyle(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              ),
                              items: timeList,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(restController.selectedTimeType.tr),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Color(0xff245BD1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomAssetImageWidget(image: Images.lightIcon, height: 20, width: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${'you_can_check_all_your_order_from'.tr} ',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                              ),
                              TextSpan(
                                text: 'all_orders'.tr,
                                style: robotoBold.copyWith(
                                  color: Color(0xff245BD1),
                                  fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5,
                                  decoration: TextDecoration.underline, decorationColor: Color(0xff245BD1),
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Get.to(()=> OngoingOrdersScreen());
                                }
                              ),
                              TextSpan(
                                text: ' ${'page'.tr}',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Gap(Dimensions.paddingSizeLarge),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('regular_order'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('regular_order_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    Get.find<SplashController>().configModel!.instantOrder! ? CustomSwitchTile(
                      title: 'instant_order'.tr,
                      subtitle: 'instant_order_description'.tr,
                      isButtonActive: restController.instantOrder,
                      onTap: (){
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.instantOrder ? 'want_to_disable_the_instant_order_option'.tr : 'want_to_enable_the_instant_order_option'.tr,
                            description: restController.instantOrder ? 'if_disabled_customers_can_not_order_instantly'.tr : 'if_enabled_customers_can_order_instantly'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.setInstantOrder(!restController.instantOrder);
                            },
                          ),
                        );
                      },
                    ) : const SizedBox(),
                    Gap(Get.find<SplashController>().configModel!.instantOrder! ? Dimensions.paddingSizeLarge : 0),

                    Get.find<SplashController>().configModel!.scheduleOrder! ? CustomSwitchTile(
                      title: 'schedule_order'.tr,
                      subtitle: 'schedule_order_description'.tr,
                      isButtonActive: restController.scheduleOrder,
                      onTap: (){
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.scheduleOrder ? 'want_to_disable_the_schedule_order_option'.tr : 'want_to_enable_the_schedule_order_option'.tr,
                            description: restController.scheduleOrder ? 'if_disabled_customers_can_not_order_schedule_wise'.tr : 'if_enabled_customers_can_order_schedule_wise'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.setScheduleOrder(!restController.scheduleOrder);
                            },
                          ),
                        );
                      },
                    ) : const SizedBox(),
                    Gap(Get.find<SplashController>().configModel!.scheduleOrder! ? Dimensions.paddingSizeLarge : 0),

                    CustomSwitchTile(
                      title: 'subscription_order'.tr,
                      subtitle: 'subscription_order_description'.tr,
                      isButtonActive: restController.isSubscriptionOrderEnabled,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isSubscriptionOrderEnabled! ? 'want_to_disable_the_subscription_order_option'.tr : 'want_to_enable_the_subscription_order_option'.tr,
                            description: restController.isSubscriptionOrderEnabled! ? 'if_disabled_the_subscription_based_order_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_order_food_on_a_subscription_basis_from_your_restaurant'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.toggleSubscriptionOrder();
                            },
                          ),
                        );
                      },
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Color(0xff245BD1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomAssetImageWidget(image: Images.lightIcon, height: 20, width: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${'view_all_your_orders_from'.tr} ',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                              ),
                              TextSpan(
                                  text: 'all_orders'.tr,
                                  style: robotoBold.copyWith(
                                    color: Color(0xff245BD1),
                                    fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5,
                                    decoration: TextDecoration.underline, decorationColor: Color(0xff245BD1),
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Get.to(()=> OngoingOrdersScreen());
                                  }
                              ),
                              TextSpan(
                                text: ' ${'page'.tr}',
                                style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall, height: 1.5, letterSpacing: 0.5),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Gap(Dimensions.paddingSizeLarge),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('setup_your_restaurant_type_and_tags'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('setup_your_restaurant_type_and_tags_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Color(0xff245BD1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomAssetImageWidget(image: Images.lightIcon, height: 20, width: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(
                            'select_your_foods_cuisine_to_categories_your_restaurant_you_may_not_select_the_cuisine_as_your_business_preference'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ]),
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Color(0xff245BD1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomAssetImageWidget(image: Images.lightIcon, height: 20, width: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(
                            'specify_your_restaurant_characteristic_which_type_of_restaurant_your_are_it_will_help_your_customer_to_find_you_easily'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ]),
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Column(children: [

                      Autocomplete<int>(
                        optionsBuilder: (TextEditingValue value) {
                          if(value.text.isEmpty) {
                            return const Iterable<int>.empty();
                          }else {
                            return cuisines0.where((cuisine) => restController.cuisineModel!.cuisines![cuisine].name!.toLowerCase().contains(value.text.toLowerCase()));
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
                                    width: MediaQuery.of(context).size.width - 50,
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
                                            _c.text = '';
                                            restController.setSelectedCuisineIndex(result[index], true);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                            child: Text(restController.cuisineModel!.cuisines![result[index]].name!),
                                          ),
                                        );
                                      },
                                    )
                                ),
                              )
                          );
                        },
                        fieldViewBuilder: (context, controller, node, onComplete) {
                          _c = controller;
                          return TextFormField(
                            controller: controller,
                            focusNode: node,
                            onEditingComplete: () {
                              onComplete();
                              controller.text = '';
                            },
                            decoration: InputDecoration(
                              hintText: 'cuisines'.tr,
                              labelText: 'cuisines'.tr,
                              labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                              isDense: true,
                              fillColor: Theme.of(context).cardColor,
                              hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                              ),
                            ),
                          );
                        },
                        displayStringForOption: (value) => restController.cuisineModel!.cuisines![value].name!,
                        onSelected: (int value) {
                          _c.text = '';
                          restController.setSelectedCuisineIndex(value, true);
                        },
                      ),
                      SizedBox(height: restController.selectedCuisines!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                      SizedBox(
                        height: restController.selectedCuisines!.isNotEmpty ? 40 : 0,
                        child: ListView.builder(
                          itemCount: restController.selectedCuisines!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Row(children: [

                                Text(
                                  restController.cuisineModel!.cuisines![restController.selectedCuisines![index]].name!,
                                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                ),

                                InkWell(
                                  onTap: () => restController.removeCuisine(index),
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
                    Gap(Dimensions.paddingSizeLarge),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(children: [

                        Expanded(
                          flex: 8,
                          child: Autocomplete<int>(
                            optionsBuilder: (TextEditingValue value) {
                              if(value.text.isEmpty) {
                                return const Iterable<int>.empty();
                              }else {
                                return characteristicSuggestion.where((characteristic) => restController.characteristicSuggestionList![characteristic]!.toLowerCase().contains(value.text.toLowerCase()));
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
                                            if(restController.selectedCharacteristicsList!.length >= 5) {
                                              showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                                            }else {
                                              _characteristicSuggestionController.text = '';
                                              restController.setSelectedCharacteristicsIndex(result[index], true);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                            child: Text(restController.characteristicSuggestionList![result[index]]!),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            fieldViewBuilder: (context, controller, node, onComplete) {
                              _characteristicSuggestionController = controller;
                              return TextField(
                                controller: controller,
                                focusNode: node,
                                onEditingComplete: () {
                                  onComplete();
                                  controller.text = '';
                                },
                                decoration: InputDecoration(
                                  hintText: 'ex_indian_food'.tr,
                                  labelText: 'restaurant_characteristics'.tr,
                                  labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                  isDense: true,
                                  fillColor: Theme.of(context).cardColor,
                                  hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                  ),
                                ),
                              );
                            },
                            displayStringForOption: (value) => restController.characteristicSuggestionList![value]!,
                            onSelected: (int value) {

                              if(restController.selectedCharacteristicsList!.length >= 5) {
                                showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                              }else {
                                _characteristicSuggestionController.text = '';
                                restController.setSelectedCharacteristicsIndex(value, true);
                              }

                            },
                          ),
                        ),
                        Gap.horizontal(Dimensions.paddingSizeSmall),

                        CustomButtonWidget(
                          buttonText: '+',
                          fontSize: Dimensions.fontSizeOverLarge,
                          width: 45, height: 45,
                          onPressed: () {
                            if(restController.selectedCharacteristicsList!.length >= 5) {
                              showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                            }else{
                              if(_characteristicSuggestionController.text.isNotEmpty) {
                                restController.setCharacteristics(_characteristicSuggestionController.text.trim());
                                _characteristicSuggestionController.text = '';
                              }
                            }
                          },
                        ),

                      ]),
                      SizedBox(height: restController.selectedCharacteristicsList!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                      restController.selectedCharacteristicsList != null ? SizedBox(
                        height: restController.selectedCharacteristicsList!.isNotEmpty ? 40 : 0,
                        child: ListView.builder(
                          itemCount: restController.selectedCharacteristicsList!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Row(children: [

                                Text(
                                  restController.selectedCharacteristicsList![index]!,
                                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                ),

                                InkWell(
                                  onTap: () => restController.removeCharacteristic(index),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor),
                                  ),
                                ),

                              ]),
                            );
                          },
                        ),
                      ) : const SizedBox(),

                    ]),
                    Gap(Dimensions.paddingSizeLarge),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(children: [

                        Expanded(
                          flex: 8,
                          child: CustomTextFieldWidget(
                            hintText: 'restaurant_tags'.tr,
                            labelText: 'restaurant_tags'.tr,
                            showTitle: false,
                            controller: _tagController,
                            inputAction: TextInputAction.done,
                            onSubmit: (name){
                              if(name.isNotEmpty) {
                                restController.setRestaurantTag(name);
                                _tagController.text = '';
                              }
                            },
                          ),
                        ),
                       Gap.horizontal(Dimensions.paddingSizeSmall),

                        CustomButtonWidget(
                          buttonText: '+',
                          fontSize: Dimensions.fontSizeOverLarge,
                          width: 45, height: 45,
                          onPressed: () {
                            if(_tagController.text.isNotEmpty) {
                              restController.setRestaurantTag(_tagController.text.trim());
                              _tagController.text = '';
                            }
                          },
                        ),

                      ]),
                      SizedBox(height: restController.restaurantTagList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                      restController.restaurantTagList.isNotEmpty ? SizedBox(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true, scrollDirection: Axis.horizontal,
                          itemCount: restController.restaurantTagList.length,
                          itemBuilder: (context, index){
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                              child: Center(child: Row(children: [

                                Text(restController.restaurantTagList[index]!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                InkWell(onTap: () => restController.removeRestaurantTag(index), child: Icon(Icons.clear, size: 15, color: Theme.of(context).hintColor)),

                              ])),
                            );
                          },
                        ),
                      ) : const SizedBox(),

                    ]),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Color(0xff245BD1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomAssetImageWidget(image: Images.lightIcon, height: 20, width: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(
                            'add_search_tag_to_boost_up_your_restaurant_better_performance_when_user_search_any_food'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Gap(Dimensions.paddingSizeLarge),

                Get.find<SplashController>().configModel!.extraPackagingChargeStatus! ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('packaging_charge_setup'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('packaging_charge_setup_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.info, color: Theme.of(context).primaryColor, size: 20),
                        const Gap.horizontal(Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(
                            'by_enabling_the_status_customer_will_get_the_option_for_choosing_extra_packaging_charge_when_placing_order'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ]),
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('status'.tr, style: robotoRegular),

                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: restController.isExtraPackagingEnabled,
                            activeTrackColor: Theme.of(context).primaryColor,
                            inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                            onChanged: (bool isActive) => restController.toggleExtraPackaging(),
                          ),
                        ),
                      ]),
                    ),

                    restController.isExtraPackagingEnabled ? Column(children: [
                      Gap(Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'extra_packaging_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _extraPackagingController,
                        inputAction: TextInputAction.done,
                        showTitle: false,
                        isAmount: true,
                        isEnabled: restController.isExtraPackagingEnabled,
                        required: true,
                      ),
                      Gap(Dimensions.paddingSizeLarge),

                      Container(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).disabledColor),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Column(children: [

                          CustomRadioListTile(
                            title: 'optional'.tr,
                            subtitle: 'optional_description'.tr,
                            value: 0,
                            groupValue: restController.extraPackagingSelectedValue,
                            onChanged: (value) {
                              restController.setExtraPackagingSelectedValue(value!);
                            },
                          ),
                          Gap(Dimensions.paddingSizeExtraSmall),

                          CustomRadioListTile(
                            title: 'required'.tr,
                            subtitle: 'required_description'.tr,
                            value: 1,
                            groupValue: restController.extraPackagingSelectedValue,
                            onChanged: (value) {
                              restController.setExtraPackagingSelectedValue(value!);
                            },
                          ),
                        ]),
                      ),
                    ]) : const SizedBox(),

                  ]),
                ) : const SizedBox(),
                Gap(Get.find<SplashController>().configModel!.extraPackagingChargeStatus! ? Dimensions.paddingSizeLarge : 0),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('other_setup'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('other_setup_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Stack(clipBehavior: Clip.none, children: [

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Row(children: [

                          Expanded(child: InkWell(
                            onTap: () => restController.setRestVeg(!restController.isRestVeg!, true),
                            child: Row(children: [

                              Checkbox(
                                value: restController.isRestVeg,
                                onChanged: (bool? isActive) => restController.setRestVeg(isActive, true),
                                activeColor: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).hintColor),
                              ),

                              Text('veg'.tr, style: robotoMedium.copyWith(color: restController.isRestVeg! ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

                            ]),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: InkWell(
                            onTap: () => restController.setRestNonVeg(!restController.isRestNonVeg!, true),
                            child: Row(children: [

                              Checkbox(
                                value: restController.isRestNonVeg,
                                onChanged: (bool? isActive) => restController.setRestNonVeg(isActive, true),
                                activeColor: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).hintColor),
                              ),

                              Text('non_veg'.tr, style: robotoMedium.copyWith(color: restController.isRestVeg! ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

                            ]),
                          )),
                        ]),
                      ),

                      Positioned(
                        left: 10, top: -10,
                        child: Container(
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          padding: const EdgeInsets.all(5),
                          child: RichText(text: TextSpan(children: [
                              TextSpan(text: 'food_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                              TextSpan(text: ' *', style: robotoRegular.copyWith(color: Colors.red, fontSize: Dimensions.fontSizeSmall))
                          ])),
                        ),
                      ),
                    ]) : const SizedBox(),
                    Gap(Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Dimensions.paddingSizeLarge : 0),

                    SwitchButtonWidget(
                      title: 'cutlery_on_delivery'.tr,
                      isButtonActive: restController.isCutleryEnabled,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isCutleryEnabled! ? 'want_to_disable_the_cutlery_option'.tr : 'want_to_enable_the_cutlery_option'.tr,
                            description: restController.isCutleryEnabled! ? 'if_disabled_the_cutlery_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_the_cutlery_option_will_be_visible_in_your_restaurant'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.toggleCutlery();
                            },
                          ),
                        );
                      },
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    SwitchButtonWidget(
                      title: 'halal_tag_status'.tr,
                      isButtonActive: restController.isHalalEnabled,
                      onTap: () {
                        showCustomBottomSheet(
                          child: SettingConfirmationBottomSheet(
                            title: restController.isHalalEnabled! ? 'want_to_disable_the_halal_tag_status'.tr : 'want_to_enable_the_halal_tag_status'.tr,
                            description: restController.isHalalEnabled! ? 'if_disabled_customers_can_not_see_halal_tag_on_product'.tr : 'if_enabled_customers_can_see_halal_tag_on_product'.tr,
                            onConfirm: (){
                              Get.back();
                              restController.toggleHalalTag();
                            },
                          ),
                        );
                      },
                    ),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                      ),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                          child: Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('gst'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                                  Text('if_enabled_the_gst_number_will_be_shown_in_the_invoice'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                value: restController.isGstEnabled,
                                activeTrackColor: Theme.of(context).primaryColor,
                                inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                                onChanged: (bool isActive) => restController.toggleGst(),
                              ),
                            ),
                          ]),
                        ),

                        restController.isGstEnabled ? Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CustomTextFieldWidget(
                            hintText: 'eg_18'.tr,
                            labelText: '${'gst_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                            controller: _gstController,
                            inputAction: TextInputAction.done,
                            showTitle: false,
                            isEnabled: restController.isGstEnabled,
                            hideEnableText: true,
                            isAmount: true,
                          ),
                        ) : const SizedBox(),
                      ]),
                    ),
                  ]),
                ),
                Gap(Dimensions.paddingSizeLarge),

                _restaurant.selfDeliverySystem == 1 ? Column(children: [
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('custom_order'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Gap(Dimensions.paddingSizeExtraSmall),

                      Text('custom_order_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      Gap(Dimensions.paddingSizeLarge),

                      Container(
                        padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).disabledColor),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('status'.tr, style: robotoRegular),

                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: restController.customDateOrderEnabled!,
                              activeTrackColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              onChanged: (bool isActive) => restController.toggleCustomDateOrder(),
                            ),
                          ),
                        ]),
                      ),
                      Gap(Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: 'customer_can_order_within_days'.tr,
                        showTitle: false,
                        hideEnableText: true,
                        controller: _customerOrderDaysController,
                        focusNode: _customerOrderDaysNode,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.phone,
                        isEnabled: restController.customDateOrderEnabled!,
                      ),
                    ]),
                  ),
                  Gap(Dimensions.paddingSizeLarge),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('delivery_charge'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Gap(Dimensions.paddingSizeExtraSmall),

                      Text('delivery_charge_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      Gap(Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'per_unit_delivery_charge'.trParams({'unit': _distanceUnitLabel})} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _perKmChargeController,
                        focusNode: _restaurant.selfDeliverySystem == 1 ? _perKmChargeNode : null,
                        nextFocus: _restaurant.selfDeliverySystem == 1 ? _minimumChargeNode : null,
                        inputType: TextInputType.number,
                        isAmount: true,
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'minimum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _minimumChargeController,
                        focusNode: _minimumChargeNode,
                        nextFocus: _maximumChargeNode,
                        inputType: TextInputType.number,
                        isAmount: true,
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'maximum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _maximumChargeController,
                        focusNode: _maximumChargeNode,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.number,
                        isAmount: true,
                        required: true,
                      ),
                    ]),
                  ),
                  Gap(Dimensions.paddingSizeLarge),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('free_delivery'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      Gap(Dimensions.paddingSizeExtraSmall),

                      Text('free_delivery_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      Gap(Dimensions.paddingSizeLarge),

                      Container(
                        padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).disabledColor),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('status'.tr, style: robotoRegular),

                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: restController.freeDeliveryDistanceEnabled!,
                              activeTrackColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              onChanged: (bool isActive) => restController.toggleFreeDeliveryDistance(),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ]) : const SizedBox(),
                Gap(_restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('restaurant_opening_and_closing_schedules'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Gap(Dimensions.paddingSizeExtraSmall),

                    Text('restaurant_opening_and_closing_schedules_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    Gap(Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Column(children: [

                        CustomRadioListTile(
                          title: 'always_open'.tr,
                          subtitle: 'always_open_description'.tr,
                          value: 1,
                          groupValue: restController.alwaysOpenOrSpecificTime,
                          onChanged: (value) {
                            Get.dialog(const CustomLoaderWidget());
                            restController.setAlwaysOpenOrSpecificTime(value!);
                            restController.openingClosingStatus(sameTimeForEveryDay: (restaurant?.sameTimeForEveryDay ?? false), openingClosingStatus: (restaurant?.openingClosingStatus ?? false));
                            Get.find<ProfileController>().getProfile().then((profileModel) {
                              if(profileModel != null) {
                                Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;
                                restController.initRestaurantData(restaurant!);
                              }
                            });
                          },
                        ),
                        Gap(Dimensions.paddingSizeExtraSmall),

                        CustomRadioListTile(
                          title: 'specific_time'.tr,
                          subtitle: 'specific_time_description'.tr,
                          value: 0,
                          groupValue: restController.alwaysOpenOrSpecificTime,
                          onChanged: (value) {
                            Get.dialog(const CustomLoaderWidget());
                            restController.setAlwaysOpenOrSpecificTime(value!);
                            restController.openingClosingStatus(sameTimeForEveryDay: (restaurant!.sameTimeForEveryDay ?? false), openingClosingStatus: (restaurant.openingClosingStatus ?? false));
                            Get.find<ProfileController>().getProfile().then((profileModel) {
                              if(profileModel != null) {
                                Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;
                                restController.initRestaurantData(restaurant!);
                              }
                            });
                          },
                        ),
                      ]),
                    ),

                    restController.alwaysOpenOrSpecificTime == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Gap(Dimensions.paddingSizeLarge),

                      Text('set_specific_time_for_your_restaurant'.tr, style: robotoSemiBold),
                      Gap(Dimensions.paddingSizeExtraSmall),

                      Text('set_specific_time_for_your_restaurant_description'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                      Gap(Dimensions.paddingSizeDefault),

                      Container(
                        padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).disabledColor),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('same_time_for_every_day'.tr, style: robotoRegular),

                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: restController.isSameTimeForEveryDay,
                              activeTrackColor: Theme.of(context).primaryColor,
                              inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              onChanged: (bool isActive){
                                showCustomBottomSheet(
                                  child: SettingConfirmationBottomSheet(
                                    title: restController.isSameTimeForEveryDay ? 'set_different_schedule_for_each_day'.tr : 'apply_same_schedule_for_every_day'.tr,
                                    description: restController.isSameTimeForEveryDay ? 'if_disabled_you_can_set_opening_and_closing_time_separately_for_each_day'.tr : 'if_enabled_you_can_set_the_schedule_for_one_day_and_it_will_apply_to_all_days'.tr,
                                    onConfirm: (){
                                      Get.back();
                                      restController.setIsSameTimeForEveryDay(isActive);
                                      restController.openingClosingStatus(sameTimeForEveryDay: (restaurant!.sameTimeForEveryDay ?? false), openingClosingStatus: (restaurant.openingClosingStatus ?? false));
                                      Get.find<ProfileController>().getProfile().then((profileModel) {
                                        if(profileModel != null) {
                                          Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;
                                          restController.initRestaurantData(restaurant!);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                      Gap(Dimensions.paddingSizeDefault),

                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            DailyTimeWidget(weekDay: index, isSameTimeForEveryDay: restController.isSameTimeForEveryDay),

                            index != 6 ? const Divider() : const SizedBox(),
                          ]);
                        },
                      ),
                    ]) : SizedBox(),
                  ]),
                ),

              ]),
            )),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              child: CustomButtonWidget(
                isLoading: restController.isLoading,
                onPressed: () async {
                  String minimumOrder = _orderAmountController.text.trim();
                  String minimumFee = _minimumChargeController.text.trim();
                  String perKmFee = _perKmChargeController.text.trim();
                  String gstCode = _gstController.text.trim();
                  String maximumFee = _maximumChargeController.text.trim();
                  String extraPackagingAmount = _extraPackagingController.text.trim();
                  String dineInAdvanceTime = _dineInAdvanceTimeController.text.trim();
                  String customOrderDate = _customerOrderDaysController.text.trim();

                  if(restController.isExtraPackagingEnabled && extraPackagingAmount.isEmpty) {
                    showCustomSnackBar('enter_restaurant_extra_packaging_charge'.tr);
                  }else if(minimumOrder.isEmpty) {
                    showCustomSnackBar('enter_minimum_order_amount'.tr);
                  }else if(_restaurant.selfDeliverySystem == 1 && perKmFee.isNotEmpty && minimumFee.isEmpty) {
                    showCustomSnackBar('enter_minimum_delivery_fee'.tr);
                  }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && perKmFee.isEmpty) {
                    showCustomSnackBar('enter_per_km_delivery_fee'.tr);
                  } else if(_restaurant.selfDeliverySystem == 1 && perKmFee.isNotEmpty && double.parse(perKmFee) < 0.0001) {
                    showCustomSnackBar('per_km_fee_must_be_greater_than_0'.tr);
                  }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && (maximumFee.isNotEmpty ? (double.parse(perKmFee) > double.parse(maximumFee)) : false) && double.parse(maximumFee) != 0) {
                    showCustomSnackBar('per_km_charge_can_not_be_more_then_maximum_charge'.tr);
                  }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && (maximumFee.isNotEmpty ? (double.parse(minimumFee) > double.parse(maximumFee)) : false)) {
                    showCustomSnackBar('minimum_charge_can_not_be_more_then_maximum_charge'.tr);
                  }else if(!restController.isRestVeg! && !restController.isRestNonVeg!){
                    showCustomSnackBar('select_at_least_one_food_type'.tr);
                  }else if(restController.isGstEnabled && gstCode.isEmpty){
                    showCustomSnackBar('enter_gst_code'.tr);
                  }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && perKmFee.isNotEmpty && maximumFee.isEmpty) {
                    showCustomSnackBar('enter_maximum_delivery_fee'.tr);
                  }else {
                    List<String> cuisines = [];
                    List<String> restaurantCharacteristics = [];

                    for (var index in restController.selectedCuisines!) {
                      cuisines.add(restController.cuisineModel!.cuisines![index].id.toString());
                    }

                    for (var index in restController.selectedCharacteristicsList!) {
                      restaurantCharacteristics.add(index!);
                    }

                    _restaurant.minimumOrder = double.parse(minimumOrder);
                    _restaurant.gstStatus = restController.isGstEnabled;
                    _restaurant.gstCode = gstCode;
                    _restaurant.minimumShippingCharge = minimumFee.isNotEmpty ? double.parse(minimumFee) : null;
                    _restaurant.maximumShippingCharge = maximumFee.isNotEmpty ? double.parse(maximumFee) : null;
                    _restaurant.perKmShippingCharge = perKmFee.isNotEmpty ? double.parse(perKmFee) : null;
                    _restaurant.veg = restController.isRestVeg! ? 1 : 0;
                    _restaurant.nonVeg = restController.isRestNonVeg! ? 1 : 0;
                    _restaurant.instanceOrder = restController.instantOrder;
                    _restaurant.scheduleOrder = restController.scheduleOrder;
                    _restaurant.isExtraPackagingActive = restController.isExtraPackagingEnabled;
                    _restaurant.extraPackagingStatus = restController.extraPackagingSelectedValue;
                    _restaurant.extraPackagingAmount = extraPackagingAmount.isNotEmpty ? double.parse(extraPackagingAmount) : 0;
                    _restaurant.isDineInActive = restController.isDineInEnabled;
                    _restaurant.scheduleAdvanceDineInBookingDuration = dineInAdvanceTime.isNotEmpty ? int.parse(dineInAdvanceTime) : 0;
                    _restaurant.scheduleAdvanceDineInBookingDurationTimeFormat = restController.selectedTimeType;
                    _restaurant.customOrderDate = customOrderDate.isNotEmpty ? int.parse(customOrderDate) : 0;
                    _restaurant.freeDelivery = restController.freeDeliveryDistanceEnabled;
                    _restaurant.customDateOrderStatus = restController.customDateOrderEnabled;
                    _restaurant.delivery = restController.isDeliveryEnabled;
                    _restaurant.takeAway = restController.isTakeAwayEnabled;
                    _restaurant.orderSubscriptionActive = restController.isSubscriptionOrderEnabled;
                    _restaurant.cutlery = restController.isCutleryEnabled;
                    _restaurant.isHalalActive = restController.isHalalEnabled;

                    restController.updateRestaurant(_restaurant, cuisines);
                  }
                },
                buttonText: 'update'.tr,
              ),
            ),

          ]);
        });
      }),
    );
  }
}