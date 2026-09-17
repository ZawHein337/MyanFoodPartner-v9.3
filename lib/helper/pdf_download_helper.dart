import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfDownloadHelper {

  static Future<Directory> getProjectDirectory(String projectName) async {

    String cleanedInput = projectName.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    cleanedInput[0].toUpperCase() + cleanedInput.substring(1).toLowerCase();

    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = Directory('/storage/emulated/0/Download/$cleanedInput');
    } else if (Platform.isIOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      downloadsDirectory = Directory('${documentsDirectory.path}/$cleanedInput');
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }

    return downloadsDirectory;
  }

}