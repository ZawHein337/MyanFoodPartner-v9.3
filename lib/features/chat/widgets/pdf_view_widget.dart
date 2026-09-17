import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/pdf_download_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

class PdfViewWidget extends StatelessWidget {
  final Message currentMessage;
  final bool isRightMessage;
  const PdfViewWidget({super.key, required this.currentMessage, required this.isRightMessage});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentMessage.filesFullUrl!.length,
        itemBuilder: (context, index){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).hintColor, width: 0.3),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: (){
            // downloadPdf(currentMessage.filesFullUrl![index]);
            _openFile(currentMessage.filesFullUrl![index]);
          },
          child: Center(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Image.asset(Images.fileIcon, height: 30, width: 30),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(child: Text(
                  '${'attachment'.tr} ${index + 1}.pdf',
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                )),


              ]),
            ),
          ),
        ),
      );
    });
  }

  void _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showCustomSnackBar('could_not_open_file'.tr);
    }
  }

  Future<void> downloadPdf(String url) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();

      if (status.isGranted) {
        var response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          Directory directory = await PdfDownloadHelper.getProjectDirectory(Get.find<SplashController>().configModel?.businessName ?? AppConstants.appName);

          String fileExtension = 'pdf';
          String fileName = generateUniqueFileName(fileExtension);
          String filePath = path.join(directory.path, fileName);

          // Write the file to the directory
          File file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          String relativePath = file.path.replaceAll('/storage/emulated/0/', '');

          showCustomSnackBar('${'download_complete_file_saved_at'.tr} $relativePath', isError: false);
        } else {
          showCustomSnackBar('download_failed'.tr);
        }
      } else if (status.isDenied || status.isPermanentlyDenied) {
        showCustomSnackBar('permission_denied_cannot_download_the_file'.tr);
      }
    } catch (e) {
      showCustomSnackBar('download_failed'.tr);
    }
  }

  String generateUniqueFileName(String fileExtension) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'File_$timestamp.$fileExtension';
  }

}
