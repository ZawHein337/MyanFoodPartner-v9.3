import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/gap_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/billing_info_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/change_subscription_plan_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/subscription_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class SubscriptionDetailsWidget extends StatefulWidget {
  final SubscriptionController subscriptionController;
  const SubscriptionDetailsWidget({super.key, required this.subscriptionController});

  @override
  State<SubscriptionDetailsWidget> createState() => _SubscriptionDetailsWidgetState();
}

class _SubscriptionDetailsWidgetState extends State<SubscriptionDetailsWidget> {

  final JustTheController tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {

    bool businessIsCommission = widget.subscriptionController.profileModel!.restaurants![0].restaurantBusinessModel == 'commission';

    int remainingDays = widget.subscriptionController.profileModel!.subscription != null ? DateConverter.differenceInDaysIgnoringTime(DateTime.parse(widget.subscriptionController.profileModel!.subscription!.expiryDate!), null) : 0;

    return Column(children: [

      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: businessIsCommission ? Column(children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text('commission_base_plan'.tr, style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const Gap(Dimensions.paddingSizeDefault),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    ),
                    child: Row(children: [
                      Image.asset(Images.commissionIcon, width: 35, height: 35),
                      const Gap.horizontal(Dimensions.paddingSizeDefault),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${Get.find<SplashController>().configModel?.adminCommission} %', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        const Gap(Dimensions.paddingSizeExtraSmall),

                        Text('commission_per_order'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                      ]),
                    ]),
                  ),
                  const Gap(Dimensions.paddingSizeSmall),

                  Text(
                    "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor, height: 1.5),
                  ),
                ]),
              ),

            ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text('package_overview'.tr, style: robotoMedium),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                widget.subscriptionController.profileModel!.subscription!.status == 0 ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 5),
                  child: Text('expired'.tr, style: robotoMedium.copyWith(color: Colors.white)),
                ) : const SizedBox(),

                widget.subscriptionController.profileModel!.subscription!.isCanceled == 1 ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 5),
                  child: Text('canceled'.tr, style: robotoMedium.copyWith(color: Colors.white)),
                ) : const SizedBox(),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.subscriptionController.profileModel?.subscription?.package?.packageName ?? '',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(widget.subscriptionController.profileModel?.subscription?.package?.text ?? '',
                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Wrap(alignment: WrapAlignment.end, crossAxisAlignment: WrapCrossAlignment.end, children: [
                        Text('${PriceConverter.convertPrice(widget.subscriptionController.profileModel!.subscription!.package!.price)} /', style: robotoBold.copyWith(fontSize: 22)),

                        Text(' ${widget.subscriptionController.profileModel?.subscription?.validity ?? widget.subscriptionController.profileModel!.subscription!.package!.validity} ${'days'.tr}', style: robotoMedium),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  PackageFeatureItem(
                    title: widget.subscriptionController.profileModel!.subscription!.maxOrder == 'unlimited' ? 'max_order'.tr : '${widget.subscriptionController.profileModel!.subscription?.package?.maxOrder} ${'order'.tr}',
                    leftValue: widget.subscriptionController.profileModel!.subscription!.maxOrder == 'unlimited' ? widget.subscriptionController.profileModel!.subscription!.maxOrder.toString().tr : '${widget.subscriptionController.profileModel!.subscription!.maxOrder} ${'left'.tr}',
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  PackageFeatureItem(
                    title: widget.subscriptionController.profileModel!.subscription!.maxProduct == 'unlimited' ? 'max_product'.tr : '${widget.subscriptionController.profileModel!.subscription?.package?.maxProduct} ${'products_upload'.tr}',
                    leftValue: widget.subscriptionController.profileModel!.subscription!.maxProduct == 'unlimited' ? widget.subscriptionController.profileModel!.subscription!.maxProduct.toString().tr
                        : '${widget.subscriptionController.profileModel!.subscriptionOtherData != null ? widget.subscriptionController.profileModel!.subscriptionOtherData!.maxProductUpload : 0} ${'left'.tr}',
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  widget.subscriptionController.profileModel!.subscription!.pos == 1 ? PackageFeatureItem(title: 'pos_access'.tr) : const SizedBox(),
                  SizedBox(height: widget.subscriptionController.profileModel!.subscription!.pos == 1 ? Dimensions.paddingSizeDefault : 0),

                  widget.subscriptionController.profileModel!.subscription!.mobileApp == 1 ? PackageFeatureItem(title: 'mobile_app_access'.tr) : const SizedBox(),
                  SizedBox(height: widget.subscriptionController.profileModel!.subscription!.mobileApp == 1 ? Dimensions.paddingSizeDefault : 0),

                  widget.subscriptionController.profileModel!.subscription!.chat == 1 ? PackageFeatureItem(title: 'chat'.tr) : const SizedBox(),
                  SizedBox(height: widget.subscriptionController.profileModel!.subscription!.chat == 1 ? Dimensions.paddingSizeDefault : 0),

                  widget.subscriptionController.profileModel!.subscription!.review == 1 ? PackageFeatureItem(title: 'review'.tr) : const SizedBox(),
                  SizedBox(height: widget.subscriptionController.profileModel!.subscription!.review == 1 ? Dimensions.paddingSizeDefault : 0),

                  widget.subscriptionController.profileModel!.subscription!.selfDelivery == 1 ? PackageFeatureItem(title: 'self_delivery'.tr) : const SizedBox(),

                ]),
              ),
              const Gap(Dimensions.paddingSizeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text('billing_details'.tr, style: robotoMedium),

                (DateConverter.differenceInDaysIgnoringTime(DateTime.parse(widget.subscriptionController.profileModel!.subscription!.expiryDate!), null) <= Get.find<SplashController>().configModel!.subscriptionDeadlineWarningDays!
                    && widget.subscriptionController.profileModel!.id != null) ? JustTheTooltip(
                  backgroundColor: const Color(0xffFF6D6D),
                  controller: tooltipController,
                  preferredDirection: AxisDirection.down,
                  tailLength: 14,
                  tailBaseWidth: 20,
                  margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                  content: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text('${'attention'.tr} !!!', style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge)),

                        InkWell(
                          onTap: () {
                            tooltipController.hideTooltip();
                          },
                          child: const Icon(Icons.close, size: 22, color: Colors.white),
                        ),

                      ]),

                      Text(
                        '${'attention_text_1'.tr} ${DateConverter.localDateToMonthDateSince(DateTime.parse(widget.subscriptionController.profileModel!.subscription!.expiryDate!))} ${'attention_text_2'.tr}',
                        style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                      ),

                    ]),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      tooltipController.showTooltip();
                      widget.subscriptionController.showAlert(willUpdate: true);
                    },
                    child: const Icon(Icons.info, size: 22, color: Color(0xffFF6D6D)),
                  ),
                ) : const SizedBox(),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  widget.subscriptionController.profileModel!.subscription!.status == 1 ? BillingInfoWidget(
                    imageIcon: Images.nextBillingDateIcon,
                    title: 'next_billing_date'.tr,
                    value: DateConverter.localDateToMonthDateSince(DateTime.parse(widget.subscriptionController.profileModel!.subscription!.expiryDate!)),
                  ) : BillingInfoWidget(
                    imageIcon: Images.nextBillingDateIcon,
                    title: 'package_expired'.tr,
                    value: DateConverter.localDateToMonthDateSince(DateTime.parse(widget.subscriptionController.profileModel!.subscription!.expiryDate!)),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  BillingInfoWidget(
                    imageIcon: Images.totalBillIcon,
                    title: 'total_bill'.tr,
                    value: (widget.subscriptionController.profileModel!.subscriptionOtherData != null && widget.subscriptionController.profileModel!.subscriptionOtherData!.totalBill != null)
                        ? PriceConverter.convertPrice(widget.subscriptionController.profileModel!.subscriptionOtherData!.totalBill) : '0',
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  BillingInfoWidget(
                    imageIcon: Images.numberOfUsesIcon,
                    title: 'number_of_uses'.tr,
                    value: '${widget.subscriptionController.profileModel!.subscription!.totalPackageRenewed! + 1}',
                  ),

                ]),
              ),
            ]),
          ),
        ),
      ),

      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(children: [

          CustomButtonWidget(
            buttonText: businessIsCommission ? 'change_business_plan'.tr : 'change_or_renew_subscription_plan'.tr,
            radius: Dimensions.radiusDefault,
            height: 55,
            onPressed: () {
              showCustomBottomSheet(
                child: ChangeSubscriptionPlanBottomSheet(businessIsCommission: businessIsCommission),
              );
            },
          ),
          SizedBox(height: !businessIsCommission ? Dimensions.paddingSizeDefault : 0),

          !businessIsCommission && widget.subscriptionController.profileModel!.subscription!.isCanceled == 0 ? InkWell(
            onTap: () {
              Get.dialog(SubscriptionDialogWidget(
                icon: Images.support,
                title: 'are_you_sure'.tr,
                description: '${'if_you_cancel_the_subscription_after'.tr} $remainingDays ${'days_you_will_no_longer_be_able_to_run_the_business_before_subscribe_to_a_new_plan'.tr}',
                onYesPressed: () {
                  widget.subscriptionController.cancelSubscription(widget.subscriptionController.profileModel!.restaurants![0].id!, widget.subscriptionController.profileModel!.subscription!.id!);
                },
              ), useSafeArea: false);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Colors.red),
              ),
              child: Text('cancel_subscription'.tr, style: robotoMedium.copyWith(color: Colors.red, fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
            ),
          ) : const SizedBox(),

        ]),
      ),

    ]);
  }
}

class PackageFeatureItem extends StatelessWidget {
  final String title;
  final String? leftValue;
  const PackageFeatureItem({super.key, required this.title, this.leftValue});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
    
      Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20),
      const SizedBox(width: Dimensions.paddingSizeDefault),
    
      Text(title, style: robotoRegular),
      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

      leftValue != null ? Text('($leftValue)', style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)) : const SizedBox(),
    
    ]);
  }
}
