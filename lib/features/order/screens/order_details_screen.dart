import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_popup_menu_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/details_custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/input_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/edit_history_log_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/order_edit_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/pdf_generate_dialog.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/section_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/invoice_print_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/available_deliveryman_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/bogo_order_item_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/camera_button_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/cancellation_dialogue_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/collect_money_delivery_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/dialogue_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/order_product_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/slider_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/verify_delivery_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  final bool fromNotification;
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderModel, required this.isRunningOrder, this.fromNotification = false, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {

  Timer? _timer;
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _tokenNumberController = TextEditingController();


  void _startApiCalling(){
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().setOrderDetails(OrderModel(id: widget.orderId));
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if(Get.find<OrderController>().showDeliveryImageField){
      Get.find<OrderController>().changeDeliveryImageStatus(willUpdate: false);
    }

    Get.find<OrderController>().pickPrescriptionImage(isRemove: true, isCamera: false);

   Get.find<OrderController>().setOrderDetails(OrderModel(id: widget.orderId)).then((value) {
     _tableNumberController.text = Get.find<OrderController>().orderModel?.orderReference?.tableNumber ?? '';
     _tokenNumberController.text = Get.find<OrderController>().orderModel?.orderReference?.tokenNumber ?? '';
    });

    if(Get.find<ProfileController>().profileModel == null){
      Get.find<ProfileController>().getProfile();
    }

    Get.find<OrderController>().getOrderDetails(widget.orderId);

    _startApiCalling();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startApiCalling();
    }else if(state == AppLifecycleState.paused){
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _timer?.cancel();
  }
  
  @override
  Widget build(BuildContext context) {

    bool? cancelPermission = Get.find<SplashController>().configModel!.canceledByRestaurant;
    late bool selfDelivery;

    if(Get.find<ProfileController>().profileModel != null && Get.find<ProfileController>().profileModel!.restaurants != null){
      selfDelivery = Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1;
    }

    return GetBuilder<OrderController>(builder: (orderController) {

        OrderModel? controllerOrderModel = orderController.orderModel;

        bool restConfModel = Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman';
        bool showSlider = controllerOrderModel != null ? ((controllerOrderModel.orderStatus == 'pending') && ((controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery) || controllerOrderModel.orderType == 'dine_in'))
            || controllerOrderModel.orderStatus == 'confirmed' || controllerOrderModel.orderStatus == 'accepted' || controllerOrderModel.orderStatus == 'processing'
            || (controllerOrderModel.orderStatus == 'accepted' && controllerOrderModel.confirmed != null)
            || (controllerOrderModel.orderStatus == 'handover' && ((selfDelivery || controllerOrderModel.orderType == 'take_away') || controllerOrderModel.orderType == 'dine_in')) : false;
        bool showBottomView = controllerOrderModel != null ? showSlider || controllerOrderModel.orderStatus == 'picked_up' || widget.isRunningOrder : false;
        bool showDeliveryConfirmImage = orderController.showDeliveryImageField && Get.find<SplashController>().configModel!.dmPictureUploadStatus!;

        bool canShowDeliveryMan = controllerOrderModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1
            && controllerOrderModel.orderType != 'take_away'
          && (controllerOrderModel.orderStatus == 'pending' || controllerOrderModel.orderStatus == 'confirmed'
                || controllerOrderModel.orderStatus == 'processing' || controllerOrderModel.orderStatus == 'accepted'
            ) : false;

        double? deliveryCharge = 0;
        double? deliveryTypeCharge = 0;
        double itemsPrice = 0;
        double? discount = 0;
        double? couponDiscount = 0;
        double? dmTips = 0;
        double? tax = 0;
        bool? taxIncluded = false;
        double addOns = 0;
        double additionalCharge = 0;
        double extraPackagingAmount = 0;
        double referrerBonusAmount = 0;
        double proDiscount = 0;
        OrderModel? order = controllerOrderModel;
        Restaurant? restaurant;
        bool subscription = false;
        bool showDeliveryTypeCharge = false;
        if(Get.find<ProfileController>().profileModel != null){
          restaurant = Get.find<ProfileController>().profileModel!.restaurants![0];
        }

        if(order != null && orderController.orderDetailsModel != null ) {

          subscription = order.subscriptionId != null && orderController.subscriptionModel != null;

          if(order.orderType == 'delivery') {
            deliveryCharge = order.deliveryCharge;
            dmTips = order.dmTips;
            if((order.deliveryType == 'slightly_delay' || order.deliveryType == 'express') && order.deliveryTypeCharge != null) {
              deliveryTypeCharge = order.deliveryType == 'slightly_delay'
                  ? -order.deliveryTypeCharge!
                  : order.deliveryTypeCharge!;
            }
          }
          showDeliveryTypeCharge = (order.deliveryType == 'slightly_delay' || order.deliveryType == 'express') && deliveryTypeCharge != 0;


          discount = order.restaurantDiscountAmount;
          tax = order.totalTaxAmount;
          taxIncluded = order.taxStatus;
          couponDiscount = order.couponDiscountAmount;
          additionalCharge = order.additionalCharge ?? 0;
          extraPackagingAmount = order.extraPackagingAmount!;
          referrerBonusAmount = order.referrerBonusAmount!;
          proDiscount = order.proDiscount ?? 0;
          for(OrderDetailsModel orderDetails in orderController.orderDetailsModel!) {
            if(!orderDetails.isBogoItem) {
              for(AddOn addOn in orderDetails.addOns!) {
                addOns = addOns + (addOn.price! * addOn.quantity!);
              }
            }
            itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
          }
        }
        double subTotal = itemsPrice + addOns;
        bool isProDiscount = proDiscount > 0;
        double total = itemsPrice + addOns - discount! + (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount + deliveryTypeCharge - (isProDiscount ? proDiscount : 0);

        final ({String? day, String window})? etaWindow = etaWindowLabel(order);

        //status
        bool canEditOrder = Get.find<ProfileController>().profileModel!.restaurants![0].canEditOrder! && (controllerOrderModel?.orderStatus == 'pending'
            || controllerOrderModel?.orderStatus == 'confirmed' || controllerOrderModel?.orderStatus == 'accepted'
            || controllerOrderModel?.orderStatus == 'processing') && controllerOrderModel?.paymentMethod == 'cash_on_delivery';

        final List<MenuItem> items = [
          if(canEditOrder)
            MenuItem('edit'.tr, Icons.edit, 1, Colors.blue),

          MenuItem('download_invoice'.tr, Icons.download, 2, Colors.indigoAccent),

          if(!GetPlatform.isIOS && !GetPlatform.isWeb)
            MenuItem('print_invoice'.tr, Icons.print, 3, Colors.orange),
        ];

        return PopScope(
          canPop: Navigator.canPop(context),
          onPopInvokedWithResult: (didPop, result) async {
            if(widget.fromNotification) {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            }else {
              return;
            }
          },
          child: Scaffold(

            appBar: CustomAppBarWidget(
              onBackPressed: () {
                if(widget.fromNotification) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                }else {
                  Get.back();
                }
              },
              title: subscription ? 'subscription_order'.tr : '${'order'.tr} # ${widget.orderModel.id}',
              subTitle: order != null && widget.orderModel.orderStatus != null ? '${'order_is'.tr} ${widget.orderModel.orderType == 'dine_in' && widget.orderModel.orderStatus == 'delivered' ? 'served'.tr
              : controllerOrderModel?.orderStatus?.tr ?? widget.orderModel.orderStatus!.tr}' : null,
              menuWidget: CustomPopupMenuButton(
                items: items,
                onSelected: (int value) {
                  if(value == 1) {
                    showCustomBottomSheet(
                      child: OrderEditConfirmationBottomSheet(
                        orderDetailsModel: orderController.orderDetailsModel,
                        orderId: widget.orderModel.id!,
                        orderStatus: controllerOrderModel?.orderStatus ?? widget.orderModel.orderStatus!,
                      ),
                    );
                  } else if(value == 2) {
                    Get.dialog(Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: PdfGenerateDialog(order: order!, orderDetails: orderController.orderDetailsModel),
                    ));
                  } else if(value == 3) {
                    _allowPermission().then((access) {
                      Get.dialog(Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                        insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: InVoicePrintScreen(order: order!, orderDetails: orderController.orderDetailsModel),
                      ));
                    });
                  }
                },
                // The button that anchors the menu
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Icon(Icons.more_vert_sharp),
                ),
              ),
            ),

            body: (orderController.orderDetailsModel != null && controllerOrderModel != null && restaurant != null) ? Column(children: [

              Expanded(child: SingleChildScrollView(
                child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  order?.orderEditLogs != null && order!.orderEditLogs!.isNotEmpty ? Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showCustomBottomSheet(child: EditHistoryLogBottomSheet());
                      },
                      child: Text('(${'edit_history_log'.tr})', style: robotoRegular.copyWith(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue)),
                    ),
                  ) : const SizedBox(),

                  SectionWidget(
                    title: 'general_info'.tr,
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('order_date'.tr, style: robotoRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(
                          DateConverter.dateTimeStringToDateTimeNewFormat(order!.createdAt!),
                          style: robotoRegular,
                        ),
                      ]),
                      const Divider(height: Dimensions.paddingSizeLarge),

                      order.scheduled == 1 ? Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${'scheduled_at'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: robotoRegular),
                        ]),
                        const Divider(height: Dimensions.paddingSizeLarge),
                      ]) : const SizedBox(),

                      etaWindow != null ? Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${'estimated_delivery_time'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Flexible(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if(etaWindow.day != null) Text(
                                etaWindow.day!,
                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.end,
                                textDirection: TextDirection.ltr,
                              ),
                              Text(
                                etaWindow.window,
                                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.end,
                                textDirection: TextDirection.ltr,
                              ),
                            ],
                          )),
                        ]),
                        const Divider(height: Dimensions.paddingSizeLarge),
                      ]) : const SizedBox(),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('order_type'.tr, style: robotoRegular),

                        Text(order.orderType!.tr, style: robotoMedium),
                      ]),
                      const Divider(height: Dimensions.paddingSizeLarge),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('payment_status'.tr, style: robotoRegular),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr
                                : order.paymentMethod == 'wallet' ? 'wallet_payment'.tr : order.paymentMethod == 'cash' ? 'cash'.tr
                                : order.paymentMethod == 'digital_payment' ? 'digital_payment'.tr : order.paymentMethod?.replaceAll('_', ' ')??'',
                            style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                          ),
                        ),
                      ]),
                      const Divider(height: Dimensions.paddingSizeLarge),

                      if(order.deliveryType != null) ... [
                        Row(children: [
                          Text('delivery_type'.tr, style: robotoRegular),
                          const Expanded(child: SizedBox()),

                          Text(order.deliveryType?.replaceAll('_', ' ').capitalize??'', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                        ]),
                        const Divider(height: Dimensions.paddingSizeLarge),
                      ],

                      subscription ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(children: [
                          Text('${'subscription_date'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(
                            '${DateConverter.convertDateToDate(orderController.subscriptionModel!.startAt!)} '
                                '- ${DateConverter.convertDateToDate(orderController.subscriptionModel!.endAt!)}',
                            style: robotoRegular,
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          Text('${'subscription_type'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(orderController.subscriptionModel!.type!.tr, style: robotoRegular),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        const Divider(height: Dimensions.paddingSizeLarge),
                      ]) : const SizedBox(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [
                          Text('${'item'.tr}:', style: robotoRegular),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            orderController.orderDetailsModel!.length.toString(),
                            style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          const Expanded(child: SizedBox()),
                          Container(height: 7, width: 7, decoration: BoxDecoration(
                              color: (order.orderStatus == 'failed' || order.orderStatus == 'canceled' || order.orderStatus == 'refund_request_canceled')
                                  ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            order.orderStatus == 'delivered' ? '${'delivered_at'.tr} ${order.delivered != null ? DateConverter.dateTimeStringToDateTime(order.delivered!) : ''}'
                                : order.orderStatus!.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ]),
                      ),
                      const Divider(height: Dimensions.paddingSizeLarge),

                      order.cutlery != null && order.orderType != 'dine_in' ? Row(children: [
                        Text('${'cutlery'.tr}: ', style: robotoRegular),
                        const Expanded(child: SizedBox()),

                        Text(
                          order.cutlery! ? 'yes'.tr : 'no'.tr,
                          style: robotoRegular,
                        ),
                      ]) : const SizedBox(),
                      order.unavailableItemNote != null ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      order.unavailableItemNote != null && order.orderType == 'delivery' ? Row(children: [
                        Text('${'if_item_is_not_available'.tr}: ', style: robotoMedium),

                        Text(
                          order.unavailableItemNote!.tr,
                          style: robotoRegular,
                        ),
                      ]) : const SizedBox(),
                      order.unavailableItemNote != null && order.orderType == 'delivery' ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

                      order.deliveryInstruction != null && order.orderType == 'delivery' ? Row(children: [
                        Text('${'delivery_instruction'.tr}: ', style: robotoMedium),

                        Text(
                          order.deliveryInstruction!.tr,
                          style: robotoRegular,
                        ),
                      ]) : const SizedBox(),
                      order.deliveryInstruction != null && order.orderType == 'delivery' ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

                      SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

                      order.bringChangeAmount != null && order.bringChangeAmount! > 0 ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: const Color(0XFF009AF1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: 'please_bring'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            TextSpan(text: ' ${PriceConverter.convertPrice(order.bringChangeAmount)}', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            TextSpan(text: ' ${'in_change_for_the_customer_when_making_the_delivery'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                          ]),
                        ),
                      ) : const SizedBox(),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  order.orderType == 'dine_in' ? SectionWidget(
                    title: 'order_setup'.tr,
                    child: Column(children: [

                      Row(children: [

                        Expanded(
                          child: CustomTextFieldWidget(
                            labelText: 'table_number'.tr,
                            hintText: 'table_number'.tr,
                            controller: _tableNumberController,
                            isEnabled: widget.orderModel.orderStatus == 'delivered' ? false : true,
                            hideEnableText: widget.orderModel.orderStatus == 'delivered' ? true : false,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(
                          child: CustomTextFieldWidget(
                            labelText: 'token_number'.tr,
                            hintText: 'token_number'.tr,
                            controller: _tokenNumberController,
                            isEnabled: widget.orderModel.orderStatus == 'delivered' ? false : true,
                            hideEnableText: widget.orderModel.orderStatus == 'delivered' ? true : false,
                          ),
                        ),

                      ]),
                      SizedBox(height: widget.orderModel.orderStatus == 'delivered' ? 0 : Dimensions.paddingSizeLarge),

                      widget.orderModel.orderStatus == 'delivered' ? const SizedBox() : Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 100,
                          height: 35,
                          child: CustomButtonWidget(
                            buttonText: (order.orderReference?.tableNumber != null) || (order.orderReference?.tokenNumber != null) ? 'update'.tr : 'save'.tr,
                            isLoading: orderController.isLoading,
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              String tableNumber = _tableNumberController.text;
                              String tokenNumber = _tokenNumberController.text;

                              if (tableNumber.length > 10) {
                                showCustomSnackBar('table_number_cannot_exceed_10_characters'.tr);
                              }else if (tokenNumber.length > 10) {
                                showCustomSnackBar('token_number_cannot_exceed_10_characters'.tr);
                              }else {
                                orderController.addDineInTableAndTokenNumber(
                                  orderId: order.id,
                                  tableNumber: tableNumber,
                                  tokenNumber: tokenNumber,
                                );
                              }
                            },
                          ),
                        ),
                      ),


                    ]),
                  ) : const SizedBox(),
                  SizedBox(height: order.orderType == 'dine_in' ? Dimensions.paddingSizeSmall : 0),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xffBDBDBD).withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 10))],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            Text(
                              'item_info'.tr,
                              style: robotoSemiBold,
                            ),

                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                // borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${groupBogoOrderDetails(orderController.orderDetailsModel!).length}',
                                style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault                                           ),
                              ),
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Builder(builder: (context) {
                              final List<Object> groupedItems = groupBogoOrderDetails(orderController.orderDetailsModel!);

                              return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: groupedItems.length,
                                itemBuilder: (context, index) {
                                  final Object item = groupedItems[index];

                                  return Column(children: [
                                    item is BogoOrderItemGroup
                                        ? BogoOrderItemWidget(group: item)
                                        : OrderProductWidget(order: order, orderDetails: item as OrderDetailsModel),

                                    index == groupedItems.length - 1 ? const SizedBox() : const Divider(height: Dimensions.paddingSizeLarge),
                                  ]);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.orderNote  != null && order.orderNote!.isNotEmpty) ? SectionWidget(
                    title: 'additional_note'.tr,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 3),
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        order.orderNote!.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

                  DetailsCustomCard(
                    isBorder: false,
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('delivery_information'.tr, style: robotoSemiBold),

                        if(canEditOrder && order.orderType == 'delivery')
                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getEditDeliveryAddressRoute(deliveryAddress: order.deliveryAddress!, orderId: order.id!));
                          },
                          child: Icon(Icons.edit, size: 20, color: Colors.blue),
                        ),
                      ]),
                      Divider(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: '${'name'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                          TextSpan(
                            text: order.deliveryAddress?.contactPersonName ?? '',
                            style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                          TextSpan(text: ' (${order.deliveryAddress?.contactPersonNumber})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Wrap(children: [

                        (order.deliveryAddress?.streetNumber != null && order.deliveryAddress!.streetNumber!.isNotEmpty) ? RichText(
                          text: TextSpan(children: [
                            TextSpan(text: '${'street_number'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                            TextSpan(
                              text: order.deliveryAddress?.streetNumber ?? '',
                              style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                          ]),
                        ) : const SizedBox(),

                        (order.deliveryAddress?.streetNumber != null && order.deliveryAddress!.streetNumber!.isNotEmpty) ? Container(
                          height: 12, width: 1, color: Theme.of(context).hintColor,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        ) : const SizedBox(),

                        (order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty) ? RichText(
                          text: TextSpan(children: [
                            TextSpan(text: '${'house'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                            TextSpan(
                              text: order.deliveryAddress?.house ?? '',
                              style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                          ]),
                        ) : const SizedBox(),

                        (order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty) ? Container(
                          height: 12, width: 1, color: Theme.of(context).hintColor,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        ) : const SizedBox(),

                        (order.deliveryAddress?.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? RichText(
                          text: TextSpan(children: [
                            TextSpan(text: '${'floor'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                            TextSpan(
                              text: order.deliveryAddress?.floor ?? '',
                              style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                            ),
                          ]),
                        ) : const SizedBox(),

                      ]),
                      SizedBox(
                        height: (order.deliveryAddress?.streetNumber != null && order.deliveryAddress!.streetNumber!.isNotEmpty) || (order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty)
                        || (order.deliveryAddress?.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,
                      ),

                      Row(children: [

                        Icon(Icons.location_on, size: 20, color: Theme.of(context).hintColor),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Expanded(
                          child: Text(
                            order.deliveryAddress?.address ?? '',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ]),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SectionWidget(
                    title: '${'customer_details'.tr} ${order.isGuest! ? '(${'guest_user'.tr})' : ''}',
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        ClipOval(child: CustomImageWidget(
                          image: order.customer != null ? '${order.customer!.imageFullUrl}' : '',
                          height: 50, width: 50, fit: BoxFit.cover,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: order.deliveryAddress != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            order.deliveryAddress?.contactPersonName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text(
                            order.deliveryAddress?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Wrap(children: [
                            (order.deliveryAddress?.streetNumber != null && order.deliveryAddress!.streetNumber!.isNotEmpty)
                                ? Text(
                              '${'street_number'.tr}: ${order.deliveryAddress!.streetNumber!}${(order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty) ? ', ' : ' '}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ) : const SizedBox(),

                            (order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty) ? Text('${'house'.tr}: ${order.deliveryAddress!.house!}${(order.deliveryAddress!.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? ', ' : ' '}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                            ) : const SizedBox(),

                            (order.deliveryAddress?.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${order.deliveryAddress!.floor!}' ,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                            ) : const SizedBox(),
                          ]),

                        ]) : Text('walking_customer'.tr, style: robotoMedium)),

                        Column(
                          children: [
                            (order.orderType == 'take_away' && (order.orderStatus == 'pending' || order.orderStatus == 'confirmed'
                            || order.orderStatus == 'processing')) ? TextButton.icon(
                              onPressed: () async {
                                String url ='https://www.google.com/maps/dir/?api=1&destination=${order.deliveryAddress?.latitude}'
                                    ',${order.deliveryAddress?.longitude}&mode=d';
                                if (await canLaunchUrlString(url)) {
                                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                                }else {
                                  showCustomSnackBar('unable_to_launch_google_map'.tr);
                                }
                              },
                              icon: const Icon(Icons.directions), label: Text('direction'.tr),
                            ) : const SizedBox(),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Row(children: [
                              (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                                  && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded' && orderController.orderModel!.customer?.id != null) ? InkWell(
                                onTap: () async {
                                  if(await canLaunchUrlString('tel:${order.customer!.phone ?? '' }')) {
                                    launchUrlString('tel:${order.customer!.phone ?? '' }', mode: LaunchMode.externalApplication);
                                  }else {
                                    showCustomSnackBar('${'can_not_launch'.tr} ${order.customer!.phone ?? ''}');
                                  }
                                },
                                child: Image.asset(
                                  Images.phoneIcon, height: 30, width: 30,
                                ),
                              ) : const SizedBox(),
                              const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                              (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                                  && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded' && orderController.orderModel!.customer?.id != null && !orderController.orderModel!.isGuest!) ? InkWell(
                                onTap: () async {
                                  if(Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0 && Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription') {

                                    showCustomSnackBar('you_have_no_available_subscription'.tr);

                                  }else if(!Get.find<ProfileController>().modulePermission!.chat!){
                                    showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                                  }else{
                                    _timer?.cancel();
                                    await Get.toNamed(RouteHelper.getChatRoute(
                                      notificationBody: NotificationBodyModel(
                                        orderId: orderController.orderModel!.id,
                                        customerId: orderController.orderModel!.customer!.id,
                                      ),
                                      user: User(
                                        id: orderController.orderModel!.customer!.id,
                                        fName: orderController.orderModel!.customer!.fName,
                                        lName: orderController.orderModel!.customer!.lName,
                                        imageFullUrl: orderController.orderModel!.customer!.imageFullUrl,
                                      ),
                                    ));
                                    _startApiCalling();
                                  }
                                },
                                child: Image.asset(
                                  Images.chatIcon, height: 30, width: 30,
                                ),
                              ) : const SizedBox(),
                            ]),
                          ],
                        ),

                      ]),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.deliveryMan != null && order.orderType != 'dine_in') ? SectionWidget(
                    title: "delivery_man_info".tr,
                    titleWidget: canShowDeliveryMan ? InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true, useRootNavigator: true, context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                              topRight: Radius.circular(Dimensions.radiusExtraLarge),
                            ),
                          ),
                          builder: (context) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7, minHeight: 200),
                              child: AvailableDeliveryManBottomSheetWidget(orderId: order.id!, assignedDeliveryManId: order.deliveryMan?.id),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('change'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall)),
                      ),
                    ) : const SizedBox(),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Row(children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImageWidget(
                            image: order.deliveryMan != null ? '${order.deliveryMan!.imageFullUrl}' : '',
                            height: 65, width: 65, fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),

                          Text(
                            order.deliveryMan!.email!, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),

                        ])),

                        (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                        && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded') ? InkWell(
                          onTap: () async {
                            if(await canLaunchUrlString('tel:${order.deliveryMan!.phone ?? '' }')) {
                              launchUrlString('tel:${order.deliveryMan!.phone ?? '' }', mode: LaunchMode.externalApplication);
                            }else {
                              showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone ?? ''}');
                            }
                          },
                          child: Image.asset(
                            Images.phoneIcon, height: 30, width: 30,
                          ),
                        ) : const SizedBox(),

                        SizedBox(width: controllerOrderModel.orderStatus == 'delivered' ? 0 : Dimensions.paddingSizeDefault),

                        (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                        && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded') ? InkWell(
                          onTap: () async {
                            if(Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0
                                && Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription') {
                              showCustomSnackBar('you_have_no_available_subscription'.tr);

                            }else if(!Get.find<ProfileController>().modulePermission!.chat!){
                              showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                            }else{
                              _timer?.cancel();
                              await Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBodyModel(
                                  orderId: orderController.orderModel!.id, deliveryManId: order.deliveryMan!.id,
                                ),
                                user: User(
                                  id: orderController.orderModel!.deliveryMan!.id, fName: orderController.orderModel!.deliveryMan!.fName,
                                  lName: orderController.orderModel!.deliveryMan!.lName, imageFullUrl: orderController.orderModel!.deliveryMan!.imageFullUrl,
                                ),
                              ));
                              _startApiCalling();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text('chat'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),
                            ),

                          ),
                        ) : const SizedBox(),

                      ]),
                    ),
                  ) : Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1 && canShowDeliveryMan && order.orderType != 'dine_in' ? SectionWidget(
                    title: 'delivery_man_info'.tr,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true, useRootNavigator: true, context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                              topRight: Radius.circular(Dimensions.radiusExtraLarge),
                            ),
                          ),
                          builder: (context) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7, minHeight: 200),
                              child: AvailableDeliveryManBottomSheetWidget(orderId: order.id!, assignedDeliveryManId: order.deliveryMan?.id),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 90, width: context.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          const Icon(Icons.add, size: 25,),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text(
                            "assign_delivery_man".tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),
                        ]),
                      ),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  (controllerOrderModel.orderStatus == 'delivered' && controllerOrderModel.orderProofFullUrl != null
                  && controllerOrderModel.orderProofFullUrl!.isNotEmpty) ? SectionWidget(
                    title: 'order_proof'.tr,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.5,
                        crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controllerOrderModel.orderProofFullUrl!.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => openDialog(context, controllerOrderModel.orderProofFullUrl![index]),
                            child: Center(child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImageWidget(
                                image: controllerOrderModel.orderProofFullUrl![index],
                                width: 100, height: 100,
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (controllerOrderModel.orderStatus == 'delivered' && controllerOrderModel.orderProofFullUrl != null
                  && controllerOrderModel.orderProofFullUrl!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

                  SectionWidget(
                    title: 'payment_method'.tr,
                    titleWidget: Text(order.paymentStatus!.tr, style: robotoMedium.copyWith(color: order.paymentStatus == 'paid' ? Colors.green : Colors.red),),
                    titleSpace: true,
                    child: Column(children: [
                      Row(children: [
                        const CustomAssetImageWidget(image: Images.cash, height: 20, width: 20),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr
                            : order.paymentMethod == 'wallet' ? 'wallet_payment'.tr : order.paymentMethod == 'cash' ? 'cash'.tr
                            : order.paymentMethod == 'digital_payment' ? 'digital_payment'.tr : order.paymentMethod?.replaceAll('_', ' ')??'',
                            style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('item_price'.tr, style: robotoRegular),
                        Text(PriceConverter.convertPrice(itemsPrice), style: robotoRegular, textDirection: TextDirection.ltr),
                      ]),
                      const SizedBox(height: 10),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('addons'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(addOns)}', style: robotoRegular, textDirection: TextDirection.ltr,),
                      ]),

                      Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('subtotal'.tr, style: robotoMedium),
                        Text(PriceConverter.convertPrice(subTotal), style: robotoMedium, textDirection: TextDirection.ltr),
                      ]),
                      const SizedBox(height: 10),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('discount'.tr, style: robotoRegular),
                        Text('(-) ${PriceConverter.convertPrice(discount)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]),
                      const SizedBox(height: 10),

                      isProDiscount ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('discount_pro'.tr, style: robotoRegular),
                        Text('(-) ${PriceConverter.convertPrice(proDiscount)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]) : const SizedBox(),
                      SizedBox(height: isProDiscount ? 10 : 0),

                      couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('coupon_discount'.tr, style: robotoRegular),
                        Text(
                          '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                          style: robotoRegular, textDirection: TextDirection.ltr,
                        ),
                      ]) : const SizedBox(),
                      SizedBox(height: couponDiscount > 0 ? 10 : 0),

                      (referrerBonusAmount > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('referral_discount'.tr, style: robotoRegular),
                        Text('(-) ${PriceConverter.convertPrice(referrerBonusAmount)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]) : const SizedBox(),
                      SizedBox(height: referrerBonusAmount > 0 ? 10 : 0),

                      taxIncluded || (tax == 0) ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('vat_tax'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(tax)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]),
                      SizedBox(height: taxIncluded || (tax == 0) ? 0 : 10),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('delivery_man_tips'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(dmTips)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]),
                      const SizedBox(height: 10),

                      (extraPackagingAmount > 0) && order.orderType != 'dine_in' ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('extra_packaging'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(extraPackagingAmount)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]) : const SizedBox(),
                      SizedBox(height: (extraPackagingAmount > 0) && order.orderType != 'dine_in' ? 10 : 0),

                      (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(order.additionalCharge)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]) : const SizedBox(),
                      (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                      showDeliveryTypeCharge ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text("${'${order.deliveryType}'.tr} ${'delivery'.tr}", style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(deliveryTypeCharge)}', style: robotoRegular, textDirection: TextDirection.ltr),
                      ]) : const SizedBox.shrink(),
                      showDeliveryTypeCharge ? const SizedBox(height: 10) : const SizedBox(),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('delivery_fee'.tr, style: robotoRegular),
                        Text(
                          '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                          style: robotoRegular, textDirection: TextDirection.ltr,
                        ),
                      ]),



                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: Divider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                      ),

                      order.paymentMethod == 'partial_payment' ? DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [8, 5],
                          padding: const EdgeInsets.all(0),
                          radius: const Radius.circular(Dimensions.radiusDefault),
                        ),
                        child: Ink(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          color: restConfModel ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Colors.transparent,
                          child: Column(children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('total_amount'.tr, style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                              )),
                              Text(
                                PriceConverter.convertPrice(total),
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                              ),
                            ]),
                            const SizedBox(height: 10),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('paid_by_wallet'.tr, style: restConfModel ? robotoMedium : robotoRegular),
                              Text(
                                PriceConverter.convertPrice(order.payments![0].amount),
                                style: restConfModel ? robotoMedium : robotoRegular,
                              ),
                            ]),
                            const SizedBox(height: 10),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('${order.payments![1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments![1].paymentMethod?.tr})', style: restConfModel ? robotoMedium : robotoRegular),
                              Text(
                                PriceConverter.convertPrice(order.payments![1].amount),
                                style: restConfModel ? robotoMedium : robotoRegular,
                              ),
                            ]),
                          ]),
                        ),
                      ) : const SizedBox(),

                      // order.paymentMethod != 'partial_payment' ? Row(children: [
                      //   Text('total_amount'.tr, style: robotoMedium.copyWith(
                      //     fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                      //   )),
                      //
                      //   taxIncluded ? Text(' ${'vat_tax_inc'.tr}', style: robotoMedium.copyWith(
                      //     fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                      //   )) : const SizedBox(),
                      //
                      //   const Expanded(child: SizedBox()),
                      //
                      //   Text(
                      //     PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                      //     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                      //   ),
                      // ]) : const SizedBox(),
                    ]),
                  ),

                ]))),
              )),

              showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderType == 'delivery' ? Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text('completed_after_delivery_picture'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: orderController.pickedPrescriptions.length+1,
                      itemBuilder: (context, index) {
                        XFile? file = index == orderController.pickedPrescriptions.length ? null : orderController.pickedPrescriptions[index];
                        if(index < 5 && index == orderController.pickedPrescriptions.length) {
                          return InkWell(
                            onTap: () {
                              if(GetPlatform.isIOS) {
                                Get.find<OrderController>().pickPrescriptionImage(isRemove: false, isCamera: false);
                              } else {
                                Get.bottomSheet(const CameraButtonSheetWidget());
                              }
                            },
                            child: Container(
                              height: 60, width: 60, alignment: Alignment.center, decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            ),
                              child:  Icon(Icons.camera_alt_sharp, color: Theme.of(context).primaryColor, size: 32),
                            ),
                          );
                        }
                        return file != null ? Container(
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: GetPlatform.isWeb ? Image.network(
                                file.path, width: 60, height: 60, fit: BoxFit.cover,
                              ) : Image.file(
                                File(file.path), width: 60, height: 60, fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0, top: 0,
                              child: InkWell(
                                onTap: () => orderController.removePrescriptionImage(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
                                ),
                              ),
                            ),
                          ]),
                        ) : const SizedBox();
                      },
                    ),
                  ),

                ]),
              ) : const SizedBox(),

              SafeArea(
                child: Container(
                  // padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: (showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered')
                  || (showBottomView || (controllerOrderModel.orderStatus == 'picked_up')) || (showSlider || ((controllerOrderModel.orderStatus == 'pending') && ((controllerOrderModel.orderType == 'take_away'
                  || restConfModel || selfDelivery) || controllerOrderModel.orderType == 'dine_in') && cancelPermission!)) ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow:  [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ) : null,
                  child: Column(
                    children: [

                      order.paymentMethod != 'partial_payment' ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall,),
                        child: Row(children: [
                          Text('total_amount'.tr, style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                          )),

                          taxIncluded ? Text(' ${'vat_tax_inc'.tr}', style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                          )) : const SizedBox(),

                          const Expanded(child: SizedBox()),

                          Text(
                            PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                        ]),
                      ) : const SizedBox(),

                      showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered' ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CustomButtonWidget(
                          buttonText: 'complete_delivery'.tr,
                          onPressed: () {
                            if(Get.find<SplashController>().configModel!.orderDeliveryVerification!) {
                              orderController.sendDeliveredNotification(controllerOrderModel.id);

                              Get.bottomSheet(VerifyDeliverySheetWidget(
                                orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                              ), isScrollControlled: true).then((isSuccess) {

                                if(isSuccess && controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery')){
                                  Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                                    orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                    orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                    cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                                  ), isScrollControlled: true, isDismissible: false);
                                }
                              });
                            } else {
                              Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                                orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                              ), isScrollControlled: true);
                            }
                          },
                        ),
                      ) : showBottomView ? (controllerOrderModel.orderStatus == 'picked_up') ? Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text('food_is_on_the_way'.tr, style: robotoMedium),
                      ) : showSlider ? ((controllerOrderModel.orderStatus == 'pending') && ((controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery) || controllerOrderModel.orderType == 'dine_in') && cancelPermission!) ? Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          Expanded(child: TextButton(
                            onPressed: () {
                              orderController.setOrderCancelReason('');
                              Get.dialog(CancellationDialogueWidget(orderId: order.id));
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                              backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                            ),
                            child: Text('cancel'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeLarge,
                            )),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(child: CustomButtonWidget(
                            buttonText: 'confirm'.tr, height: 40,
                            onPressed: () {
                              Get.dialog(ConfirmationDialogWidget(
                                icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                                onYesPressed: () {
                                  orderController.updateOrderStatus(controllerOrderModel.id, 'confirmed', back: false).then((success) {
                                    if(success) {
                                      Get.find<ProfileController>().getProfile();
                                      Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                      // Get.find<OrderController>().getCurrentOrders();
                                    }
                                  });
                                },
                              ), barrierDismissible: false);
                            },
                          )),
                        ]),
                      ) : Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: SliderButtonWidget(
                          action: () {
                            if(controllerOrderModel.orderStatus == 'pending' && ((controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery) || controllerOrderModel.orderType == 'dine_in')) {
                              Get.dialog(ConfirmationDialogWidget(
                                icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                                onYesPressed: () {
                                  orderController.updateOrderStatus(controllerOrderModel.id, 'confirmed', back: false).then((success) {
                                    if(success) {
                                      Get.find<ProfileController>().getProfile();
                                      Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                      Get.find<OrderController>().getCurrentOrders();
                                    }
                                  });
                                },
                                onNoPressed: () {
                                  if(cancelPermission!) {
                                    orderController.updateOrderStatus(controllerOrderModel.id, 'canceled', back: false).then((success) {
                                      if(success) {
                                        Get.find<ProfileController>().getProfile();
                                        Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                        Get.find<OrderController>().getCurrentOrders();
                                      }
                                    });
                                  }else {
                                    Get.back();
                                  }
                                },
                              ), barrierDismissible: false);
                            }else if(controllerOrderModel.orderStatus == 'processing') {
                              Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, 'handover', backWitheResult: false).then((success) {
                                if(success) {
                                  Get.find<ProfileController>().getProfile();
                                  Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                  Get.find<OrderController>().getCurrentOrders();
                                }
                              });
                            }else if(controllerOrderModel.orderStatus == 'confirmed' || (controllerOrderModel.orderStatus == 'accepted'
                                && (controllerOrderModel.confirmed != null || controllerOrderModel.accepted != null))) {
                              Get.dialog(InputDialogWidget(
                                icon: Images.warning,
                                title: 'are_you_sure_to_confirm'.tr,
                                description: 'enter_processing_time_in_minutes'.tr, onPressed: (String? time){
                                Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, 'processing', processingTime: time).then((success) {
                                  if(success) {
                                    Get.find<ProfileController>().getProfile();
                                    Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                    Get.find<OrderController>().getCurrentOrders();
                                  }
                                });
                              },
                              ));
                            }else if((controllerOrderModel.orderStatus == 'handover' && ((controllerOrderModel.orderType == 'take_away' || selfDelivery) || controllerOrderModel.orderType == 'dine_in'))) {
                              if ((Get.find<SplashController>().configModel!.orderDeliveryVerification! || controllerOrderModel.paymentMethod == 'cash_on_delivery')) {
                                orderController.changeDeliveryImageStatus();
                                if(Get.find<SplashController>().configModel!.dmPictureUploadStatus! && controllerOrderModel.orderType == 'delivery') {
                                  Get.dialog(const DialogImageWidget(), barrierDismissible: false);
                                } else {
                                  if(Get.find<SplashController>().configModel!.orderDeliveryVerification!){
                                    orderController.sendDeliveredNotification(controllerOrderModel.id);

                                    Get.bottomSheet(VerifyDeliverySheetWidget(
                                      orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                      orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                      cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                                    ), isScrollControlled: true).then((isSuccess) {


                                      if(isSuccess && controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery')){
                                        Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                                          orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                          orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                          cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                                        ), isScrollControlled: true, isDismissible: false);
                                      }
                                    });
                                  } else {
                                    Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                                      orderID: controllerOrderModel.id, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                                      orderAmount: order.paymentMethod == 'partial_payment' ? order.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                                      cod: controllerOrderModel.paymentMethod == 'cash_on_delivery' || (order.paymentMethod == 'partial_payment' && order.payments![1].paymentMethod == 'cash_on_delivery'),
                                    ), isScrollControlled: true);
                                  }
                                }
                              } else {
                                Get.find<OrderController>().updateOrderStatus(controllerOrderModel.id, 'delivered').then((success) {
                                  if (success) {
                                    Get.find<ProfileController>().getProfile();
                                    Get.find<OrderController>().setOrderDetails(OrderModel(id: controllerOrderModel.id));
                                    Get.find<OrderController>().getCurrentOrders();
                                  }
                                });
                              }
                            }
                          },
                          label: Text(
                            (controllerOrderModel.orderStatus == 'pending' && ((controllerOrderModel.orderType == 'take_away' || restConfModel || selfDelivery) || controllerOrderModel.orderType == 'dine_in'))
                              ? 'swipe_to_confirm_order'.tr : (controllerOrderModel.orderStatus == 'confirmed' || (controllerOrderModel.orderStatus == 'accepted'
                              && (controllerOrderModel.confirmed != null || controllerOrderModel.accepted != null))) ? 'swipe_to_cooking'.tr
                              : (controllerOrderModel.orderStatus == 'processing') ? 'swipe_if_ready_for_handover'.tr
                              : (controllerOrderModel.orderStatus == 'handover' && ((controllerOrderModel.orderType == 'take_away' || selfDelivery) || controllerOrderModel.orderType == 'dine_in'))
                              ? controllerOrderModel.orderType == 'dine_in' ? 'swipe_to_complete'.tr : 'swipe_to_deliver_order'.tr : '',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                          ),
                          dismissThresholds: 0.5, dismissible: false, shimmer: true,
                          width: 1170, height: 60, buttonSize: 50, radius: 10,
                          icon: Center(child: Icon(
                            Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
                            color: Colors.white, size: 20.0,
                          )),
                          isLtr: Get.find<LocalizationController>().isLtr,
                          boxShadow: const BoxShadow(blurRadius: 0),
                          buttonColor: Theme.of(context).primaryColor,
                          backgroundColor: const Color(0xffF4F7FC),
                          baseColor: Theme.of(context).primaryColor,
                        ),
                      ) : const SizedBox() : const SizedBox(),
                    ],
                  ),
                ),
              ),

            ]) : const Center(child: CircularProgressIndicator()),
          ),
        );
      }
    );
  }

  void openDialog(BuildContext context, String imageUrl) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
        child: Stack(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            ),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            splashRadius: 5,
            onPressed: () => Get.back(),
            icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
          )),

        ]),
      );
    },
  );
}

