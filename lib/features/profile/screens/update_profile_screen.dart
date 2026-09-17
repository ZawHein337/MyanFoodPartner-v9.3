import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_popup_menu_button.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/widgets/account_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_validator.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _countryDialCode;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  void _initCall() async{
    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code;
    _splitPhone(Get.find<ProfileController>().profileModel!.phone!);
    Get.find<ProfileController>().initData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
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
    final List<MenuItem> items = [
      MenuItem('delete_account'.tr, Icons.delete_forever_rounded, 1, Colors.red),
    ];
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'edit_profile'.tr,
        menuWidget: CustomPopupMenuButton(
          items: items,
          onSelected: (int value) {
            if(value == 1) {
              showCustomBottomSheet(
                child: const AccountDeleteBottomSheet(),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
            child: Icon(Icons.more_vert_sharp),
          ),
        ),
      ),
      body: GetBuilder<ProfileController>(builder: (profileController) {

        if(profileController.profileModel != null && _emailController.text.isEmpty) {
          _firstNameController.text = profileController.profileModel!.fName ?? '';
          _lastNameController.text = profileController.profileModel!.lName ?? '';
          _emailController.text = profileController.profileModel!.email ?? '';
        }

        return Column(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: context.height * 0.2, width: double.infinity,
                child: Image.asset(Images.profileBg, fit: BoxFit.cover,),
              ),

              Positioned(
                bottom: -40, left: 0, right: 0,
                child: Center(child: InkWell(
                  onTap: () {
                    profileController.pickImage();
                  },
                  child: Stack(children: [

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: 3, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          // padding: const EdgeInsets.all(2),
                          child: ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                              profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover) : Image.file(
                              File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover) : CustomImageWidget(
                            image: '${profileController.profileModel!.imageFullUrl}',
                            height: 100, width: 100, fit: BoxFit.cover,
                          ),
                          ),
                        ),

                        Positioned(
                          right: -5,
                          top: 20,
                          child: InkWell(
                            onTap: () => profileController.pickImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(width: 3, color: Colors.white),
                                shape: BoxShape.circle,
                                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],

                              ),
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                )),
              ),
            ],
          ),

          const SizedBox(height: 60),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  
                      CustomTextFieldWidget(
                        hintText: 'enter_first_name'.tr,
                        controller: _firstNameController,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        prefixIcon: CupertinoIcons.person_alt_circle_fill,
                        labelText: 'first_name'.tr,
                        required: true,
                        validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_first_name".tr),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),
                  
                      CustomTextFieldWidget(
                        hintText: 'enter_last_name'.tr,
                        controller: _lastNameController,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                        focusNode: _lastNameFocus,
                        nextFocus: _emailFocus,
                        prefixIcon: CupertinoIcons.person_alt_circle_fill,
                        labelText: 'last_name'.tr,
                        required: true,
                        validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_last_name".tr),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),
                  
                      CustomTextFieldWidget(
                        hintText: 'xxx-xxx-xxxxx'.tr,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryCode,
                        labelText: 'phone'.tr,
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeOverExtraLarge),
                  
                      Stack(clipBehavior: Clip.none, children: [
                        CustomToolTip(
                          message: 'email_can_not_be_edited'.tr,
                          preferredDirection: AxisDirection.up,
                          child: Container(
                            height: 50, width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              border: Border.all(
                                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(CupertinoIcons.mail_solid, color: Theme.of(context).hintColor.withValues(alpha: 0.5), size: 17),
                              const SizedBox(width: 15),
                              Flexible(
                                fit: FlexFit.loose, // Use Flexible with FlexFit.loose
                                child: Text(
                                  _emailController.text,
                                  style: robotoRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                  
                        Positioned(
                          left: 10, top: -15,
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).cardColor),
                            padding: const EdgeInsets.all(5),
                            child: Text('email'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ),
                      ]),
                  
                    ]),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: !profileController.isLoading ? CustomButtonWidget(
                onPressed: () => _updateProfile(profileController),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                buttonText: 'update'.tr,
              ) : const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
            ),
          ),

        ]);

      }),
    );
  }

  void _updateProfile(ProfileController profileController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();

    String phoneNumber = _phoneController.text.trim();

    String phoneNumberWithCode = _countryDialCode! + phoneNumber;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(phoneNumberWithCode);
    phoneNumberWithCode = phoneValid.phone;

    if (profileController.profileModel!.fName == firstName &&
        profileController.profileModel!.lName == lastName && profileController.profileModel!.phone == phoneNumberWithCode &&
        profileController.profileModel!.email == _emailController.text && profileController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!phoneValid.isValid) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else {
      ProfileModel updatedUser = ProfileModel(fName: firstName, lName: lastName, email: email, phone: phoneNumberWithCode);
      await profileController.updateUserInfo(updatedUser, profileController.getUserToken());
    }
  }
}