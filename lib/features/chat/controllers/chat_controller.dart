import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/image_size_checker.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';

class ChatController extends GetxController implements GetxService {
  final ChatServiceInterface chatServiceInterface;
  ChatController({required this.chatServiceInterface});

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  bool _tabLoading= false;
  bool get tabLoading => _tabLoading;

  List<bool>? _showDate;
  List<bool>? get showDate => _showDate;

  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;

  final bool _isSeen = false;
  bool get isSeen => _isSeen;

  final bool _isSend = true;
  bool get isSend => _isSend;

  List <XFile>?_chatImage = [];
  List<XFile>? get chatImage => _chatImage;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _offset;
  int? get offset => _offset;

  String _type = 'customer';
  String get type => _type;

  bool _clickTab = false;
  bool get clickTab => _clickTab;

  ConversationsModel? _conversationModel;
  ConversationsModel? get conversationModel => _conversationModel;

  ConversationsModel? _searchConversationModel;
  ConversationsModel? get searchConversationModel => _searchConversationModel;

  MessageModel? _messageModel;
  MessageModel? get messageModel => _messageModel;

  int _onMessageTimeShowID = 0;
  int get onMessageTimeShowID => _onMessageTimeShowID;

  int _onImageOrFileTimeShowID = 0;
  int get onImageOrFileTimeShowID => _onImageOrFileTimeShowID;

  bool _isClickedOnMessage = false;
  bool get isClickedOnMessage => _isClickedOnMessage;

  bool _isClickedOnImageOrFile = false;
  bool get isClickedOnImageOrFile => _isClickedOnImageOrFile;

  bool _takeImageLoading= false;
  bool get takeImageLoading => _takeImageLoading;

  List <Uint8List>_chatRawImage = [];
  List<Uint8List> get chatRawImage => _chatRawImage;

  List<XFile> objFile = [];

  bool _singleFIleCrossMaxLimit = false;
  bool get singleFIleCrossMaxLimit => _singleFIleCrossMaxLimit;

  XFile? _pickedVideoFile;
  XFile? get pickedVideoFile => _pickedVideoFile;

  bool _showFloatingButton = false;
  bool get showFloatingButton => _showFloatingButton;

  Conversation? _adminConversationModel;
  Conversation? get adminConversationModel => _adminConversationModel;

  bool _hasAdmin = true;
  bool get hasAdmin => _hasAdmin;

  bool _isEmojiPickerVisible = false;
  bool get isEmojiPickerVisible => _isEmojiPickerVisible;

  void toggleEmojiPicker() {
    _isEmojiPickerVisible = !_isEmojiPickerVisible;
    update();
  }

  Future<void> getConversationList(int offset, {String type = '', bool canUpdate = true, bool fromTab = true}) async {
    if(fromTab) {
      _tabLoading = true;
    }
    if(canUpdate) {
      update();
    }
    _hasAdmin = true;
    _searchConversationModel = null;
    ConversationsModel? conversationModel = await chatServiceInterface.getConversationList(offset, type);
    if(conversationModel != null) {
      if(offset == 1) {
        _conversationModel = conversationModel;
      }else {
        _conversationModel!.totalSize = conversationModel.totalSize;
        _conversationModel!.offset = conversationModel.offset;
        _conversationModel!.conversations!.addAll(conversationModel.conversations!);
      }

      bool sender = chatServiceInterface.checkSender(_conversationModel!.conversations);
      _hasAdmin = false;

      if(sender) {
        _hasAdmin = true;
      }
    }
    _tabLoading = false;
    update();
  }

