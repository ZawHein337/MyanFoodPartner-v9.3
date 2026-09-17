import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/running_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/models/subscription_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderController extends GetxController implements GetxService {
  final OrderServiceInterface orderServiceInterface;
  OrderController({required this.orderServiceInterface});

  List<RunningOrderModel>? _runningOrders;
  List<RunningOrderModel>? get runningOrders => _runningOrders;

  // Per-status counts for the ongoing-order tab badges, served by the API.
  OrderStatusCount? _orderStatusCount;
  OrderStatusCount? get orderStatusCount => _orderStatusCount;

  // API status value sent for each ongoing tab (parallel to [_runningOrders]).
  final List<String> _runningStatusList = ['pending', 'accepted', 'confirmed', 'processing', 'handover', 'picked_up'];
  List<String> get runningStatusList => _runningStatusList;

  bool _runningOrderLoading = false;
  bool get runningOrderLoading => _runningOrderLoading;

  bool _runningPaginate = false;
  bool get runningPaginate => _runningPaginate;

  int? _runningPageSize;
  int? get runningPageSize => _runningPageSize;

  List<int> _runningOffsetList = [];

  int _runningOffset = 1;
  int get runningOffset => _runningOffset;

  List<RunningOrderModel> _buildRunningOrderTabs() => [
    RunningOrderModel(status: 'pending', orderList: []),
    RunningOrderModel(status: 'accepted', orderList: []),
    RunningOrderModel(status: 'confirmed', orderList: []),
    RunningOrderModel(status: 'cooking', orderList: []),
    RunningOrderModel(status: 'ready_for_handover', orderList: []),
    RunningOrderModel(status: 'food_on_the_way', orderList: []),
  ];

  List<OrderModel>? _historyOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;

  List<OrderDetailsModel>? _orderDetailsModel;
  List<OrderDetailsModel>? get orderDetailsModel => _orderDetailsModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _orderIndex = 0;
  int get orderIndex => _orderIndex;

  bool _campaignOnly = false;
  bool get campaignOnly => _campaignOnly;

  bool _subscriptionOnly = false;
  bool get subscriptionOnly => _subscriptionOnly;

  String _otp = '';
  String get otp => _otp;

  int _historyIndex = 0;
  int get historyIndex => _historyIndex;

  final List<String> _statusList = ['all', 'delivered', 'refunded', 'canceled', 'failed'];
  List<String> get statusList => _statusList;

  int? _deliveredOrderCount = 0;
  int?get deliveredOrderCount => _deliveredOrderCount;

  int? _refundedOrderCount = 0;
  int? get refundedOrderCount => _refundedOrderCount;

  int? _canceledOrderCount = 0;
  int? get canceledOrderCount => _canceledOrderCount;

  int? _failedOrderCount = 0;
  int? get failedOrderCount => _failedOrderCount;

  bool _paginate = false;
  bool get paginate => _paginate;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<int> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  List<CancellationData>? _orderCancelReasons;
  List<CancellationData>? get orderCancelReasons => _orderCancelReasons;

  String? _cancelReason = '';
  String? get cancelReason => _cancelReason;

  SubscriptionModel? _subscriptionModel;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  bool _showDeliveryImageField = false;
  bool get showDeliveryImageField => _showDeliveryImageField;

  List<XFile> _pickedPrescriptions = [];
  List<XFile> get pickedPrescriptions => _pickedPrescriptions;

  bool _hideNotificationButton = false;
  bool get hideNotificationButton => _hideNotificationButton;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  Future<bool> sendDeliveredNotification(int? orderID) async {
    _hideNotificationButton = true;
    update();
    bool success = await orderServiceInterface.sendDeliveredNotification(orderID);
    bool isSuccess;
    success ? isSuccess = true : isSuccess = false;
    _hideNotificationButton = false;
    update();
    return isSuccess;
  }

  void changeDeliveryImageStatus({bool willUpdate = true}){
    _showDeliveryImageField = !_showDeliveryImageField;
    if(willUpdate) {
      update();
    }
  }

  void pickPrescriptionImage({required bool isRemove, required bool isCamera}) async {
    if(isRemove) {
      _pickedPrescriptions = [];
    }else {
      XFile? xFile = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 50);
      if(xFile != null) {
        _pickedPrescriptions.add(xFile);
        if(Get.isDialogOpen!){
          Get.back();
        }
      }
      update();
    }
  }

  void removePrescriptionImage(int index) {
    _pickedPrescriptions.removeAt(index);
    update();
  }

  void setOrderCancelReason(String? reason){
    _cancelReason = reason;
    update();
  }

  Future<void> getOrderCancelReasons() async {
    List<CancellationData>? orderCancelReasons = await orderServiceInterface.getCancelReasons();
    if (orderCancelReasons != null) {
      _orderCancelReasons = [];
      _orderCancelReasons!.addAll(orderCancelReasons);
    }
    update();
  }


  Future<void> setOrderDetails(OrderModel orderModel) async {
    if(orderModel.orderStatus != null && orderModel.customer != null && orderModel.deliveryMan != null){
      _orderModel = orderModel;
    }else{
      OrderModel? order = await orderServiceInterface.getOrderWithId(orderModel.id);
      if(order != null) {
        _orderModel = order;
      }
      update();
    }
  }

  Future<void> getCurrentOrders({int offset = 1, bool reload = false}) async {
    if(offset == 1 || reload) {
      _runningOffsetList = [];
      _runningOffset = 1;
      _runningOrderLoading = true;
      if(_runningOrders != null) {
        _runningOrders![_orderIndex].orderList = [];
      }
      update();
    }

    if(_runningOffsetList.contains(offset)) {
      if(_runningPaginate) {
        _runningPaginate = false;
        update();
      }
      return;
    }
    _runningOffsetList.add(offset);

    CurrentOrderModel? currentOrderModel = await orderServiceInterface.getCurrentOrders(
      status: _runningStatusList[_orderIndex],
      offset: offset,
      isCampaign: _campaignOnly ? 1 : 0,
      isSubscription: _subscriptionOnly ? 1 : 0,
    );

    if(currentOrderModel != null) {
      _runningOrders ??= _buildRunningOrderTabs();
      if(offset == 1) {
        _runningOrders![_orderIndex].orderList = [];
      }
      _runningOrders![_orderIndex].orderList.addAll(currentOrderModel.orders ?? []);
      _runningPageSize = currentOrderModel.totalSize;
      _orderStatusCount = currentOrderModel.statusCount;
    }
    _runningOrderLoading = false;
    _runningPaginate = false;
    update();
  }

  int getRunningOrderCount(int index) {
    if(_orderStatusCount == null) {
      return 0;
    }
    switch(index) {
      case 0: return _orderStatusCount!.pending ?? 0;
      case 1: return _orderStatusCount!.accepted ?? 0;
      case 2: return _orderStatusCount!.confirmed ?? 0;
      case 3: return _orderStatusCount!.processing ?? 0;
      case 4: return _orderStatusCount!.handover ?? 0;
      case 5: return _orderStatusCount!.pickedUp ?? 0;
      default: return 0;
    }
  }

  void showRunningBottomLoader() {
    _runningPaginate = true;
    update();
  }

  void setRunningOffset(int offset) {
    _runningOffset = offset;
  }

  Future<void> getPaginatedOrders(int offset, bool reload, {required int isSubscription}) async {
    if(offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if(reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      PaginatedOrderModel? historyOrderModel = await orderServiceInterface.getPaginatedOrderList(offset: offset, status: _statusList[_historyIndex], isSubscription: isSubscription);
      if (historyOrderModel != null) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList!.addAll(historyOrderModel.orders!);
        _pageSize = historyOrderModel.totalSize;
        _deliveredOrderCount = historyOrderModel.delivered;
        _refundedOrderCount = historyOrderModel.refunded;
        _canceledOrderCount = historyOrderModel.canceled;
        _failedOrderCount = historyOrderModel.failed;
        _paginate = false;
        update();
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<bool> updateOrderStatus(int? orderID, String status, {bool back = false, String? processingTime, String? reason, bool backWitheResult = true}) async {
    _isLoading = true;
    update();
    List<MultipartBody> multiParts = [];
    for(XFile file in _pickedPrescriptions) {
      multiParts.add(MultipartBody('order_proof[]', file));
    }
    UpdateStatusModel updateStatusBody = UpdateStatusModel(
      orderId: orderID, status: status,
      otp: status == 'delivered' ? _otp : null,
      processingTime: processingTime,
      reason: reason,
    );
    ResponseModel responseModel = await orderServiceInterface.updateOrderStatus(updateStatusBody, multiParts);
    if(backWitheResult) {
      Get.back(result: responseModel.isSuccess);
    }
    if(responseModel.isSuccess) {
      if(back) {
        Get.back();
      }
      getCurrentOrders();
      showCustomSnackBar(responseModel.message, isError: false);
    }else{
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  Future<void> getOrderDetails(int orderID) async {
    _orderDetailsModel = null;
    Response response = await orderServiceInterface.getOrderDetails(orderID);
    if(response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body['order']['details'].forEach((orderDetails) => _orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
      if(response.body['order']['subscription'] != null){
        _subscriptionModel = SubscriptionModel.fromJson(response.body['order']['subscription']);
      }
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    getCurrentOrders(offset: 1, reload: true);
    update();
  }

  void toggleCampaignOnly() {
    if(_subscriptionOnly) {
      _subscriptionOnly = false;
    }
    _campaignOnly = !_campaignOnly;
    getCurrentOrders(offset: 1, reload: true);
    update();
  }

  void toggleSubscriptionOnly() {
    if(_campaignOnly) {
      _campaignOnly = false;
    }
    _subscriptionOnly = !_subscriptionOnly;
    getCurrentOrders(offset: 1, reload: true);
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if(otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(1, true, isSubscription: _orderTypeIndex == 1 ? 1 : 0);
    update();
  }

  String? getBluetoothMacAddress() => orderServiceInterface.getBluetoothAddress();

  void setBluetoothMacAddress(String? address) => orderServiceInterface.setBluetoothAddress(address);

  Future<void> addDineInTableAndTokenNumber({int? orderId, String? tableNumber, String? tokenNumber}) async {
    _isLoading = true;
    update();
    bool isSuccess = await orderServiceInterface.addDineInTableAndTokenNumber(orderId, tableNumber, tokenNumber);
    if(isSuccess){
      await setOrderDetails(_orderModel!);
      showCustomSnackBar('table_token_added_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void changeOrderTypeIndex(int index, {bool isUpdate = true}) {
    _orderTypeIndex = index;
    getPaginatedOrders(1, true, isSubscription: index == 1 ? 1 : 0);
    if(isUpdate) {
      update();
    }
  }

}