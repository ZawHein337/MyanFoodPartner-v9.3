import 'package:stackfood_multivendor_restaurant/features/campaign/domain/models/campaign_model.dart';

abstract class CampaignServiceInterface {
  Future<dynamic> getCampaignList();
  Future<dynamic> joinCampaign(int? campaignID);
  Future<dynamic> leaveCampaign(int? campaignID);
  List<CampaignModel>? filterCampaign(String status, List<CampaignModel> allCampaignList);
}