  Future<void> searchConversation(String name) async {
    _searchConversationModel = ConversationsModel();
    update();
    ConversationsModel searchConversationModel = await chatServiceInterface.searchConversationList(name);
    if(searchConversationModel.conversations != null) {
      _searchConversationModel = searchConversationModel;
      int index0 = chatServiceInterface.setIndex(_searchConversationModel!.conversations);
      late bool sender = chatServiceInterface.checkSender(_searchConversationModel!.conversations);
      if(index0 != -1) {
        if(sender) {
          _searchConversationModel!.conversations![index0].sender = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            imageFullUrl: Get.find<SplashController>().configModel!.favIconFullUrl,
          );
        }else {
          _searchConversationModel!.conversations![index0].receiver = User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            phone: Get.find<SplashController>().configModel!.phone, email: Get.find<SplashController>().configModel!.email,
            imageFullUrl: Get.find<SplashController>().configModel!.favIconFullUrl,
          );
        }
      }
    }
    update();
  }

  void removeSearchMode() {
    _searchConversationModel = null;
    update();
  }

  Future<void> getMessages(int offset, NotificationBodyModel? notificationBody, User? user, int? conversationID, {bool firstLoad = false}) async {
    Response? response;
    if(firstLoad) {
      _messageModel = null;
      _isSendButtonActive = false;
      _isLoading = false;
    }

    if(notificationBody == null || notificationBody.adminId != null) {
      response = await chatServiceInterface.getMessages(offset, 0, UserType.admin, null);
    } else if(notificationBody.customerId != null || notificationBody.type == UserType.customer.name || notificationBody.type == UserType.user.name) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.customerId, UserType.user, conversationID);
    }else if(notificationBody.deliveryManId != null || notificationBody.type == UserType.delivery_man.name) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.deliveryManId, UserType.delivery_man, conversationID);
    }

    if (response != null && response.body['messages'] != {} && response.statusCode == 200) {
      if (offset == 1) {

        /// Unread-read
        if(conversationID != null && _conversationModel != null) {
          int index = chatServiceInterface.findOutConversationUnreadIndex(_conversationModel!.conversations, conversationID);
          if(index != -1) {
            _conversationModel!.conversations![index].unreadMessageCount = 0;
          }
        }

        if(Get.find<ProfileController>().profileModel == null) {
          await Get.find<ProfileController>().getProfile();
        }

        /// Manage Receiver
        _messageModel = MessageModel.fromJson(response.body);
        if(_messageModel!.conversation == null) {
          _messageModel!.conversation = Conversation(sender: User(
            id: Get.find<ProfileController>().profileModel!.id, imageFullUrl: Get.find<ProfileController>().profileModel!.imageFullUrl,
            fName: Get.find<ProfileController>().profileModel!.fName, lName: Get.find<ProfileController>().profileModel!.lName,
          ), receiver: notificationBody!.adminId != null ? User(
            id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
            imageFullUrl: Get.find<SplashController>().configModel!.favIconFullUrl,
          ) : user);
        }
        _sortMessage(notificationBody!.adminId);
      }else {
        _messageModel!.totalSize = MessageModel.fromJson(response.body).totalSize;
        _messageModel!.offset = MessageModel.fromJson(response.body).offset;
        _messageModel!.messages!.addAll(MessageModel.fromJson(response.body).messages!);
      }
    }
    _isLoading = false;
    update();

  }

  Future<void> getAdminMessages() async {
    Response? response = await chatServiceInterface.getMessages(1, 0, UserType.admin, null);
    if (response != null && response.body['messages'] != {} && response.statusCode == 200) {
      _adminConversationModel = MessageModel.fromJson(response.body).conversation;
    }
    update();
  }

  void _sortMessage(int? adminId) {
    if(_messageModel!.conversation != null && (_messageModel!.conversation!.receiverType == UserType.user.name || _messageModel!.conversation!.receiverType == UserType.vendor.name)) {
      User? receiver = _messageModel!.conversation!.receiver;
      _messageModel!.conversation!.receiver = _messageModel!.conversation!.sender;
      _messageModel!.conversation!.sender = receiver;
    }
    if(adminId != null) {
      _messageModel!.conversation!.receiver = User(
        id: 0, fName: Get.find<SplashController>().configModel!.businessName, lName: '',
        imageFullUrl: Get.find<SplashController>().configModel!.favIconFullUrl,
      );
      getAdminMessages();
    }
  }

  void pickImage(bool isRemove) async {
    _takeImageLoading = true;
    update();

    if(isRemove) {
      _chatImage = [];
      _chatRawImage = [];
    } else {
      List<XFile> imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      for(XFile xFile in imageFiles) {
        if(_chatImage!.length >= AppConstants.maxImageSend) {
          showCustomSnackBar('can_not_add_more_than_3_image'.tr);
          break;
        }else {
          objFile = [];
          _pickedVideoFile = null;
          _chatImage?.add(xFile);
          _chatRawImage.add(await xFile.readAsBytes());
        }
      }
      _isSendButtonActive = true;
    }
    _takeImageLoading = false;
    update();
  }

  void pickFile(bool isRemove, {int? index}) async {
    _takeImageLoading = true;
    update();

    _singleFIleCrossMaxLimit = false;

    if(isRemove) {
      objFile.removeAt(index!);
    } else {
      List<PlatformFile>? platformFile = (await FilePicker.pickFiles(
        allowMultiple: true,
        withReadStream: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      ))?.files ;

      objFile = [];
      _chatImage = [];
      _pickedVideoFile = null;

      platformFile?.forEach((element) async {
        if(_getFileSizeFromPlatformFileToDouble(element) > AppConstants.maxSizeOfASingleFile) {
          _singleFIleCrossMaxLimit = true;
        } else {
          if(objFile.length < AppConstants.maxLimitOfTotalFileSent){
            if((await _getMultipleFileSizeFromPlatformFiles(objFile) + _getFileSizeFromPlatformFileToDouble(element)) < AppConstants.maxLimitOfFileSentINConversation){
              objFile.add(element.xFile);
            }
          }

        }
      });

      _isSendButtonActive = true;
    }
    _takeImageLoading = false;
    update();
  }

  void pickVideoFile(bool isRemove) async {
    _takeImageLoading = true;
    update();

    if(isRemove) {
      _pickedVideoFile = null;
    } else {
      _pickedVideoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if(_pickedVideoFile != null){
        double videoSize = await ImageSize.getImageSizeFromXFile(_pickedVideoFile!);
        if(videoSize > AppConstants.limitOfPickedVideoSizeInMB){
          _pickedVideoFile = null;
          showCustomSnackBar('${"video_size_greater_than".tr} ${AppConstants.limitOfPickedVideoSizeInMB}mb');
          update();
        }else{
          _chatImage = [];
          objFile = [];
        }

      }
      _isSendButtonActive = true;
    }
    _takeImageLoading = false;
    update();
  }

  void removeImage(int index,  String messageText){
    _chatImage?.removeAt(index);
    _chatRawImage.removeAt(index);
    if(_chatImage!.isEmpty && messageText.isEmpty) {
      _isSendButtonActive = false;
    }
    update();
  }

  Future<Response?> sendMessage({required String message, required NotificationBodyModel? notificationBody, required int? conversationId, required int? index}) async {
    Response? response;
    _isLoading = true;
    update();

    List<MultipartBody> chatImages = chatServiceInterface.processImages(_chatImage, objFile, _pickedVideoFile);

    if(notificationBody == null || notificationBody.adminId != null) {
      response = await chatServiceInterface.sendMessage(message, chatImages, 0, null, UserType.admin);
    } else if((notificationBody.customerId != null || notificationBody.type == UserType.customer.name)) {
      response = await chatServiceInterface.sendMessage(message, chatImages, conversationId , notificationBody.customerId, UserType.customer);
    }
    else if((notificationBody.deliveryManId != null || notificationBody.type == UserType.delivery_man.name)){
      response = await chatServiceInterface.sendMessage(message, chatImages, conversationId , notificationBody.deliveryManId, UserType.delivery_man);
    }

    if (response!.statusCode == 200) {
      _chatImage = [];
      objFile = [];
      _pickedVideoFile = null;
      _chatRawImage = [];
      _isSendButtonActive = false;
      _isLoading = false;
      _messageModel = MessageModel.fromJson(response.body);

      if(index != null && _searchConversationModel != null) {
        _searchConversationModel!.conversations![index].lastMessageTime = DateConverter.isoStringToLocalString(_messageModel!.messages![0].createdAt!);
      }else if(index != null && _conversationModel != null) {
        _conversationModel!.conversations![index].lastMessageTime = DateConverter.isoStringToLocalString(_messageModel!.messages![0].createdAt!);
      }
      if(_conversationModel != null && !_hasAdmin && (_messageModel!.conversation!.senderType == UserType.admin.name || _messageModel!.conversation!.receiverType == UserType.admin.name)) {
        _conversationModel!.conversations!.add(_messageModel!.conversation!);
        _hasAdmin = true;
      }

      _sortMessage(notificationBody!.adminId);
      Future.delayed(const Duration(seconds: 2),() {
        getMessages(1, notificationBody, null, conversationId);
      });
      /*if(_messageModel!.conversation != null && _messageModel!.conversation!.receiverType == 'vendor') {
        User? receiver = _messageModel!.conversation!.receiver;
        _messageModel!.conversation!.receiver = _messageModel!.conversation!.sender;
        _messageModel!.conversation!.sender = receiver;
      }*/
    }
    _isLoading = false;
    update();
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }

  void setType(String type, {bool willUpdate = true}) {
    _type = type;
    if(willUpdate) {
      update();
    }
  }

  void setTabSelect() {
    _clickTab = !_clickTab;
  }

  String getChatTime(String todayChatTimeInUtc, String? nextChatTimeInUtc) {
    String chatTime = '';
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    try{
      todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(todayChatTimeInUtc);
    }catch(e) {
      todayConversationDateTime = DateConverter.dateTimeStringToDate(todayChatTimeInUtc);
    }

    if (kDebugMode) {
      print("Current Message DataTime: $todayConversationDateTime");
    }

    DateTime nextConversationDateTime;
    DateTime currentDate = DateTime.now();

    if(nextChatTimeInUtc == null){
      return chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
    }else{
      nextConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(nextChatTimeInUtc);
      if (kDebugMode) {
        print("Next Message DateTime: $nextConversationDateTime");
        print("The Difference between this two : ${todayConversationDateTime.difference(nextConversationDateTime)}");
        print("Today message Weekday: ${todayConversationDateTime.weekday}\n Next Message WeekDay: ${nextConversationDateTime.weekday}");
      }


      if(todayConversationDateTime.difference(nextConversationDateTime) < const Duration(minutes: 30) &&
          todayConversationDateTime.weekday == nextConversationDateTime.weekday){
        chatTime = '';
      }else if(currentDate.weekday != todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        if( (currentDate.weekday -1 == 0 ? 7 : currentDate.weekday -1) == todayConversationDateTime.weekday){
          chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, false);
        }else{
          chatTime = DateConverter.convertStringTimeToDateTime(todayConversationDateTime);
        }

      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) < 6){
        chatTime = DateConverter.convert24HourTimeTo12HourTimeWithDay(todayConversationDateTime, true);
      }else{
        chatTime = DateConverter.isoStringToLocalDateAndTime(todayChatTimeInUtc);
      }
    }
    return chatTime;
  }

  String getChatTimeWithPrevious (Message currentChat, Message? previousChat) {
    DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(currentChat.createdAt ?? "");

    DateTime previousConversationDateTime;

    if(previousChat?.createdAt == null) {
      return 'Not-Same';
    } else {
      previousConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(previousChat!.createdAt!);
      if(kDebugMode) {
        print("The Difference is ${previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30)}");
      }
      if(previousConversationDateTime.difference(todayConversationDateTime) < const Duration(minutes: 30) &&
          todayConversationDateTime.weekday == previousConversationDateTime.weekday && _isSameUserWithPreviousMessage(currentChat, previousChat)) {
        return '';
      } else {
        return 'Not-Same';
      }
    }
  }

  bool _isSameUserWithPreviousMessage(Message? previousConversation, Message? currentConversation){
    if(previousConversation?.senderId == currentConversation?.senderId && previousConversation?.message != null && currentConversation?.message !=null){
      return true;
    }
    return false;
  }

  void toggleOnClickMessage(int onMessageTimeShowID, {bool recall = true}) {
    _onImageOrFileTimeShowID = 0;
    _isClickedOnImageOrFile = false;
    if(_isClickedOnMessage && _onMessageTimeShowID != onMessageTimeShowID){
      _onMessageTimeShowID = onMessageTimeShowID;
    }else if(_isClickedOnMessage && _onMessageTimeShowID == onMessageTimeShowID){
      _isClickedOnMessage = false;
      _onMessageTimeShowID = 0;
    }else{
      _isClickedOnMessage = true;
      _onMessageTimeShowID = onMessageTimeShowID;
    }
    update();
  }

  String? getOnPressChatTime(Message currentMessage) {

    if(currentMessage.id == _onMessageTimeShowID || currentMessage.id == _onImageOrFileTimeShowID){
      DateTime currentDate = DateTime.now();
      DateTime todayConversationDateTime = DateConverter.isoUtcStringToLocalTimeOnly(currentMessage.createdAt ?? "");

      if(currentDate.weekday != todayConversationDateTime.weekday && DateConverter.countDays(todayConversationDateTime) <= 7){
        return DateConverter.convertDateTimeToDate(todayConversationDateTime);
      }else if(currentDate.weekday == todayConversationDateTime.weekday
          && DateConverter.countDays(todayConversationDateTime) <= 7){
        return DateConverter.convertDateTimeToDate(todayConversationDateTime);
      }else{
        return DateConverter.isoStringToLocalDateAndTime(currentMessage.createdAt!);
      }
    }else{
      return null;
    }
  }

  void toggleOnClickImageAndFile(int onImageOrFileTimeShowID) {
    _onMessageTimeShowID = 0;
    _isClickedOnMessage = false;
    if(_isClickedOnImageOrFile && _onImageOrFileTimeShowID != onImageOrFileTimeShowID){
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    }else if(_isClickedOnImageOrFile && _onImageOrFileTimeShowID == onImageOrFileTimeShowID){
      _isClickedOnImageOrFile = false;
      _onImageOrFileTimeShowID = 0;
    }else{
      _isClickedOnImageOrFile = true;
      _onImageOrFileTimeShowID = onImageOrFileTimeShowID;
    }
    update();
  }

  void canShowFloatingButton(bool status) {
    _showFloatingButton = status;
    update();
  }



  double _getFileSizeFromPlatformFileToDouble(PlatformFile platformFile)  {
    return (platformFile.size / (1024 * 1024));
  }

  Future<double> _getMultipleFileSizeFromPlatformFiles(List<XFile> platformFiles)  async {
    double fileSize = 0.0;
    for (var element in platformFiles) {
      int sizeInKB =  await element.length();
      double sizeInMB = sizeInKB / (1024 * 1024);
      fileSize  = sizeInMB + fileSize;
    }
    return fileSize;
  }

}