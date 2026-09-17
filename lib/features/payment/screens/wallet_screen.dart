import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/adjust_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/wallet_attention_alert_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/wallet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdrawal_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  void initState() {
    Get.find<PaymentController>().getWithdrawList();
    Get.find<PaymentController>().getWithdrawMethodList();
    Get.find<PaymentController>().getWalletPaymentList();
    Get.find<DisbursementController>().getDisbursementMethodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'wallet'.tr, isBackButtonExist: false),
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<PaymentController>(builder: (paymentController) {
          return (profileController.profileModel != null && paymentController.withdrawList != null) ? profileController.modulePermission!.myWallet! ? RefreshIndicator(
            onRefresh: () async {
              await Get.find<ProfileController>().getProfile();
              await Get.find<PaymentController>().getWithdrawList();
            },
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  WithdrawalWidget(
                    paymentController: paymentController,
                    profileController: profileController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  profileController.profileModel!.adjustable! ? AdjustWidget(
                    paymentController: paymentController,
                    profileController: profileController,
                  ) : const SizedBox(),
                ]),
              ),

              // SizedBox(height: profileController.profileModel!.adjustable! ? Dimensions.paddingSizeLarge : 0),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  physics: const BouncingScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        WalletWidget(title: 'cash_in_hand'.tr, value: profileController.profileModel!.cashInHands, image: Images.cashInHandBgIcon),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        WalletWidget(title: 'withdraw_able_balance'.tr, value: profileController.profileModel!.balance, image: Images.withdrawAbleBalanceBgIcon),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        WalletWidget(title: 'pending_withdraw'.tr, value: profileController.profileModel!.pendingWithdraw, image: Images.pendingWithdrawBgIcon),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        WalletWidget(title: 'already_withdrawn'.tr, value: profileController.profileModel!.alreadyWithdrawn, image: Images.alreadyWithdrawBgIcon),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        WalletWidget(title: 'total_earning'.tr, value: profileController.profileModel!.totalEarning, image: Images.totalWithdrawBgIcon),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Row(children: [

                      InkWell(
                        onTap: () {
                          if(paymentController.selectedIndex != 0) {
                            paymentController.setIndex(0);
                          }
                        },
                        hoverColor: Colors.transparent,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          Text('withdraw_request'.tr, style: robotoMedium.copyWith(
                            color: paymentController.selectedIndex == 0 ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                            fontWeight: paymentController.selectedIndex == 0 ? FontWeight.w500 : FontWeight.w400,
                          )),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Container(
                            height: 3, width: 130,
                            margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: paymentController.selectedIndex == 0 ? Theme.of(context).primaryColor : null,
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      InkWell(
                        onTap: () {
                          if(paymentController.selectedIndex != 1) {
                            paymentController.setIndex(1);
                          }
                        },
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                          Text('payment_history'.tr, style: robotoMedium.copyWith(
                            color: paymentController.selectedIndex == 1 ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                            fontWeight: paymentController.selectedIndex == 1 ? FontWeight.w500 : FontWeight.w400,
                          )),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Container(
                            height: 3, width: 130,
                            margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: paymentController.selectedIndex == 1 ? Theme.of(context).primaryColor : null,
                            ),
                          ),

                        ]),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Text("transaction_history".tr, style: robotoMedium),

                      paymentController.selectedIndex == 0 ? PopupMenuButton(
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            getMenuItem(Get.find<PaymentController>().statusList[0], context),
                            const PopupMenuDivider(),
                            getMenuItem(Get.find<PaymentController>().statusList[1], context),
                            const PopupMenuDivider(),
                            getMenuItem(Get.find<PaymentController>().statusList[2], context),
                            const PopupMenuDivider(),
                            getMenuItem(Get.find<PaymentController>().statusList[3], context),
                          ];
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                        offset: const Offset(-25, 25),
                        child: Container(
                          // margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list_outlined, size: 18, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Text('filter'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ],
                          ),
                        ),
                        onSelected: (dynamic value) {
                          int index = Get.find<PaymentController>().statusList.indexOf(value);
                          Get.find<PaymentController>().filterWithdrawList(index);
                        },
                      ) : InkWell(
                        onTap: () {
                          if(paymentController.selectedIndex == 0) {
                            Get.toNamed(RouteHelper.getWithdrawHistoryRoute());
                          }
                          if(paymentController.selectedIndex == 1) {
                            Get.toNamed(RouteHelper.getPaymentHistoryRoute());
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text('see_all'.tr, style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                          )),
                        ),
                      ),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    if(paymentController.selectedIndex == 0)
                      paymentController.withdrawList != null ? paymentController.withdrawList!.isNotEmpty ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paymentController.withdrawList!.length,
                        itemBuilder: (context, index) {
                          return WithdrawWidget(
                            withdrawModel: paymentController.withdrawList![index],
                            showDivider: index != (paymentController.withdrawList!.length > 25 ? 25 : paymentController.withdrawList!.length-1),
                          );
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 40, bottom: 50), child: Column(children: [
                        const CustomAssetImageWidget(image: Images.noTransactionIcon, height: 50, width: 50),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text('${'no_transaction_found'.tr}!' , style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),

                      ]))) : const Center(child: Padding(padding: EdgeInsets.only(top: 100, bottom: 50), child: CircularProgressIndicator())),

                    if (paymentController.selectedIndex == 1)
                      paymentController.transactions != null ? paymentController.transactions!.isNotEmpty ? ListView.builder(
                        itemCount: paymentController.transactions!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                              child: Row(children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(PriceConverter.convertPrice(paymentController.transactions![index].amount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Text('${'paid_via'.tr} ${paymentController.transactions![index].method?.replaceAll('_', ' ').capitalize??''}', style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor,
                                    )),
                                  ]),
                                ),
                                Text(paymentController.transactions![index].paymentTime.toString(),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                ),
                              ]),
                            ),

                            const Divider(height: 1),
                          ]);
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 40, bottom: 50), child: Column(children: [
                        const CustomAssetImageWidget(image: Images.noTransactionIcon, height: 50, width: 50),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text('${'no_transaction_yet'.tr}!' , style: robotoMedium.copyWith(color: Theme.of(context).hintColor)),

                      ]))) : const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator())),

                  ]),
                ),
              ),

              (profileController.profileModel!.overFlowWarning! || profileController.profileModel!.overFlowBlockWarning!)
                  ? WalletAttentionAlertWidget(isOverFlowBlockWarning: profileController.profileModel!.overFlowBlockWarning!) : const SizedBox(),

            ]),
          ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)) : const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? const Color(0xff9DA7BC) : status == 'Approved' ? const Color(0xff9DA7BC) : status == 'Denied' ? const Color(0xff9DA7BC) : null,
        fontSize: Dimensions.fontSizeLarge,
      )),
    );
  }
}