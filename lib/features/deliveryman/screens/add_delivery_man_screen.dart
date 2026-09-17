import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_drop_down_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_validator.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDeliveryManScreen extends StatefulWidget {
  final DeliveryManModel? deliveryMan;
  const AddDeliveryManScreen({super.key, required this.deliveryMan});

  @override
  State<AddDeliveryManScreen> createState() => _AddDeliveryManScreenState();
}

class _AddDeliveryManScreenState extends State<AddDeliveryManScreen> {

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  
  late bool _update;
  DeliveryManModel? _deliveryMan;
  String? _countryDialCode;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    
    DeliveryManController dmController = Get.find<DeliveryManController>();

    _deliveryMan = widget.deliveryMan;
    _update = widget.deliveryMan != null;
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code;
    dmController.pickImage(false, true);
    dmController.clearIdentityImage();
    
    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass();
    }

    if(_update) {
      _splitPhone(_deliveryMan!.phone!);
      _fNameController.text = _deliveryMan!.fName!;
      _lNameController.text = _deliveryMan!.lName!;
      _emailController.text = _deliveryMan!.email!;
      _identityNumberController.text = _deliveryMan!.identityNumber!;
      dmController.setSelectedIdentityType(_deliveryMan!.identityType, notify: false);
      if(_deliveryMan!.identityImageFullUrl != null && _deliveryMan!.identityImageFullUrl!.isNotEmpty) {
        dmController.clearIdentityImage();
        for(String image in _deliveryMan!.identityImageFullUrl!) {
          dmController.saveIdentityImages(image);
        }
      }
    }else {
      _deliveryMan = DeliveryManModel();
    }
  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _countryCode = phoneNumber.isoCode.name;
        _phoneController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.deliveryMan != null ? 'update_delivery_man'.tr : 'add_delivery_man'.tr),
      body: GetBuilder<DeliveryManController>(builder: (dmController) {
        return GetBuilder<AuthController>(builder: (authController) {
          return Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                CustomCard(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'profile_picture'.tr,
                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                        TextSpan(
                          text: '*',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('image_format_and_ratio_for_profile'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Align(alignment: Alignment.center, child: Stack(children: [

                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: dmController.pickedImage != null ? Image.file(
                            File(dmController.pickedImage!.path), width: 120, height: 120, fit: BoxFit.cover,
                          ) :  _deliveryMan?.imageFullUrl != null ? CustomImageWidget(
                            image: _deliveryMan?.imageFullUrl ?? '',
                            height: 120, width: 120, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 120, height: 120,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              CustomAssetImageWidget(image: Images.pictureIcon, height: 30, width: 30, color: Theme.of(context).disabledColor),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'click_to_add'.tr,
                                style: robotoMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),

                            ]),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => dmController.pickImage(true, false),
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: Theme.of(context).disabledColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              radius: const Radius.circular(Dimensions.radiusDefault),
                            ),
                            child: const SizedBox(width: 120, height: 120),
                          ),
                        ),
                      ),

                    ])),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('deliveryman_info'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomCard(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: CustomTextFieldWidget(
                        labelText: 'first_name'.tr,
                        hintText: 'ex_jhon'.tr,
                        controller: _fNameController,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                        focusNode: _fNameNode,
                        nextFocus: _lNameNode,
                        required: true,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: CustomTextFieldWidget(
                        labelText: 'last_name'.tr,
                        hintText: 'ex_doe'.tr,
                        controller: _lNameController,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                        focusNode: _lNameNode,
                        nextFocus: _emailNode,
                        required: true,
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      labelText: 'email'.tr,
                      hintText: 'enter_email'.tr,
                      controller: _emailController,
                      focusNode: _emailNode,
                      nextFocus: _phoneNode,
                      inputType: TextInputType.emailAddress,
                      required: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 'xxx-xxxxxxx',
                      labelText: 'phone_number'.tr,
                      controller: _phoneController,
                      focusNode: _phoneNode,
                      nextFocus: _passwordNode,
                      required: true,
                      showTitle: false,
                      inputType: TextInputType.phone,
                      isPhone: true,
                      onCountryChanged: (CountryCode countryCode) {
                        _countryDialCode = countryCode.dialCode;
                      },
                      countryDialCode: _countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: '8_characters'.tr,
                      labelText: 'password'.tr,
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      nextFocus: _identityNumberNode,
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      required: true,
                      onChanged: (value){
                        if(value != null && value.isNotEmpty){
                          if(!authController.showPassView){
                            authController.showHidePass();
                          }
                          authController.validPassCheck(value);
                        }else{
                          if(authController.showPassView){
                            authController.showHidePass();
                          }
                        }
                      },
                    ),

                    authController.showPassView ? const PassViewWidget() : const SizedBox(),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('identity_information'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomCard(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [

                    Stack(clipBehavior: Clip.none, children: [
                      CustomDropdownButton(
                        hintText: 'select_identity_type'.tr,
                        items: dmController.identityTypeList,
                        selectedValue: dmController.selectedIdentityType,
                        onChanged: (value) {
                          dmController.setSelectedIdentityType(value);
                        },
                      ),

                      Positioned(
                        left: 10, top: -10,
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(2),
                          child: Row(children: [
                            Text('select_identity_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)),
                            Text(' *', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error)),
                          ]),
                        ),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    CustomTextFieldWidget(
                      hintText: 'Ex: xxx-xxxx-xxxxx',
                      labelText: 'identity_number'.tr,
                      controller: _identityNumberController,
                      focusNode: _identityNumberNode,
                      inputAction: TextInputAction.done,
                      required: true,
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomCard(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'identity_image'.tr,
                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                        TextSpan(
                          text: '*',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('image_format_and_ratio_for_profile'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Center(
                      child: SizedBox(
                        width: 180,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, mainAxisExtent: 130,
                            mainAxisSpacing: 10, crossAxisSpacing: 10,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dmController.pickedIdentities.length + 1,
                          itemBuilder: (context, index) {

                            if(index == dmController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () {
                                  if((dmController.pickedIdentities.length) < 6) {
                                    dmController.pickImage(false, false);
                                  }else {
                                    showCustomSnackBar('maximum_image_limit_is_6'.tr);
                                  }
                                },
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(Dimensions.radiusDefault),
                                    dashPattern: const [8, 4],
                                    strokeWidth: 1,
                                    color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                  ),
                                  child: Container(
                                    height: 130, width: 180,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                      CustomAssetImageWidget(image: Images.pictureIcon, height: 40, width: 40, color: Theme.of(context).disabledColor),
                                      const SizedBox(height: Dimensions.paddingSizeDefault),

                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(text: 'upload_identity_image'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                                        ]),
                                      ),

                                    ]),
                                  ),
                                ),
                              );
                            }
                            return DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                dashPattern: const [8, 5],
                                strokeWidth: 1,
                                color: const Color(0xFFE5E5E5),
                              ),
                              child: SizedBox(
                                width: 180,
                                child: Stack(children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: dmController.pickedIdentities.isNotEmpty ? Image.file(
                                      File(dmController.pickedIdentities[index].path), height: 130, width: 180, fit: BoxFit.cover,
                                    ) : CustomImageWidget(
                                      image: _deliveryMan!.identityImageFullUrl?[index] ?? '',
                                      height: 130, width: 180, fit: BoxFit.cover,
                                    ),
                                  ),

                                  Positioned(
                                    right: 0, top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        dmController.removeIdentityImage(index);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ),
                                  ),

                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ]),
                ),

                /*_update ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(
                      'identity_images'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text(
                      '(${'previously_added'.tr})',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _deliveryMan!.identityImageFullUrl!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImageWidget(
                              image: _deliveryMan!.identityImageFullUrl![index],
                              width: 150, height: 120, fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]) : const SizedBox(),

                Text(
                  'identity_images'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: dmController.pickedIdentities.length+1,
                    itemBuilder: (context, index) {
                      XFile? file = index == dmController.pickedIdentities.length ? null : dmController.pickedIdentities[index];
                      if(index == dmController.pickedIdentities.length) {
                        return InkWell(
                          onTap: () => dmController.pickImage(false, false),
                          child: Container(
                            height: 120, width: 150, alignment: Alignment.center, decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                            ),
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: GetPlatform.isWeb ? Image.network(
                              file!.path, width: 150, height: 120, fit: BoxFit.cover,
                            ) : Image.file(
                              File(file!.path), width: 150, height: 120, fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0, top: 0,
                            child: InkWell(
                              onTap: () => dmController.removeIdentityImage(index),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                ),*/

              ]),
            )),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              child: CustomButtonWidget(
                isLoading: dmController.isLoading,
                buttonText: _update ? 'update'.tr : 'add'.tr,
                onPressed: () => _addDeliveryMan(dmController),
              ),
            ),

          ]);
        });
      }),
    );
  }

  void _addDeliveryMan(DeliveryManController dmController) async {

    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();

    String numberWithCountryCode = _countryDialCode!+phone;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);

    if(!_update && dmController.pickedImage == null) {
      showCustomSnackBar('upload_delivery_man_image'.tr);
    }else if(fName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_first_name'.tr);
    }else if(lName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_last_name'.tr);
    }else if(email.isEmpty) {
      showCustomSnackBar('enter_delivery_man_email_address'.tr);
    }else if(!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if(phone.isEmpty) {
      showCustomSnackBar('enter_delivery_man_phone_number'.tr);
    }else if(!phoneValid.isValid) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    }else if(!_update && password.isEmpty) {
      showCustomSnackBar('enter_password_for_delivery_man'.tr);
    }else if(!_update && password.length < 8) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(dmController.selectedIdentityType == null){
      showCustomSnackBar('select_identity_type'.tr);
    }else if(identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
    }else if(dmController.pickedIdentities.isEmpty) {
      showCustomSnackBar('please_upload_identity_image'.tr);
    }else {
      _deliveryMan!.fName = fName;
      _deliveryMan!.lName = lName;
      _deliveryMan!.email = email;
      _deliveryMan!.phone = numberWithCountryCode;
      _deliveryMan!.identityType = dmController.selectedIdentityType;
      _deliveryMan!.identityNumber = identityNumber;
      dmController.addDeliveryMan(
        _deliveryMan!, password, Get.find<AuthController>().getUserToken(), widget.deliveryMan == null,
      );
    }
  }

}