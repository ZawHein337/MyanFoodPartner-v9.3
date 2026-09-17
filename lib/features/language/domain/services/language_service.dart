import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/repositories/language_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/services/language_service_interface.dart';

class LanguageService implements LanguageServiceInterface {
  final LanguageRepositoryInterface languageRepositoryInterface;
  LanguageService({required this.languageRepositoryInterface});

  @override
  void updateHeader(Locale locale) {
    languageRepositoryInterface.updateHeader(locale);
  }

  @override
  Locale getLocaleFromSharedPref() {
    return languageRepositoryInterface.getLocaleFromSharedPref();
  }

  @override
  void saveLanguage(Locale locale) {
    languageRepositoryInterface.saveLanguage(locale);
  }

  @override
  void saveCacheLanguage(Locale locale) {
    languageRepositoryInterface.saveCacheLanguage(locale);
  }

  @override
  Locale getCacheLocaleFromSharedPref() {
    return languageRepositoryInterface.getCacheLocaleFromSharedPref();
  }

}