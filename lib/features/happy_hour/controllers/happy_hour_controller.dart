import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/services/happy_hour_service_interface.dart';
import 'package:get/get.dart';

class HappyHourController extends GetxController implements GetxService {
  final HappyHourServiceInterface happyHourServiceInterface;
  HappyHourController({required this.happyHourServiceInterface});

  static const List<String> typeList = ['all', 'not_joined', 'pending', 'admin_requested', 'approved', 'rejected'];

  List<HappyHourModel>? _happyHourList;
  List<HappyHourModel>? get happyHourList => _happyHourList;

  HappyHourBodyModel? _happyHourBody;
  HappyHourBodyModel? get happyHourBody => _happyHourBody;

  String _selectedType = 'all';
  String get selectedType => _selectedType;

  final List<int> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _actionLoadingId;
  int? get actionLoadingId => _actionLoadingId;
  bool get isActionLoading => _actionLoadingId != null;
  bool isActionLoadingFor(int? id) => id != null && _actionLoadingId == id;

  HappyHourModel? _happyHourDetails;
  HappyHourModel? get happyHourDetails => _happyHourDetails;

  bool _happyHourNotFound = false;
  bool get happyHourNotFound => _happyHourNotFound;

  Future<void> getHappyHourList({int offset = 1, bool reload = false}) async {
    if(offset == 1) {
      _offsetList.clear();
      _offset = 1;
      if(reload) {
        _happyHourList = null;
      }
      update();
    }

    if(_offsetList.contains(offset)) {
      return;
    }
    _offsetList.add(offset);
    HappyHourBodyModel? happyHourBody = await happyHourServiceInterface.getHappyHourList(offset: offset, type: _selectedType);

    if(offset == 1) {
      _happyHourList = [];
    }
    _happyHourList ??= [];
    if(happyHourBody != null) {
      _happyHourBody = happyHourBody;
      _pageSize = happyHourBody.totalSize;
      if(happyHourBody.happyHours != null) {
        _happyHourList!.addAll(happyHourBody.happyHours!);
      }
    }
    _offset = offset;
    update();
  }

  void resetType() {
    _selectedType = 'all';
  }

  void setType(String type) {
    if(_selectedType == type) {
      return;
    }
    _selectedType = type;
    _happyHourList = null;
    update();
    getHappyHourList(offset: 1);
  }

  int? countOf(String type) {
    switch(type) {
      case 'all': return _happyHourBody?.all;
      case 'not_joined': return _happyHourBody?.notJoined;
      case 'pending': return _happyHourBody?.pending;
      case 'admin_requested': return _happyHourBody?.adminRequested;
      case 'approved': return _happyHourBody?.approved;
      case 'rejected': return _happyHourBody?.rejected;
    }
    return null;
  }

  Future<HappyHourModel?> getAdminRequestedHappyHour() async {
    HappyHourBodyModel? happyHourBody = await happyHourServiceInterface.getHappyHourList(
      offset: 1, limit: 1, type: 'admin_requested',
    );
    return happyHourBody?.happyHours?.firstOrNull;
  }

  bool _adminRequestSheetShown = false;
  bool get adminRequestSheetShown => _adminRequestSheetShown;

  void markAdminRequestSheetShown() {
    _adminRequestSheetShown = true;
  }

  Future<void> getHappyHourDetails(int id, {bool reload = true}) async {
    if(reload) {
      _happyHourDetails = null;
      _happyHourNotFound = false;
      update();
    }

    final ({HappyHourModel? happyHour, bool isNotFound}) result = await happyHourServiceInterface.getHappyHourDetails(id);

    if(result.isNotFound) {
      _happyHourDetails = null;
      _happyHourNotFound = true;
      update();
      return;
    }

    if(reload || result.happyHour != null) {
      _happyHourDetails = result.happyHour;
    }
    update();
  }

  Future<void> syncHappyHour(int id) async {
    final bool isShownInDetails = _happyHourDetails?.id == id;
    final int index = _happyHourList?.indexWhere((HappyHourModel happyHour) => happyHour.id == id) ?? -1;

    if(!isShownInDetails && index == -1) {
      return;
    }

    final ({HappyHourModel? happyHour, bool isNotFound}) result = await happyHourServiceInterface.getHappyHourDetails(id);

    if(result.isNotFound) {
      if(isShownInDetails) {
        _happyHourDetails = null;
        _happyHourNotFound = true;
      }
      if(index != -1) {
        _happyHourList!.removeAt(index);
      }
      update();
      return;
    }

    if(result.happyHour == null) {
      return;
    }

    if(isShownInDetails) {
      _happyHourDetails = result.happyHour;
    }
    if(index != -1) {
      _happyHourList![index] = result.happyHour!;
    }
    update();
  }

  Future<bool> joinHappyHour(int id) async {
    return _runAction(id, () => happyHourServiceInterface.joinHappyHour(id));
  }

  Future<bool> respondToHappyHour(int id, String status, {String? rejectionReason}) async {
    return _runAction(id, () => happyHourServiceInterface.respondToHappyHour(id, status, rejectionReason: rejectionReason));
  }

  Future<bool> leaveHappyHour(int id) async {
    return _runAction(id, () => happyHourServiceInterface.leaveHappyHour(id));
  }

  Future<bool> _runAction(int id, Future<dynamic> Function() action) async {
    _actionLoadingId = id;
    update();
    ResponseModel responseModel = await action();
    await syncHappyHour(id);
    if(responseModel.isSuccess && _happyHourList != null) {
      await getHappyHourList(offset: 1);
    }
    _actionLoadingId = null;
    update();
    showCustomSnackBar(responseModel.message, isError: !responseModel.isSuccess);
    return responseModel.isSuccess;
  }

}
