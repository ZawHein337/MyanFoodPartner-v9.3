import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawRequestBottomSheetWidget extends StatefulWidget {
  const WithdrawRequestBottomSheetWidget({super.key});

  @override
  State<WithdrawRequestBottomSheetWidget> createState() => _WithdrawRequestBottomSheetWidgetState();
}

class _WithdrawRequestBottomSheetWidgetState extends State<WithdrawRequestBottomSheetWidget> {

  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountController.text = Get.find<ProfileController>().profileModel!.balance.toString();
    Get.find<PaymentController>().initWithdrawMethod();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: BoxConstraints(minHeight: context.height * 0.9, maxHeight: context.height * 0.9),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: GetBuilder<DisbursementController>(builder: (disbursementController) {
        return GetBuilder<PaymentController>(builder: (paymentController) {

          final myMethodList = disbursementController.disbursementMethodBody?.methods;
          final othersMethodList = paymentController.widthDrawMethods;
          final List<DropdownItem<String>> groupedItems = [];

          /// --- My Methods Header
          groupedItems.add(
            DropdownItem<String>(
              enabled: false,
              height: 28,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('my_methods'.tr, style: robotoBold.copyWith(color: Colors.grey.withValues(alpha: 0.8), fontSize: Dimensions.fontSizeSmall + 1)),
              ),
            ),
          );
          groupedItems.add(
            const DropdownItem<String>(
              enabled: false,
              height: 28,
              child: Divider(),
            ),
          );

          /// --- My Methods Options
          for (var method in myMethodList!) {
            groupedItems.add(
              DropdownItem<String>(
                value: 'my_${method.id}_${method.methodName ?? ''}',
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(method.methodName ?? '', style: robotoMedium.copyWith(fontSize: 14)),
                ),
              ),
            );
          }

          /// --- Other Methods Header
          groupedItems.add(
            DropdownItem<String>(
              enabled: false,
              height: 28,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('other'.tr, style: robotoBold.copyWith(color: Colors.grey.withValues(alpha: 0.8), fontSize: Dimensions.fontSizeSmall + 1)),
              ),
            ),
          );
          groupedItems.add(
            const DropdownItem<String>(
              enabled: false,
              height: 28,
              child: Divider(),
            ),
          );

          /// --- Other Methods Options
          for (var method in othersMethodList!) {
            groupedItems.add(
              DropdownItem<String>(
                value: 'other_${method.methodName ?? ''}',
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(method.methodName ?? '', style: robotoMedium.copyWith(fontSize: 14)),
                ),
              ),
            );
          }

          /*List<double> _getCustomItemsHeights() {
            final List<double> itemsHeights = [];
            for (int i = 0; i < (items.length * 2) - 1; i++) {
              if (i.isEven) {
                itemsHeights.add(40);
              }
              //Dividers indexes will be the odd indexes
              if (i.isOdd) {
                itemsHeights.add(4);
              }
            }
            return itemsHeights;
          }*/

