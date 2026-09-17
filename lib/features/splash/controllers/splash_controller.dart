import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/domain/services/splash_service_interface.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  final DateTime _currentTime = DateTime.now();
  DateTime get currentTime => _currentTime;

  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> getConfigData() async {
    ConfigModel? configModel  = await splashServiceInterface.getConfigData();
    bool isSuccess = false;
    if(configModel != null) {
      _configModel = configModel;

      splashServiceInterface.handleInitialTopicSubscription();
      bool isMaintenanceMode = _configModel!.maintenanceMode!;
      String platform = 'restaurant_app';
      bool isInMaintenance = isMaintenanceMode && _configModel!.maintenanceModeData!.maintenanceSystemSetup!.contains(platform);

      if(isInMaintenance) {
        Get.offNamed(RouteHelper.getUpdateRoute(false));
      }else if((Get.currentRoute.contains(RouteHelper.update) && !isMaintenanceMode) || (!isInMaintenance)) {
        if(Get.find<AuthController>().isLoggedIn()) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }/*else {
          Get.offAllNamed(RouteHelper.getSignInRoute());
        }*/
      }

      isSuccess = true;
      Get.find<RestaurantController>().setOrderStatus(_configModel!.instantOrder!, _configModel!.scheduleOrder!);
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashServiceInterface.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashServiceInterface.removeSharedData();
  }

  bool showIntro() {
    return splashServiceInterface.showIntro();
  }

  void setIntro(bool intro) {
    splashServiceInterface.setIntro(intro);
  }

  void initialConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  bool isRestaurantClosed() {
    DateTime open = DateFormat('hh:mm').parse('');
    DateTime close = DateFormat('hh:mm').parse('');
    DateTime openTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, open.hour, open.minute);
    DateTime closeTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, close.hour, close.minute);
    if(closeTime.isBefore(openTime)) {
      closeTime = closeTime.add(const Duration(days: 1));
    }
    if(_currentTime.isAfter(openTime) && _currentTime.isBefore(closeTime)) {
      return false;
    }else {
      return true;
    }
  }

}