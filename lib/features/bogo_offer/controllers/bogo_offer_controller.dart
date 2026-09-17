import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/models/bogo_offer_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/services/bogo_offer_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class BogoOfferController extends GetxController {
  final BogoOfferServiceInterface bogoOfferServiceInterface;
  BogoOfferController({required this.bogoOfferServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  List<BogoOffer>? _bogoOfferList;
  List<BogoOffer>? get bogoOfferList => _bogoOfferList;

  int _all = 0;
  int _notJoined = 0;
  int _pending = 0;
  int _adminRequested = 0;
  int _approved = 0;
  int _rejected = 0;
  int get all => _all;
  int get notJoined => _notJoined;
  int get pending => _pending;
  int get adminRequested => _adminRequested;
  int get approved => _approved;
  int get rejected => _rejected;

  String _type = 'all';
  String get type => _type;

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setType(String type) {
    _type = type;
    getBogoOfferList(offset: '1', type: type);
  }

  Future<void> getBogoOfferList({required String offset, String? search, String? type, bool isUpdate = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _bogoOfferList = null;
      if(isUpdate) {
        update();
      }
    }

    if(!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      BogoOfferModel? bogoOfferModel = await bogoOfferServiceInterface.getBogoOfferList(offset, search: search, type: type ?? _type);
      if(bogoOfferModel != null) {
        if(offset == '1') {
          _bogoOfferList = [];
        }
        _bogoOfferList!.addAll(bogoOfferModel.offers ?? []);
        _pageSize = bogoOfferModel.totalSize;
        _all = bogoOfferModel.all ?? 0;
        _notJoined = bogoOfferModel.notJoined ?? 0;
        _pending = bogoOfferModel.pending ?? 0;
        _adminRequested = bogoOfferModel.adminRequested ?? 0;
        _approved = bogoOfferModel.approved ?? 0;
        _rejected = bogoOfferModel.rejected ?? 0;
        _isLoading = false;
        update();
      }
    } else if(_isLoading) {
      _isLoading = false;
      update();
    }
  }

  BogoOffer? _bogoOfferDetails;
  BogoOffer? get bogoOfferDetails => _bogoOfferDetails;

  bool _isDetailsLoading = false;
  bool get isDetailsLoading => _isDetailsLoading;

  Future<void> getBogoOfferDetails(int offerId, {bool isUpdate = true}) async {
    _isDetailsLoading = true;
    _bogoOfferDetails = null;
    if(isUpdate) {
      update();
    }

    _bogoOfferDetails = await bogoOfferServiceInterface.getBogoOfferDetails(offerId);

    _isDetailsLoading = false;
    update();
  }

  /// Reads one offer without touching [bogoOfferDetails], so a background lookup —
  /// a push deciding whether to prompt, say — cannot disturb an open details screen.
  Future<BogoOffer?> fetchBogoOffer(int offerId) async {
    return await bogoOfferServiceInterface.getBogoOfferDetails(offerId);
  }

  /// Looks up an outstanding admin invitation without touching [bogoOfferList], so
  /// asking the question does not disturb a list the restaurant is already reading.
  Future<BogoOffer?> getAdminRequestedBogoOffer() async {
    final BogoOfferModel? bogoOfferModel = await bogoOfferServiceInterface.getBogoOfferList('1', type: 'admin_requested');
    for(final BogoOffer offer in bogoOfferModel?.offers ?? []) {
      if(offer.isPendingAdminRequest) {
        return offer;
      }
    }
    return null;
  }

  /// Announced once per session, by whichever screen notices it first, so the
  /// restaurant is not asked the same thing again on every screen it opens.
  bool _adminRequestSheetShown = false;
  bool get adminRequestSheetShown => _adminRequestSheetShown;

  void markAdminRequestSheetShown() {
    _adminRequestSheetShown = true;
  }

  /// Brings an offer up to date after an admin decision arrives by push. Unlike
  /// [getBogoOfferDetails] this keeps the current details on screen while the
  /// request is in flight, so the vendor sees the status and buttons change
  /// rather than the whole screen dropping to a spinner.
  Future<void> syncBogoOffer(int offerId) async {
    if(_bogoOfferDetails?.id != offerId) {
      return;
    }

    final BogoOffer? details = await bogoOfferServiceInterface.getBogoOfferDetails(offerId);
    if(details == null || _bogoOfferDetails?.id != offerId) {
      return;
    }

    _bogoOfferDetails = details;
    update();
  }

  bool _isJoinLoading = false;
  bool get isJoinLoading => _isJoinLoading;

  Future<bool> joinBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems) async {
    _isJoinLoading = true;
    update();

    bool isSuccess = false;
    BogoOfferJoinResponseModel? bogoOfferJoinResponseModel = await bogoOfferServiceInterface.joinBogoOffer(offerId, buyItems, getItems);
    if(bogoOfferJoinResponseModel != null) {
      isSuccess = true;
      showCustomSnackBar(bogoOfferJoinResponseModel.message, isError: false);
    }

    _isJoinLoading = false;
    update();
    return isSuccess;
  }

  bool _isResubmitLoading = false;
  bool get isResubmitLoading => _isResubmitLoading;

  Future<bool> resubmitBogoOffer(int offerId, List<Map<String, dynamic>> buyItems, List<Map<String, dynamic>> getItems) async {
    _isResubmitLoading = true;
    update();

    bool isSuccess = false;
    BogoOfferJoinResponseModel? bogoOfferJoinResponseModel = await bogoOfferServiceInterface.resubmitBogoOffer(offerId, buyItems, getItems);
    if(bogoOfferJoinResponseModel != null) {
      isSuccess = true;
      showCustomSnackBar(bogoOfferJoinResponseModel.message, isError: false);
    }

    _isResubmitLoading = false;
    update();
    return isSuccess;
  }

  bool _isLeaveLoading = false;
  bool get isLeaveLoading => _isLeaveLoading;

  Future<bool> leaveBogoOffer(int offerId) async {
    _isLeaveLoading = true;
    update();

    bool isSuccess = false;
    ResponseModel? responseModel = await bogoOfferServiceInterface.leaveBogoOffer(offerId);
    if(responseModel != null) {
      isSuccess = true;
      showCustomSnackBar(responseModel.message, isError: false);
    }

    _isLeaveLoading = false;
    update();
    return isSuccess;
  }

  bool _isRespondLoading = false;
  bool get isRespondLoading => _isRespondLoading;

  Future<bool> respondToBogoOffer(int offerId, {required String status, String? rejectionReason}) async {
    _isRespondLoading = true;
    update();

    bool isSuccess = false;
    ResponseModel? responseModel = await bogoOfferServiceInterface.respondToBogoOffer(offerId, status: status, rejectionReason: rejectionReason);
    if(responseModel != null) {
      isSuccess = true;
      showCustomSnackBar(responseModel.message, isError: false);
    }

    _isRespondLoading = false;
    update();
    return isSuccess;
  }

  List<Product>? _bogoFoods;
  List<Product>? get bogoFoods => _bogoFoods;

  bool _isFoodsLoading = false;
  bool get isFoodsLoading => _isFoodsLoading;

  Future<void> getBogoOfferFoods({String? search, bool isUpdate = true}) async {
    _isFoodsLoading = true;
    if(isUpdate) {
      update();
    }

    _bogoFoods = await bogoOfferServiceInterface.getBogoOfferFoods(search: search);

    _isFoodsLoading = false;
    update();
  }
}
