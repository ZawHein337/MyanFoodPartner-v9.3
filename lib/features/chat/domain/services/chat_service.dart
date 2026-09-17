import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:get/get.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(int offset, String type) async {
    return await chatRepositoryInterface.getConversationList(offset, type);
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.searchConversationList(name);
  }

  @override
  Future<Response> getMessages(int offset, int? userId, UserType userType, int? conversationID) async {
    return await chatRepositoryInterface.getMessages(offset, userId, userType, conversationID);
  }

  @override
  Future<Response> sendMessage(String message, List<MultipartBody> images, int? conversationId, int? userId, UserType userType) async {
    return await chatRepositoryInterface.sendMessage(message, images, conversationId, userId, userType);
  }

  @override
  List<MultipartBody> processImages(List <XFile>? chatImage, List<XFile> chatFiles, XFile? videoFile) {
    List<MultipartBody> myImages = [];
    for (var image in chatImage!) {
      myImages.add(MultipartBody('image[]', image));
    }
    for (var file in chatFiles) {
      myImages.add(MultipartBody('image[]', file));
    }
    if(videoFile != null) {
      myImages.add(MultipartBody('image[]', videoFile));
    }
    return myImages;
  }

  @override
  bool checkSender(List<Conversation?>? conversations) {
    bool sender = false;
    for(int index=0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        sender = true;
        break;
      }
    }
    return sender;
  }

  @override
  int setIndex(List<Conversation?>? conversations) {
    int index0 = -1;
    for(int index=0; index<conversations!.length; index++) {
      if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }else if(conversations[index]!.receiverType == UserType.admin.name) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  int findOutConversationUnreadIndex(List<Conversation?>? conversations, int? conversationID) {
    int index0 = -1;
    for(int index=0; index<conversations!.length; index++) {
      if(conversationID == conversations[index]!.id) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

}