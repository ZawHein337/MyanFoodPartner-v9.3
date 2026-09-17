import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';

Future<void> capturedImageToPdf({Uint8List? capturedImage, required String businessName, required String orderId}) async {
  if (capturedImage == null) return;

  final pdf = pw.Document();
  final image = pw.MemoryImage(capturedImage);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/${'invoice'.tr}-$orderId.pdf");

  await file.writeAsBytes(await pdf.save());

  try {
    await OpenFile.open(file.path);
  } catch (e) {
    showCustomSnackBar('file_opening_failed'.tr);
  }
}