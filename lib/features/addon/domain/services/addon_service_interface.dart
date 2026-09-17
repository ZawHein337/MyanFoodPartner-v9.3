import 'package:stackfood_multivendor_restaurant/features/addon/domain/models/addon_category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

abstract class AddonServiceInterface {
  Future<List<AddOns>?> getAddonList();
  Future<bool> addAddon(AddOns addonModel);
  Future<bool> updateAddon(AddOns addonModel);
  Future<bool> deleteAddon(int id);
  List<int?> prepareAddonIds(List<AddOns> addonList);
  Future<List<AddonCategoryModel>?> getAddonCategory({required int moduleId});
}