          return Column(mainAxisSize: MainAxisSize.max, children: [

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(width: 40),

              Container(
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.highlight_remove, color: Theme.of(context).disabledColor, size: 25),
                ),
              ),

            ]),

            Text('withdraw_request'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [

                  Text('secure_and_simple_way_to_withdraw_your_earning'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      hintText: 'enter_withdraw_amount'.tr,
                      labelText: '${'enter_withdraw_amount'.tr} (${Get.find<SplashController>().configModel?.currencySymbol})',
                      controller: _amountController,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.number,
                      focusNode: _amountFocus,
                      inputAction: TextInputAction.done,
                      required: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomDropdownButton(
                    dropdownMenuItems: groupedItems,
                    selectedValue: paymentController.selectedPaymentMethod,
                    hintText: 'select_payment_method'.tr,
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {
                      paymentController.setSelectedPaymentMethod(value);
                      paymentController.setPaymentMethod(value!);

                      int? id = value.startsWith('my_')
                          ? myMethodList.firstWhereOrNull((method) => method.methodName == value.split('_').last)?.withdrawalMethodId
                          : othersMethodList.firstWhereOrNull((method) => method.methodName == value.replaceFirst('other_', ''))?.id;

                      paymentController.setSelectedPaymentMethodId(id);
                    },
                  ),
                  SizedBox(height: paymentController.methodFields.isNotEmpty || paymentController.disMethodFields.isNotEmpty ? Dimensions.paddingSizeLarge : 0),

                  paymentController.disMethodFields.isNotEmpty && paymentController.selectedPaymentMethod!.startsWith('my_') ? Container(
                    padding: const EdgeInsets.only(
                      top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
                      left: Dimensions.paddingSizeDefault - 2, right: Dimensions.paddingSizeDefault,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(children: [

                      Row(children: [

                        const CustomAssetImageWidget(image: Images.paymentMethodIcon, height: 30, width: 30, fit: BoxFit.cover),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(
                          paymentController.selectedPaymentMethod!.split('_').last.capitalize ?? '',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ListView.builder(
                        itemCount: paymentController.disMethodFields.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: index != paymentController.disMethodFields.length-1 ? Dimensions.paddingSizeSmall : 0),
                            child: Row(children: [

                              Text(
                                paymentController.disMethodFields[index].userInput!.replaceAll('_', ' ').capitalize ?? '',
                                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                              ),
                              const Text('  :  ', style: robotoRegular),

                              Expanded(
                                child: Text(
                                  paymentController.textControllerList[paymentController.disMethodFields.indexOf(paymentController.disMethodFields[index])].text,
                                  style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ]),
                          );
                        },
                      ),

                    ]),
                  ) : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: paymentController.methodFields.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(children: [

                          Row(children: [

                            Expanded(
                              child: CustomTextFieldWidget(
                                hintText: paymentController.methodFields[index].placeholder ?? '',
                                labelText: paymentController.methodFields[index].inputName.toString().replaceAll('_', ' ').capitalize ?? '',
                                controller: paymentController.textControllerList[index],
                                capitalization: TextCapitalization.words,
                                inputType: paymentController.methodFields[index].inputType == 'phone' ? TextInputType.phone : paymentController.methodFields[index].inputType == 'number'
                                    ? TextInputType.number : paymentController.methodFields[index].inputType == 'email' ? TextInputType.emailAddress : TextInputType.name,
                                focusNode: paymentController.focusList[index],
                                nextFocus: index != paymentController.methodFields.length-1 ? paymentController.focusList[index + 1] : _amountFocus,
                                required: paymentController.methodFields[index].isRequired == 1,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),

                            paymentController.methodFields[index].inputType == 'date' ? IconButton(
                              onPressed: () async {

                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                                  setState(() {
                                    paymentController.textControllerList[index].text = formattedDate;
                                  });
                                }

                              },
                              icon: const Icon(Icons.date_range_sharp),
                            ) : const SizedBox(),
                          ]),
                          SizedBox(height: index != paymentController.methodFields.length-1 ? Dimensions.paddingSizeLarge : 0),

                        ]);
                      }),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ]),
              ),
            ),

            Builder(
                builder: (context) {

                  bool fieldEmpty = false;

                  for (var element in paymentController.methodFields) {
                    if(element.isRequired == 1){
                      if(paymentController.textControllerList[paymentController.methodFields.indexOf(element)].text.isEmpty){
                        fieldEmpty = true;
                      }
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButtonWidget(
                      isLoading: paymentController.isLoading,
                      buttonText: 'send_request'.tr,
                      buttonDisabledColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      onPressed: !fieldEmpty && paymentController.selectedPaymentMethodId != null && _amountController.text.isNotEmpty ? () {

                        if(fieldEmpty){
                          showCustomSnackBar('required_fields_can_not_be_empty'.tr);
                        }else if(_amountController.text.trim().isEmpty){
                          showCustomSnackBar('enter_amount'.tr);
                        }else{
                          Map<String?, String> data = {};
                          data['id'] = paymentController.selectedPaymentMethodId.toString();
                          data['amount'] = _amountController.text.trim();

                          if(paymentController.selectedPaymentMethod!.startsWith('my_')) {
                            for (var result in paymentController.disMethodFields) {
                              data[result.userInput] = paymentController.textControllerList[paymentController.disMethodFields.indexOf(result)].text.trim();
                            }
                          } else {
                            for (var result in paymentController.methodFields) {
                              data[result.inputName] = paymentController.textControllerList[paymentController.methodFields.indexOf(result)].text.trim();
                            }
                          }

                          paymentController.requestWithdraw(data);
                        }

                      } : null,
                    ),
                  );
                }
            ),

          ]);
        });
      }),
    );
  }
}