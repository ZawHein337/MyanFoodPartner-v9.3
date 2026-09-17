import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/assignable_food_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/categoty_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  String? _selectedCategoryID;
  String? get selectedCategoryID => _selectedCategoryID;

  String? _selectedSubCategoryID;
  String? get selectedSubCategoryID => _selectedSubCategoryID;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  int? _selectedCategoryIndex = 0;
  int? get selectedCategoryIndex => _selectedCategoryIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  List<Product>? _itemList;
  List<Product>? get itemList => _itemList;

  int? _selectedSubCategoryId;
  int? get selectedSubCategoryId => _selectedSubCategoryId;

  int? _isSubCategory = 0;
  int? get isSubCategory => _isSubCategory;

  int? _selectedSubCategoryIndex = 0;
  int? get selectedSubCategoryIndex => _selectedSubCategoryIndex;

  bool _isSubmitLoading = false;
  bool get isSubmitLoading => _isSubmitLoading;

  List<CategoryModel>? _myCategoryList;
  List<CategoryModel>? get myCategories => _myCategoryList;

  bool _isMyCategoryLoading = false;
  bool get isMyCategoryLoading => _isMyCategoryLoading;

  String? _selectedMyCategoryID;
  String? get selectedMyCategoryID => _selectedMyCategoryID;

  List<Product>? _storeCategoryItemList;
  List<Product>? get storeCategoryItemList => _storeCategoryItemList;

  int? _storeCategoryItemPageSize;
  int? get storeCategoryItemPageSize => _storeCategoryItemPageSize;

  int _storeCategoryItemOffset = 1;
  int get storeCategoryItemOffset => _storeCategoryItemOffset;

  bool _isStoreCategoryItemLoading = false;
  bool get isStoreCategoryItemLoading => _isStoreCategoryItemLoading;

  final List<String> _storeCategoryItemOffsetList = [];

  List<AssignableFood>? _assignableFoodList;
  List<AssignableFood>? get assignableFoodList => _assignableFoodList;

  int? _assignableFoodPageSize;
  int? get assignableFoodPageSize => _assignableFoodPageSize;

  int _assignableFoodOffset = 1;
  int get assignableFoodOffset => _assignableFoodOffset;

  bool _isAssignableFoodLoading = false;
  bool get isAssignableFoodLoading => _isAssignableFoodLoading;

  final List<String> _assignableFoodOffsetList = [];

  String? _assignableCategoryName;
  String? get assignableCategoryName => _assignableCategoryName;

  int? _assignableUnassignedCount;
  int? get assignableUnassignedCount => _assignableUnassignedCount;

  // Display keys → API numeric values (0 = normal, 1 = medium, 2 = high)
  static const Map<String, String> _priorityValueMap = {'normal': '0', 'medium': '1', 'high': '2'};
  static const Map<int, String> _priorityKeyMap = {0: 'normal', 1: 'medium', 2: 'high'};

  final List<String> priorityList = ['normal', 'medium', 'high'];

  String priorityKeyFromInt(int? value) => _priorityKeyMap[value] ?? 'normal';
  String priorityValueFromKey(String key) => _priorityValueMap[key] ?? '0';

  XFile? _pickedCategoryImage;
  XFile? get pickedCategoryImage => _pickedCategoryImage;

  String? _selectedPriority;
  String? get selectedPriority => _selectedPriority;

  String? _selectedTaxRate;
  String? get selectedTaxRate => _selectedTaxRate;

  Future<void> getCategoryList({bool isRestaurantWise = false, String? search}) async {
    _categoryList = null;
    List<CategoryModel>? categoryList = await categoryServiceInterface.getCategoryList(isRestaurantWise: isRestaurantWise, search: search);
    if(categoryList != null) {
      _categoryList = [];
      _categoryList = categoryList;
    }
    update();
  }

  Future<void> getSubCategoryList(int categoryID, {bool isRestaurantWise = false}) async {
    List<CategoryModel>? subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID, isRestaurantWise: isRestaurantWise);
    if(subCategoryList != null){
      _subCategoryList = [];
      _subCategoryList = subCategoryList;
    }
    update();
  }

  Future<void> initCategoryData(Product? product) async {
    _subCategoryList = null;
    _selectedCategoryID = null;
    _selectedMyCategoryID = null;
    await getCategoryList();
    if (Get.find<SplashController>().configModel?.restaurantCategoryStatus ?? false) {
      await getMyCategoryList();
    }
    if (product != null && product.categoryIds?.isNotEmpty == true) {
      final mainId = product.categoryIds![0].id;
      if (mainId != null) {
        _selectedCategoryID = mainId;
        _ensureCategoryExists(_categoryList, mainId, product.categoryIds![0].categoryName);

        if (product.categoryIds!.length > 1) {
          final subId = product.categoryIds![1].id;
          if (subId != null) {
            await getSubCategoryList(int.parse(mainId));
            _ensureCategoryExists(_subCategoryList, subId, product.categoryIds![1].categoryName);
            setSelectedSubCategory(subId, isUpdate: false);
          }
        } else {
          await getSubCategoryList(int.parse(mainId));
        }
      }
    }
    if (product?.restaurantCategoryId != null) {
      _selectedMyCategoryID = product!.restaurantCategoryId.toString();
      _ensureCategoryExists(_myCategoryList, _selectedMyCategoryID!, product.restaurantCategoryName);
    }
    update();
  }

  void _ensureCategoryExists(List<CategoryModel>? list, String id, String? name) {
    final int? parsedId = int.tryParse(id);
    if (parsedId == null || list == null) return;
    if (list.any((c) => c.id == parsedId)) return;
    list.add(CategoryModel(id: parsedId, name: name));
  }

  void setSelectedMyCategory(String? id) {
    _selectedMyCategoryID = id;
    update();
  }

  void setSelectedCategory(String? id, {bool isUpdate = true}) {
    _selectedCategoryID = id;
    _selectedSubCategoryID = null;
    if(id != null) getSubCategoryList(int.parse(id));
    if (isUpdate) update();
  }

  void setSelectedSubCategory(String id, {bool isUpdate = true}) {
    _selectedSubCategoryID = id;
    if (isUpdate) update();
  }

  void setSelectedPriority(String? value) {
    _selectedPriority = value;
    update();
  }

  void setSelectedTaxRate(String? value) {
    _selectedTaxRate = value;
    update();
  }

  Future<void> setCategoryAndSubCategoryForAiData({String? categoryId, String? subCategoryId}) async {
    if(categoryId != null){
      _selectedCategoryID = categoryId;
      await getSubCategoryList(int.parse(categoryId)).then((value) {
        if(_subCategoryList != null && _subCategoryList!.isNotEmpty){
          if(subCategoryId != null && _subCategoryList!.any((element) => element.id == int.parse(subCategoryId))){
            _selectedSubCategoryID = subCategoryId;
          }
          update();
        }
      });
    }
    update();
  }

  void expandedUpdate(bool status){
    _isExpanded = status;
    update();
  }

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    update();
  }

  Future<void> getCategoryItemList({required String offset, required int id, bool willUpdate = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _itemList = null;
      if(willUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ProductModel? itemModel = await categoryServiceInterface.getCategoryItemList(offset: offset, id: id, isSubCategory: _isSubCategory!);
      if (itemModel != null) {
        if (offset == '1') {
          _itemList = [];
        }
        _itemList!.addAll(itemModel.products!);
        _pageSize = itemModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void setSelectedSubCategoryIndex(int? index, bool notify) {
    _selectedSubCategoryIndex = index;
    if (notify) {
      update();
    }
  }

  void clearSelectedSubCategoryId() {
    _selectedSubCategoryId = null;
    _isSubCategory = 0;
  }

  void setSelectedSubCategoryId(int? subCategoryId) {
    _selectedSubCategoryId = subCategoryId;
    _isSubCategory = 1;
    if( _selectedSubCategoryId != null) {
      getCategoryItemList(offset: '1', id: _selectedSubCategoryId!);
    }
    update();
  }

  void clearSearch({bool isUpdate = true}) {
    getCategoryList(isRestaurantWise: true, search: '');
    if(isUpdate) {
      update();
    }
  }

  Future<void> addStoreCategoryApi(List<Translation> translations, String priority, {Function(int id, String name)? onCreated}) async {
    _isSubmitLoading = true;
    update();
    final bool success = await categoryServiceInterface.addStoreCategory(translations, priority, _pickedCategoryImage);
    _isSubmitLoading = false;
    if (success) {
      Get.back();
      showCustomSnackBar('category_added_successfully'.tr, isError: false);
      resetMyCategoryForm();
      await getMyCategoryList();
      if (onCreated != null && _myCategoryList != null && _myCategoryList!.isNotEmpty) {
        final newest = _myCategoryList!.reduce((a, b) => (a.id ?? 0) > (b.id ?? 0) ? a : b);
        onCreated(newest.id!, newest.name ?? '');
      }
    } else {
      update();
    }
  }

  Future<void> updateStoreCategoryApi(int id, List<Translation> translations, String priority) async {
    _isSubmitLoading = true;
    update();
    final bool success = await categoryServiceInterface.updateStoreCategory(id, translations, priority, _pickedCategoryImage);
    _isSubmitLoading = false;
    if (success) {
      Get.back();
      showCustomSnackBar('category_updated_successfully'.tr, isError: false);
      resetMyCategoryForm();
      await getMyCategoryList();
    } else {
      update();
    }
  }

  // ── My Category ──────────────────────────────────────────────────────────

  Future<void> getMyCategoryList({String search = ''}) async {
    _isMyCategoryLoading = true;
    update();
    final List<CategoryModel>? list = await categoryServiceInterface.getMyCategoryList(search: search);
    if (list != null) {
      _myCategoryList = list;
    }
    _isMyCategoryLoading = false;
    update();
  }

  Future<CategoryDetailsModel?> getCategoryDetails(int id) async {
    return await categoryServiceInterface.getCategoryDetails(id);
  }

  Future<bool> deleteMyCategory(int id) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    final bool success = await categoryServiceInterface.deleteStoreCategory(id);
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    if (success) {
      _myCategoryList?.removeWhere((c) => c.id == id);
      showCustomSnackBar('category_deleted_successfully'.tr, isError: false);
      update();
    }
    return success;
  }

  Future<void> getStoreCategoryItemList({required String offset, required int id}) async {
    if (offset == '1') {
      _storeCategoryItemOffsetList.clear();
      _storeCategoryItemOffset = 1;
      _storeCategoryItemList = null;
      update();
    }
    if (!_storeCategoryItemOffsetList.contains(offset)) {
      _storeCategoryItemOffsetList.add(offset);
      final ProductModel? model = await categoryServiceInterface.getStoreCategoryItems(id, offset: offset);
      if (model != null) {
        if (offset == '1') _storeCategoryItemList = [];
        _storeCategoryItemList!.addAll(model.products!);
        _storeCategoryItemPageSize = model.totalSize;
      }
      _isStoreCategoryItemLoading = false;
      update();
    } else {
      if (_isStoreCategoryItemLoading) {
        _isStoreCategoryItemLoading = false;
        update();
      }
    }
  }

  void showStoreCategoryItemBottomLoader() {
    _isStoreCategoryItemLoading = true;
    update();
  }

  void setStoreCategoryItemOffset(int offset) {
    _storeCategoryItemOffset = offset;
  }

  Future<void> toggleCategoryStatus(int id, int currentStatus) async {
    final int newStatus = currentStatus == 1 ? 0 : 1;
    final index = _myCategoryList?.indexWhere((c) => c.id == id) ?? -1;
    if (index == -1) return;
    _myCategoryList![index].status = newStatus;
    update();
    final bool success = await categoryServiceInterface.updateCategoryStatus(id, newStatus);
    if (success) {
      showCustomSnackBar('category_status_updated_successfully'.tr, isError: false);
    } else {
      _myCategoryList![index].status = currentStatus;
      update();
    }
  }


  Future<void> pickCategoryImage() async {
    final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      _pickedCategoryImage = file;
      update();
    }
  }

  Future<void> getAssignableFoods({required String offset, required int categoryId, String search = ''}) async {
    if (offset == '1') {
      _assignableFoodOffsetList.clear();
      _assignableFoodOffset = 1;
      _assignableFoodList = null;
      update();
    }
    if (!_assignableFoodOffsetList.contains(offset)) {
      _assignableFoodOffsetList.add(offset);
      final AssignableFoodModel? model = await categoryServiceInterface.getAssignableFoods(categoryId, offset: offset, search: search);
      if (model != null) {
        if (offset == '1') {
          _assignableFoodList = [];
          _assignableCategoryName = model.category?.name;
          _assignableUnassignedCount = model.unassignedCount;
        }
        _assignableFoodList!.addAll(model.foods ?? []);
        _assignableFoodPageSize = model.totalSize;
      }
      _isAssignableFoodLoading = false;
      update();
    } else {
      if (_isAssignableFoodLoading) {
        _isAssignableFoodLoading = false;
        update();
      }
    }
  }

  void showAssignableFoodBottomLoader() {
    _isAssignableFoodLoading = true;
    update();
  }

  void setAssignableFoodOffset(int offset) {
    _assignableFoodOffset = offset;
  }

  bool _isAssignSubmitLoading = false;
  bool get isAssignSubmitLoading => _isAssignSubmitLoading;

  Future<bool> assignFoodsToCategory(int categoryId, List<int> foodIds) async {
    _isAssignSubmitLoading = true;
    update();
    final bool success = await categoryServiceInterface.assignFoodsToCategory(categoryId, foodIds);
    await getMyCategoryList();
    _isAssignSubmitLoading = false;
    update();
    return success;
  }

  void resetMyCategoryForm() {
    _pickedCategoryImage = null;
    _selectedPriority = null;
    _selectedTaxRate = null;
    _assignableFoodList = null;
  }

}
