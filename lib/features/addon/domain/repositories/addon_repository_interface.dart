import 'package:stackfood_multivendor_restaurant/features/addon/domain/models/addon_category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class AddonRepositoryInterface<T> implements RepositoryInterface<AddOns> {
  Future<List<AddonCategoryModel>?> getAddonCategory({required int moduleId});
  Future<bool> updateAddon(AddOns addonModel);
}