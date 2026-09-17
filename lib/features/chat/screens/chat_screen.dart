import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/conversation_details_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/message_bubble_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final User? user;
  final int? conversationId;
  final int? index;
  final bool fromNotification;
  const ChatScreen({super.key, required this.notificationBody, required this.user, this.conversationId, this.index, this.fromNotification = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  final FocusNode _inputMessageFocus = FocusNode();
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<ChatController>().getMessages(1, widget.notificationBody!, widget.user, widget.conversationId, firstLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, result) async{
          if(widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            return;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 2,
            backgroundColor: Theme.of(context).cardColor,
            surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
            leading: IconButton(
              onPressed: () {
                if(widget.fromNotification) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                }else {
                  Get.back();
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: Row(children: [

              ClipOval(
                child: Image.network(
                  '${chatController.messageModel != null ? chatController.messageModel?.conversation?.receiver?.imageFullUrl : Get.find<SplashController>().configModel!.logoFullUrl}',
                  errorBuilder: (context, error, stackTrace) => Image.asset(Images.placeholder, fit: BoxFit.cover, height: 40, width: 40,),
                  fit: BoxFit.cover, height: 40, width: 40,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                chatController.messageModel != null ? Text(
                  '${chatController.messageModel?.conversation?.receiver?.fName ?? Get.find<SplashController>().configModel!.businessName}'' ${chatController.messageModel?.conversation?.receiver?.lName ?? ''}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ) : Container(
                  height: 15, width: 100, color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                ),

                (chatController.messageModel != null && chatController.messageModel!.conversation!.receiver?.phone != null) ? Text(
                  '${chatController.messageModel!.conversation!.receiver!.phone}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ) : const SizedBox(),

              ]),

            ]),

          ),

          body: _isLoggedIn ? SafeArea(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  GetBuilder<ChatController>(builder: (chatController) {
                    return Expanded(child: chatController.messageModel != null ? chatController.messageModel!.messages!.isNotEmpty ? SingleChildScrollView(
                      controller: _scrollController,
                      reverse: true,
                      child: PaginatedListViewWidget(
                        scrollController: _scrollController,
                        reverse: true,
                        totalSize: chatController.messageModel?.totalSize,
                        offset: chatController.messageModel?.offset,
                        onPaginate: (int? offset) async => await chatController.getMessages(
                          offset!, widget.notificationBody!, widget.user, widget.conversationId,
                        ),
                        productView: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: chatController.messageModel!.messages!.length,
                          itemBuilder: (context, index) {
                            return MessageBubbleWidget(
                              previousMessage: index == 0 ? null : chatController.messageModel?.messages?.elementAt(index-1),
                              currentMessage: chatController.messageModel!.messages![index],
                              nextMessage: index == (chatController.messageModel!.messages!.length - 1) ? null : chatController.messageModel?.messages?.elementAt(index+1),
                              user: chatController.messageModel!.conversation!.sender,
                              userType: widget.notificationBody!.deliveryManId != null ? UserType.delivery_man : UserType.customer,
                            );
                          },
                        ),
                      ),
                    ) : Center(child: Column(mainAxisSize: MainAxisSize.min, children: [

                      const CustomAssetImageWidget(image: Images.messageEmpty, height: 70, width: 70),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text('no_message_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                    ])) : const ConversationDetailsShimmer());
                  }),

                  (chatController.messageModel != null && (chatController.messageModel!.status! || chatController.messageModel!.messages!.isEmpty)) ?  Container(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    child: Column(children: [

                      chatController.pickedVideoFile != null ? Container(
                        width: 250,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                          const Icon(Icons.video_collection, size: 30),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                            Text(chatController.pickedVideoFile!.name,
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                            ),

                          ])),


                          InkWell(
                            onTap: () {
                              chatController.pickVideoFile(true);
                            },
                            child: Padding(padding: const EdgeInsets.only(top: 5),
                              child: Align(alignment: Alignment.topRight,
                                child: Icon(Icons.close,
                                  size: Dimensions.paddingSizeLarge,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          )

                        ]),
                      ) : const SizedBox(),

                      chatController.objFile.isNotEmpty ? SizedBox(
                        height: 70,
                        child: ListView.separated(
                          shrinkWrap: true, scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 0, top: 5),
                          separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeDefault),
                          itemCount: chatController.objFile.length,
                          itemBuilder: (context, index){
                            // String fileSize = ImageSize.getImageSizeFromXFile(chatController.objFile![index]);
                            return Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              padding: const EdgeInsets.only(left: 10, right: 5),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                                Image.asset(Images.fileIcon,height: 30, width: 30),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall,),

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                                  Text(chatController.objFile[index].name,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  ),

                                ])),

                                InkWell(
                                  onTap: () {
                                    chatController.pickFile(true, index: index);
                                  },
                                  child: Padding(padding: const EdgeInsets.only(top: 5),
                                    child: Align(alignment: Alignment.topRight,
                                      child: Icon(Icons.close,
                                        size: Dimensions.paddingSizeLarge,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                )

                              ]),
                            );
                          },
                        ),
                      ) : const SizedBox(),

                      GetBuilder<ChatController>(builder: (chatController) {

                        return chatController.chatImage!.isNotEmpty ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chatController.chatImage!.length,
                            itemBuilder: (BuildContext context, index){
                              return  chatController.chatImage!.isNotEmpty ? Padding(
                                padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall,
                                  top: Dimensions.paddingSizeDefault,
                                ),
                                child: Stack(clipBehavior: Clip.none, children: [

                                  Container(width: 50, height: 60,
                                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                      child: Image.file(
                                        File(chatController.chatImage![index].path), width: 50, height: 60, fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: -5, right: -10,
                                    child: InkWell(
                                      onTap : () => chatController.removeImage(index, _inputMessageController.text.trim()),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Icon(Icons.clear, color: Theme.of(context).cardColor, size: 15),
                                        ),
                                      ),
                                    ),
                                  )],
                                ),
                              ) : const SizedBox();
                            },
                          ),
                        ) : const SizedBox();
                      }),

                      (chatController.isLoading && chatController.chatImage!.isNotEmpty) ? Align(alignment: Alignment.centerRight, child: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                          '${'uploading'.tr} ${chatController.chatImage?.length} ${'images'.tr}',
                          style: robotoMedium.copyWith(color: Theme.of(context).hintColor),
                        ),
                      )) : const SizedBox(),

                      Container(
                        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.5), width: 1),
                              ),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                InkWell(
                                  onTap: () {
                                    _inputMessageFocus.unfocus();
                                    chatController.toggleEmojiPicker();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall + 2, right: Dimensions.paddingSizeSmall),
                                    child: Icon(Icons.emoji_emotions_outlined, color: Theme.of(context).hintColor),
                                  ),
                                ),

                                Expanded(
                                  child: TextField(
                                    inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                                    controller: _inputMessageController,
                                    textCapitalization: TextCapitalization.sentences,
                                    style: robotoRegular,
                                    keyboardType: TextInputType.multiline,
                                    focusNode: _inputMessageFocus,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type_a_massage'.tr,
                                      hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                                    ),
                                    onTap: () {
                                      if (chatController.isEmojiPickerVisible) {
                                        chatController.toggleEmojiPicker();
                                      }
                                    },
                                    onSubmitted: (String newText) {
                                      if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                                        Get.find<ChatController>().toggleSendButtonActivity();
                                      }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                                        Get.find<ChatController>().toggleSendButtonActivity();
                                      }
                                    },
                                    onChanged: (String newText) {
                                      if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                                        Get.find<ChatController>().toggleSendButtonActivity();
                                      }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                                        Get.find<ChatController>().toggleSendButtonActivity();
                                      }
                                    },
                                  ),
                                ),

                                InkWell(
                                  onTap: () async {
                                    Get.find<ChatController>().pickImage(false);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                    child: CustomAssetImageWidget(image: Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                                  ),
                                ),

                                MenuAnchor(
                                  builder: (BuildContext context, MenuController controller, Widget? child) {

                                    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

                                    return InkWell(
                                      onTap: () async {
                                        _inputMessageFocus.unfocus();

                                        if (!isKeyboardOpen) {
                                          if (controller.isOpen) {
                                            controller.close();
                                          } else {
                                            controller.open();
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                        child: CustomAssetImageWidget(image: Images.attachment, width: 25, height: 25, color: Theme.of(context).hintColor),
                                      ),
                                    );
                                  },
                                  menuChildren: List<MenuItemButton>.generate(2, (int index) => MenuItemButton(
                                    onPressed: () {
                                      if(index == 0) {
                                        Get.find<ChatController>().pickFile(false);
                                      } else {
                                        Get.find<ChatController>().pickVideoFile(false);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(index == 0 ? Icons.file_copy_outlined : Icons.video_collection_outlined, size: 18, color: Theme.of(context).primaryColor),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        Text(index == 0 ? 'pick_files'.tr : 'pick_video'.tr, style: robotoMedium),
                                      ],
                                    ),
                                  ),
                                  ),
                                ),

                              ]),
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.5), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: GetBuilder<ChatController>(builder: (chatController) {
                              return chatController.isLoading ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
                              ) : InkWell(
                                onTap: () async {
                                  if(chatController.isSendButtonActive) {
                                    await chatController.sendMessage(
                                      message: _inputMessageController.text, notificationBody: widget.notificationBody, conversationId: widget.conversationId, index: widget.index,
                                    ).then((value) {
                                      if(value!.statusCode == 200){
                                        Future.delayed(const Duration(seconds: 2),() {
                                          chatController.getMessages(1, widget.notificationBody!, widget.user, widget.conversationId);
                                        });
                                      }
                                    });
                                    _inputMessageController.clear();
                                  }else{
                                    showCustomSnackBar('write_somethings'.tr);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: chatController.isLoading ? const SizedBox(
                                    child: CircularProgressIndicator(),
                                  ) : CustomAssetImageWidget(
                                    image: Images.sendIcon, width: 40, height: 40,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              );
                            }),
                          ),

                        ]),
                      ),

                      if (chatController.isEmojiPickerVisible)
                        SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              if (!chatController.isSendButtonActive) {
                                chatController.toggleSendButtonActivity();
                              }
                            },
                            textEditingController: _inputMessageController,
                            config: Config(
                              checkPlatformCompatibility: true,
                              emojiViewConfig: EmojiViewConfig(
                                emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ?  1.20 :  1.0),
                              ),
                              skinToneConfig: const SkinToneConfig(),
                              categoryViewConfig: const CategoryViewConfig(),
                              bottomActionBarConfig: const BottomActionBarConfig(),
                              searchViewConfig: const SearchViewConfig(),
                            ),
                          ),
                        ),

                    ]),
                  ) : const SizedBox(),
                ]),
              ),
            ),
          ) : Center(child: Text('not_login'.tr)),
        ),
      );
    });
  }
}