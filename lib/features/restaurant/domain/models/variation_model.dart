import 'package:flutter/material.dart';

class VariationModel{
  String? id;
  TextEditingController? nameController;
  bool required;
  bool isSingle;
  TextEditingController? minController;
  TextEditingController? maxController;
  List<Option>? options;

  VariationModel({required this.id, this.nameController, this.required = false, this.isSingle = true, this.minController, this.maxController, this.options});
}

class Option{
  String? optionId;
  TextEditingController? optionNameController;
  TextEditingController? optionPriceController;
  TextEditingController? optionStockController;

  Option({required this.optionId, required this.optionNameController, required this.optionPriceController, required this.optionStockController});
}