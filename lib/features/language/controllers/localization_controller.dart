import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/services/language_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageServiceInterface languageServiceInterface;

  LocalizationController({required this.languageServiceInterface}){
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  int _selectedLanguageIndex = 0;
  int get selectedLanguageIndex => _selectedLanguageIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale, {bool fromBottomSheet = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    _locale.languageCode == 'ar' ? _isLtr = false : _isLtr = true;
    languageServiceInterface.updateHeader(_locale);

    if(!fromBottomSheet) {
      saveLanguage(_locale);
    }

    if(Get.find<AuthController>().isLoggedIn() && !fromBottomSheet){
      Get.find<RestaurantController>().getProductList(offset: '1', foodType: 'all', stockType: 'all');
      Get.find<ProfileController>().getProfile();
    }
    update();
  }

  void setSelectLanguageIndex(int index) {
    _selectedLanguageIndex = index;
    update();
  }

  void loadCurrentLanguage() async {
    _locale = languageServiceInterface.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    for(int index = 0; index < AppConstants.languages.length; index++) {
      if(_locale.languageCode == AppConstants.languages[index].languageCode) {
        _selectedLanguageIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    languageServiceInterface.saveLanguage(locale);
  }

  void saveCacheLanguage(Locale? locale) {
    languageServiceInterface.saveCacheLanguage(locale ?? languageServiceInterface.getLocaleFromSharedPref());
  }

  Locale getCacheLocaleFromSharedPref() {
    return languageServiceInterface.getCacheLocaleFromSharedPref();
  }

  void searchSelectedLanguage() {
    for (var language in AppConstants.languages) {
      if (language.languageCode!.toLowerCase().contains(_locale.languageCode.toLowerCase())) {
        _selectedLanguageIndex = AppConstants.languages.indexOf(language);
      }
    }
  }

}