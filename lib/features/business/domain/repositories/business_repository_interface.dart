import 'package:get/get_connect/connect.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_body.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class BusinessRepositoryInterface<T> implements RepositoryInterface<T> {
  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody);
}