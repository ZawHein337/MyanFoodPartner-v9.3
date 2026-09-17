import 'package:stackfood_multivendor_restaurant/features/expense/domain/services/expense_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/models/expense_model.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/enum/filter_type.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController implements GetxService {
  final ExpenseServiceInterface expenseServiceInterface;
  ExpenseController({required this.expenseServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Expense>? _expenses;
  List<Expense>? get expenses => _expenses;

  late DateTimeRange _selectedDateRange;

  String? _from;
  String? get from => _from;

  String? _to;
  String? get to => _to;

  String? _searchText;
  String? get searchText => _searchText;

  bool _searchMode = false;
  bool get searchMode => _searchMode;

  bool _setCustom = false;
  bool get setCustom => _setCustom;

  void initSetDate(){
    _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 10000)));
    _to = DateConverter.dateTimeForCoupon(DateTime.now());
    _searchText = '';
    _setCustom = false;
  }

  void setSearchText({required String offset, required String? from, required String? to, required String searchText}){
    _searchText = searchText;
    _searchMode = !_searchMode;
    getExpenseList(offset: offset.toString(), from: from, to: to, searchText: searchText);
  }

  Future<void> getExpenseList({required String offset, required String? from, required String? to, required String? searchText}) async {

    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _expenses = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      ExpenseBodyModel expenseModel = await expenseServiceInterface.getExpenseList(offset: int.parse(offset), from: from, to: to,
        restaurantId: Get.find<ProfileController>().profileModel!.restaurants![0].id, searchText: searchText);
      if (expenseModel.expense != null) {
        if (offset == '1') {
          _expenses = [];
        }
        _expenses!.addAll(expenseModel.expense!);
        _pageSize = expenseModel.totalSize;
        _isLoading = false;
        update();
      }
    }else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'done'.tr,
      confirmText: 'done'.tr,
      cancelText: 'cancel'.tr,
      fieldStartLabelText: 'start_date'.tr,
      fieldEndLabelText: 'end_date'.tr,
      errorInvalidRangeText: 'select_range'.tr,
    );

    if (result != null) {
      _selectedDateRange = result;
      _setCustom = true;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
    }
  }

  void setFilter(String filterText) {
    if(filterText == FilterType.all.name){
      _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 10000)));
      _to = DateConverter.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    }else if(filterText == FilterType.thisYear.name){
      _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 365)));
      _to = DateConverter.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    }else if(filterText == FilterType.previousYear.name){
      DateTime now = DateTime.now();
      _from = DateConverter.dateTimeForCoupon(DateTime(now.year -1, 1, 1));
      _to = DateConverter.dateTimeForCoupon(DateTime(now.year -1, 12, 31));
      _setCustom = false;
    }else if(filterText == FilterType.thisMonth.name){
      DateTime now = DateTime.now();
      _from = DateConverter.dateTimeForCoupon(DateTime(now.year, now.month, 1));
      _to = DateConverter.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    }else if(filterText == FilterType.thisWeek.name){
      DateTime now = DateTime.now();
      int currentWeekday = now.weekday;
      _from = DateConverter.dateTimeForCoupon(now.subtract(Duration(days: currentWeekday - 1)));
      _to = DateConverter.dateTimeForCoupon(DateTime.now());
      _setCustom = false;
    }

    getExpenseList(offset: '1', from: _from, to: _to, searchText: searchText);
  }

}