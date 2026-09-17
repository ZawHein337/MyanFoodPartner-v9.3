import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/models/campaign_model.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class CampaignRepository implements CampaignRepositoryInterface {
  final ApiClient apiClient;
  CampaignRepository({required this.apiClient});

  @override
  Future<List<CampaignModel>?> getList() async {
    List<CampaignModel>? campaignList;
    Response response = await apiClient.getData(AppConstants.basicCampaignUri);
    if (response.statusCode == 200) {
      campaignList = [];
      response.body.forEach((campaign) {
        campaignList!.add(CampaignModel.fromJson(campaign));
      });
    }
    return campaignList;
  }

  @override
  Future<bool> joinCampaign(int? campaignID) async {
    Response response = await apiClient.putData(AppConstants.joinCampaignUri, {'campaign_id': campaignID});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> leaveCampaign(int? campaignID) async {
    Response response = await apiClient.putData(AppConstants.leaveCampaignUri, {'campaign_id': campaignID});
    return (response.statusCode == 200);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}