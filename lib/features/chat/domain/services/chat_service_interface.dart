import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';

abstract class ChatServiceInterface {
  Future<dynamic> getConversationList(int offset, String type);
  Future<dynamic> searchConversationList(String name);
  Future<dynamic> getMessages(int offset, int? userId, UserType userType, int? conversationID);
  Future<dynamic> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, UserType userType);
  List<MultipartBody> processImages(List <XFile>? chatImage, List<XFile> chatFiles, XFile? videoFile);
  bool checkSender(List<Conversation?>? conversations);
  int setIndex(List<Conversation?>? conversations);
  int findOutConversationUnreadIndex(List<Conversation?>? conversations, int? conversationID);
}