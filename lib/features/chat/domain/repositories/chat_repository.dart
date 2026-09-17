import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository implements ChatRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ChatRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ConversationsModel?> getConversationList(int offset, String type) async {
    ConversationsModel? conversationModel;
    Response response = await apiClient.getData('${AppConstants.getConversationListUri}?offset=$offset&limit=10&type=$type');
    if(response.statusCode == 200) {
      conversationModel = ConversationsModel.fromJson(response.body);
    }
    return conversationModel;
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    ConversationsModel? searchConversationModel;
    Response response = await apiClient.getData('${AppConstants.searchConversationUri}?name=$name&limit=20&offset=1');
    if(response.statusCode == 200) {
      searchConversationModel = ConversationsModel.fromJson(response.body);
    }
    return searchConversationModel;
  }

  @override
  Future<Response> getMessages(int offset, int? userId, UserType userType, int? conversationID) async {
    return await apiClient.getData('${AppConstants.getMessageListUri}?offset=$offset&limit=10&${conversationID != null ?
    'conversation_id' : userType == UserType.admin ? 'admin_id' : userType == UserType.delivery_man ? 'delivery_man_id' : 'user_id'}=${conversationID ?? userId}');
  }

  @override
  Future<Response> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, UserType userType) async {
    return await apiClient.postMultipartData(
      AppConstants.sendMessageUri,
      {'message': message, 'receiver_type': userType.name, conversationId != null ? 'conversation_id' : 'receiver_id': '${conversationId ?? userId}', 'offset': '1', 'limit': '10'},
      images, [],
    );
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}