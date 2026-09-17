import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_method_model.dart' as disburse;
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/models/disbursement_report_model.dart' as report;
import 'package:stackfood_multivendor_restaurant/features/payment/domain/models/widthdrow_method_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementController extends GetxController implements GetxService {
  final DisbursementServiceInterface disbursementServiceInterface;
  DisbursementController({required this.disbursementServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDeleteLoading = false;
  bool get isDeleteLoading => _isDeleteLoading;

  int? _selectedMethodIndex = 0;
  int? get selectedMethodIndex => _selectedMethodIndex;

  List<DropdownItem<int>> _methodList = [];
  List<DropdownItem<int>> get methodList => _methodList;

  List<TextEditingController> _textControllerList = [];
  List<TextEditingController> get textControllerList => _textControllerList;

  List<MethodFields> _methodFields = [];
  List<MethodFields> get methodFields => _methodFields;

  List<FocusNode> _focusList = [];
  List<FocusNode> get focusList => _focusList;

  List<WidthDrawMethodModel>? _widthDrawMethods;
  List<WidthDrawMethodModel>? get widthDrawMethods => _widthDrawMethods;

  disburse.DisbursementMethodBody? _disbursementMethodBody;
  disburse.DisbursementMethodBody? get disbursementMethodBody => _disbursementMethodBody;

  int? _index = -1;
  int? get index =>_index;

  report.DisbursementReportModel? _disbursementReportModel;
  report.DisbursementReportModel? get disbursementReportModel => _disbursementReportModel;

  void setMethodId(int? id, {bool canUpdate = true}) {
    _selectedMethodIndex = id;
    if(canUpdate){
      update();
    }
  }

  Future<void> setMethod({bool willUpdate = true, bool initCall = false}) async {
    _methodList = [];
    _textControllerList = [];
    _methodFields = [];
    _focusList = [];

    if(Get.find<PaymentController>().widthDrawMethods == null) {
      _widthDrawMethods = await Get.find<PaymentController>().getWithdrawMethodList();
    } else {
      _widthDrawMethods = Get.find<PaymentController>().widthDrawMethods;
    }
    if(_widthDrawMethods != null && _widthDrawMethods!.isNotEmpty){
      for(int i=0; i < _widthDrawMethods!.length; i++){
        _methodList.add(DropdownItem<int>(value: i, child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${_widthDrawMethods![i].methodName}'),
          ),
        )));
      }
      if(initCall) {
        _selectedMethodIndex = 0;
      }
      _textControllerList = [];
      _methodFields = [];
      for (var field in _widthDrawMethods![_selectedMethodIndex!].methodFields!) {
        _methodFields.add(field);
        _textControllerList.add(TextEditingController());
        _focusList.add(FocusNode());
      }
    }
    if(willUpdate) {
      update();
    }
  }

  Future<void> addWithdrawMethod(Map<String?, String> data) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await disbursementServiceInterface.addWithdraw(data);
    if(responseModel.isSuccess) {
      Get.back();
      getDisbursementMethodList();
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<bool> getDisbursementMethodList() async {
    bool success = false;
    disburse.DisbursementMethodBody? disbursementMethodBody = await disbursementServiceInterface.getDisbursementMethodList();
    if(disbursementMethodBody != null) {
      success = true;
      _disbursementMethodBody = disbursementMethodBody;
    }
    update();
    return success;
  }

  Future<void> makeDefaultMethod(Map<String, String> data, int index) async {
    _index = index;
    _isLoading = true;
    update();
    ResponseModel responseModel = await disbursementServiceInterface.makeDefaultMethod(data);
    if(responseModel.isSuccess) {
      _index = -1;
      getDisbursementMethodList();
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteMethod(int id) async {
    _isDeleteLoading = true;
    update();
    ResponseModel responseModel = await disbursementServiceInterface.deleteMethod(id);
    if(responseModel.isSuccess) {
      getDisbursementMethodList();
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }
    _isDeleteLoading = false;
    update();
  }

  Future<void> getDisbursementReport(int offset) async {
    report.DisbursementReportModel? disbursementReportModel = await disbursementServiceInterface.getDisbursementReport(offset);
    if(disbursementReportModel != null) {
      _disbursementReportModel = disbursementReportModel;
    }
    update();
  }

}