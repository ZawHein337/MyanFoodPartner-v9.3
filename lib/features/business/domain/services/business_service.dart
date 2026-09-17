import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_body.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/repositories/business_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/services/business_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class BusinessService implements BusinessServiceInterface{
  final BusinessRepositoryInterface businessRepositoryInterface;
  BusinessService({required this.businessRepositoryInterface});

  @override
  Future<PackageModel?> getPackageList() async {
    return await businessRepositoryInterface.getList();
  }

  @override
  Future<String> processesBusinessPlan(String businessPlanStatus, int paymentIndex, int restaurantId, String? digitalPaymentName, int? selectedPackageId) async {

    String businessPlan = 'subscription';
    int? packageId = selectedPackageId;
    String? payment = paymentIndex == 0 ? 'free_trial' : digitalPaymentName;

    if(paymentIndex == 1 && digitalPaymentName == null) {
      showCustomSnackBar('please_select_payment_method'.tr);
    } else {
      businessPlanStatus = await setUpBusinessPlan(
        BusinessPlanBody(
          businessPlan: businessPlan,
          packageId: packageId.toString(),
          restaurantId: restaurantId.toString(),
          payment: payment,
          paymentGateway: payment,
          callBack: paymentIndex == 0 ? '' : RouteHelper.success,
          paymentPlatform: 'app',
          type: 'new_join',
        ),
        digitalPaymentName, businessPlanStatus, restaurantId, packageId!,
      );
    }
    return businessPlanStatus;
  }

  @override
  Future<String> setUpBusinessPlan(BusinessPlanBody businessPlanBody, String? digitalPaymentName, String businessPlanStatus, int restaurantId, int? packageId) async {
    Response response = await businessRepositoryInterface.setUpBusinessPlan(businessPlanBody);
    if (response.statusCode == 200) {
      if(response.body['redirect_link'] != null) {
        String redirectUrl = response.body['redirect_link'];
        Get.back();
        Get.toNamed(RouteHelper.getPaymentRoute(digitalPaymentName, redirectUrl, restaurantId, true, packageId));
      }else {
        businessPlanStatus = 'complete';
        Get.offAllNamed(RouteHelper.getSubscriptionSuccessRoute(status: 'success', fromSubscription: false, restaurantId: restaurantId, packageId: packageId));
      }
    }
    return businessPlanStatus;
  }

}