Future<bool> _allowPermission() async {
  if (!await _requestAndCheckPermission(Permission.location)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetooth)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetoothConnect)) {
    return false;
  }
  if (!await _requestAndCheckPermission(Permission.bluetoothScan)) {
    return false;
  }

  return true;
}

Future<bool> _requestAndCheckPermission(Permission permission) async {
  await permission.request();
  var status = await permission.status;
  return !status.isDenied;
}


const List<String> _etaClosedStatuses = <String>[
  'delivered', 'canceled', 'failed', 'refunded', 'refund_requested', 'refund_request_canceled',
];

const List<String> _etaMonths = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];


({String? day, String window})? etaWindowLabel(OrderModel? order) {
  if(order == null) {
    return null;
  }

  if(order.orderType == 'dine_in') {
    return null;
  }

  if(_etaClosedStatuses.contains(order.orderStatus)) {
    return null;
  }

  final String window = order.eta?.window?.trim() ?? '';
  if(window.isEmpty) {
    return null;
  }

  final String? day = _etaDayLabel(order.eta?.fromAt ?? order.scheduleAt);
  return (day: day, window: window);
}

String? _etaDayLabel(String? stamp) {
  if(stamp == null || stamp.length < 10) {
    return null;
  }

  try {
    final DateTime stampDay = DateTime.parse(stamp.substring(0, 10));
    final DateTime now = DateTime.now();
    final int dayGap = DateTime(stampDay.year, stampDay.month, stampDay.day)
        .difference(DateTime(now.year, now.month, now.day)).inDays;

    if(dayGap == 0) {
      return 'today'.tr;
    }
    if(dayGap == 1) {
      return 'tomorrow'.tr;
    }
    return '${stampDay.day.toString().padLeft(2, '0')} ${_etaMonths[stampDay.month - 1]}';
  } catch (_) {
    return null;
  }
}
